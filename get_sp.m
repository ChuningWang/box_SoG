% Use wind data from LaPerouse to generate proper Sp for the model.
%
% Usage: 
%     [t, Sp] = get_sp(t_initial)
%
% Input:
%     t_initial - the beginning time of Sp
%
% Output:
%     t  - matlabtime for Sp
%     Sp - Pacific Salinity
%
% Chuning Wang
% 2015/02/11

function [t, Sp] = get_sp(t_initial)

if nargin < 1
    t_initial = datenum([1995 01 01 00 00 00]);
elseif nargin == 1
    t_initial = datenum(t_initial);
else
    error('Too many Imput arguments')
end

% clear; clc; close all

%% Load wind data

% cd /ocean/cnwang/ferry/data/others/windLaPerouse/
% 
% % Load LaPerouse data
% fid = fopen('c46206.csv');
% data = textscan(fid,...
%                 '%s %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f',...
%                 'headerlines',1,...
%                 'delimiter',',');
% fclose(fid);
% 
% lapr.stationID = data{1}(1);
% lapr.mtime     = datenum(data{2});
% lapr.lat       = datenum(data{4});
% lapr.lon       = datenum(data{5});
% wdir1          = data{12};
% wspd1          = data{13};
% wdir2          = data{16};
% wspd2          = data{17};
% w1             = wspd1.*exp(2*pi*1i*wdir1/360);
% w2             = wspd2.*exp(2*pi*1i*wdir2/360);
% w              = 0.5*(w1+w2);
% wdir           = 360*angle(w)/(2*pi);
% wdir(wdir<0)   = wdir(wdir<0)+360;
% wspd           = abs(w);
% lapr.wdir      = wdir;
% lapr.wspd      = wspd;
% 
% trange     = datenum(lapr.mtime)>datenum([1994 01 01 00 00 00]);
% lapr.mtime = lapr.mtime(trange);
% lapr.wdir  = lapr.wdir(trange);
% lapr.wspd  = lapr.wspd(trange);
% 
% wspd = lapr.wspd.*exp(1i*(90-lapr.wdir)*pi/180);
% walong = real(wspd*exp(1i*30*pi/180)); % Along-coast winds
% tt = lapr.mtime;
% 
% % Bin average
% 
% t = floor(tt(1)):1:floor(tt(end));
% w = NaN(size(t));
% 
% for i = 1:length(t)
%     msk = tt>=t(i) & tt<t(i)+1;
%     w(i) = nanmean(walong(msk));
% end
% 
% lapr_bin_avg.mtime = t;
% lapr_bin_avg.wspd_along = w;
% 
% % Generate climatology
% w_yravg = NaN(365,1);
% for i = 1:365
%     msk = yeardays(tt) == i;
%     w_yravg(i) = nanmean(walong(msk));
% end
% 
% lapr_climatology.mtime = 1:1:365;
% lapr_climatology.wspd_along = w_yravg;
% 
% save /ocean/cnwang/ferry/data/others/windLaPerouse/LaPerouse lapr lapr_bin_avg lapr_climatology

%%

% clear

load data/windLaPerouse/LaPerouse

t = lapr_bin_avg.mtime;
w = lapr_bin_avg.wspd_along;
w_cli = lapr_climatology.wspd_along;

% Use climatiology to substitute the NaNs in the dataset
kk = find(isnan(w));
kkd = yeardays(t(kk));
kkd(kkd==366) = 365;
w(kk) = w_cli(kkd);

% Filter
FL = 28;
w = filtfilt(ones(1,FL)/(FL),1,w);  % 4 week filter 

w(w>0) = 0; % Only use negative value

DeltaSp = w;

% Filter
FL = 7;
DeltaSp = filtfilt(ones(1,FL)/(FL),1,DeltaSp);  % 1 week filter 

% Normalize year to year
dvec = datevec(t);
yr   = dvec(:,1);

for i = 1994:2014
    msk = yr==i;
    DeltaSp(msk) = DeltaSp(msk)/min(DeltaSp(msk));
end

% plot(t,DeltaSp)
% xlim([t(1) t(end)])
% axdate

msk = t>=t_initial;
t = t(msk);
DeltaSp = DeltaSp(msk);

Spwbar = 33; % [PSU]
Spsbar = 1; % [PSU]

Sp = Spwbar + DeltaSp*Spsbar;

% save sp

end




