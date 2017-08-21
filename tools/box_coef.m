% Use the JEMS and STRATOGEM data to calculate the coefficients (cgbr) for 
% the forward model.
% 
% Created in 2014
%
% Revision
% 2014/06/15
% Redefine river discharge - use linear regression with Fraser & Englishman
% river. See the details in get_river.m
%
% Chuning Wang
% 2015/02/11

clc; clear; close all

rtdir = '/ocean/cnwang/code/boxmodel/';

STRATO = load([rtdir 'CTD.mat']);
JEMS = load([rtdir 'CTD_HS.mat']);
BOX = load([rtdir 'salinity_flux3.mat']);

% JEMS.mtime = JEMS.mtime(JEMS.station==3);
% JEMS.S_Ju = JEMS.S_Ju(JEMS.station==3);
% JEMS.S_Jl = JEMS.S_Jl(JEMS.station==3);
% 
% JEMS.S_Ju(isnan(JEMS.mtime)) = [];
% JEMS.S_Jl(isnan(JEMS.mtime)) = [];
% JEMS.mtime(isnan(JEMS.mtime)) = [];
% 
% % Interpolate JEMS onto STRATOGEM
% 
% JEMS.S_Ju = interp1(JEMS.mtime,JEMS.S_Ju,STRATO.tt);
% JEMS.S_Jl = interp1(JEMS.mtime,JEMS.S_Jl,STRATO.tt);
% JEMS.mtime = STRATO.tt;

% Smooth the data a little bit - use loess smoothing here
% STRATO.Sug = smooth(STRATO.Sug,0.01,'loess');
% STRATO.Slg = smooth(STRATO.Slg,0.01,'loess');
% JEMS.S_Ju  = smooth(JEMS.S_Ju,0.01,'loess');
% JEMS.S_Jl  = smooth(JEMS.S_Jl,0.01,'loess');

%%

figure

subplot(2,1,1)

plot(STRATO.tt,STRATO.Sug,'--o')
hold on
plot(STRATO.tt,STRATO.Slg,'--or')
ylim([27 31])
xlim([datenum([2002 01 01 00 00 00]) datenum([2006 01 01 00 00 00])])
axdate

subplot(2,1,2)

plot(JEMS.tt,JEMS.Suh,'--o')
hold on
plot(JEMS.tt,JEMS.Slh,'--or')
ylim([29 33])
xlim([datenum([2002 01 01 00 00 00]) datenum([2006 01 01 00 00 00])])
axdate

dsgudt = diff(STRATO.Sug)./diff(STRATO.tt);
dshudt = diff(JEMS.Suh)./diff(JEMS.tt);
sgu2 = (STRATO.Sug(1:end-1)+STRATO.Sug(2:end))/2;
sgl2 = (STRATO.Slg(1:end-1)+STRATO.Slg(2:end))/2;
shu2 = (JEMS.Suh(1:end-1)+JEMS.Suh(2:end))/2;
shl2 = (JEMS.Slh(1:end-1)+JEMS.Slh(2:end))/2;
t2 = (STRATO.tt(1:end-1)+STRATO.tt(2:end))/2;

figure

subplot(2,1,1)

plot(t2,sgu2,'--o')
hold on
plot(t2,sgl2,'--or')
ylim([27 31])
xlim([datenum([2002 01 01 00 00 00]) datenum([2006 01 01 00 00 00])])
axdate

subplot(2,1,2)

plot(t2,shu2,'--o')
hold on
plot(t2,shl2,'--or')
ylim([29 33])
xlim([datenum([2002 01 01 00 00 00]) datenum([2006 01 01 00 00 00])])
axdate

close all

%%
% Use least square to get the coef

% Interface Area
Ag = 4e9; % [m^2]
Ah = 0.5e9; % [m^2]

% Thickness
hu = 50; % [m]

% Volume
Vgu = 1.125*Ag*hu; % [m^3]
Vhu = 1.125*Ah*hu; % [m^3]

% Mixing Velocity
omegag  = 0.0075e-3; % [m/s]
omegahm = (1e-3); % [m/s] !!!!!!!!!!!!!!!!!! Not consistent with reference

% River Discharge
[mtime, f] = get_river([1995 01 01 00 00 00]);
F = @(t) interp1(mtime,f,t);
F1 = F(t2);

% dsdt = @(cgbr,x) (24*60*60)*(1/Vgu)*(cgbr*(x(:,3)-x(:,1)).*(x(:,2)-x(:,1))-x(:,4).*x(:,2)+omegag*Ag*(x(:,2)-x(:,1)));
dsdt = @(cgbr,x) (24*60*60)*(1/Vgu)*((cgbr*(x(:,3)-x(:,1))-x(:,4)).*x(:,2)-cgbr*(x(:,3)-x(:,1)).*x(:,1)+omegag*Ag*(x(:,2)-x(:,1)));

% x1 = mean((Vgu*dsgudt*(1/24/60/60) + F1.*sgl2 - omegag*Ag*(sgl2-sgu2))./((shu2-sgu2).*(sgl2-sgu2)));

c = nlinfit([sgu2, sgl2, shu2, F1],dsgudt,dsdt,0.9e6);

% Reference Salinity
S0 = 33.5; % [PSU]

c = c*S0;

%%

% Stratification Damp
deltaSbar = 0.2; % [PSU]
ohah = 0.5*omegahm*Ah*min(deltaSbar./(shl2-shu2),1).*(1+sin(2*pi*t2/(365/24)));

dsdt = @(cfbr,x) (24*60*60)*(1/Vhu)*(c*(x(:,3)-x(:,1)).*(x(:,1)-x(:,3))+cfbr*(x()-x())*(x()-x())+omegag*Ag*(x(:,2)-x(:,1)));

























