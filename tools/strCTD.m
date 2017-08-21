% Read SoG CTD casts
%
% Chuning Wang
% Created in early 2014
%
% -------------------------------------------------------------------------
% Revision on June 04, 2014
% Instead of averaging directly over depth, I use hypsography data
% provided by Rich Pawlowicz and average with weight.
% -------------------------------------------------------------------------

clc;clear;close all

rtdir = '/ocean/cnwang/code/boxmodel/';

ctddir = '/ocean/cnwang/ferry/data/CTD/';

fileID = dir([ctddir 'S*.mat']);

% Load hypsography
load /ocean/rich/more/clim/bathy/SoGhyps

% Generate weight for upper and lower boxes
W1 = SoGhyps.Area(1:50)/sum(SoGhyps.Area(1:50)); W1 = W1(:);
W2 = SoGhyps.Area(51:200)/sum(SoGhyps.Area(51:200)); W2 = W2(:);

%% 
% Mark find me some compiled mat file he used for his work. It is very
% useful and very easy to use. So I redo the coding work to use it.

% -------------------------------------------------------------------------
% Revision on June 04, 2014
% Change the way to average - average salinity in each layer then use the
% weight function
% -------------------------------------------------------------------------

for i = 1:size(fileID,1)

    load([ctddir fileID(i).name])

end

lat = nanmean(...
               [S1.LAT;  S21.LAT; S22.LAT;...
                S23.LAT; S3.LAT;  S41.LAT;...
                S42.LAT; S43.LAT; S5.LAT],...
              2);
          
lon = nanmean(...
               [S1.LON;  S21.LON; S22.LON;...
                S23.LON; S3.LON;  S41.LON;...
                S42.LON; S43.LON; S5.LON],...
              2);
          
dep = [nanmean(max(S1.PR));  nanmean(max(S21.PR)); nanmean(max(S22.PR));...
       nanmean(max(S23.PR)); nanmean(max(S3.PR));  nanmean(max(S41.PR));...
       nanmean(max(S42.PR)); nanmean(max(S43.PR)); nanmean(max(S5.PR))];

tt = nanmean(...
              [S1.MT;  S21.MT; S22.MT;...
               S23.MT; S3.MT;  S41.MT;...
               S42.MT; S43.MT; S5.MT],...
             1);

for i = 1:48

Sg(:,i) = nanmean(...
              [S1.SS(:,i),  S21.SS(:,i), S22.SS(:,i),...
               S23.SS(:,i), S3.SS(:,i),  S41.SS(:,i),...
               S42.SS(:,i), S43.SS(:,i), S5.SS(:,i)],...
             2);

Tg(:,i) = nanmean(...
              [S1.TT(:,i),  S21.TT(:,i), S22.TT(:,i),...
               S23.TT(:,i), S3.TT(:,i),  S41.TT(:,i),...
               S42.TT(:,i), S43.TT(:,i), S5.TT(:,i)],...
             2);

end

Sg = Sg(1:200,:); Tg = Tg(1:200,:);
Sug = nansum(Sg(1:50,:).*repmat(W1,1,48),1);
Slg = nansum(Sg(51:200,:).*repmat(W2,1,48),1);
Tug = nansum(Tg(1:50,:).*repmat(W1,1,48),1);
Tlg = nansum(Tg(51:200,:).*repmat(W2,1,48),1);

% Sug = nanmean(...
%               [S1.SS(1:50,:);  S21.SS(1:50,:); S22.SS(1:50,:);...
%                S23.SS(1:50,:); S3.SS(1:50,:);  S41.SS(1:50,:);...
%                S42.SS(1:50,:); S43.SS(1:50,:); S5.SS(1:50,:)].*repmat(W1,9,48),...
%              1);
% 
% Slg = nanmean(...
%               [S1.SS(51:200,:);  S21.SS(51:200,:); S22.SS(51:200,:);...
%                S23.SS(51:200,:); S3.SS(51:200,:);  S41.SS(51:200,:);...
%                S42.SS(51:200,:); S43.SS(51:200,:); S5.SS(51:200,:)].*repmat(W2,9,48),...
%              1);
% 
% Tug = nanmean(...
%               [S1.TT(1:50,:);  S21.TT(1:50,:); S22.TT(1:50,:);...
%                S23.TT(1:50,:); S3.TT(1:50,:);  S41.TT(1:50,:);...
%                S42.TT(1:50,:); S43.TT(1:50,:); S5.TT(1:50,:)].*repmat(W1,9,48),...
%              1);
% 
% Tlg = nanmean(...
%               [S1.TT(51:200,:);  S21.TT(51:200,:); S22.TT(51:200,:);...
%                S23.TT(51:200,:); S3.TT(51:200,:);  S41.TT(51:200,:);...
%                S42.TT(51:200,:); S43.TT(51:200,:); S5.TT(51:200,:)].*repmat(W2,9,48),...
%              1);

tt = tt(:); Sug = Sug(:); Slg = Slg(:); Tug = Tug(:); Tlg = Tlg(:);

datacheck(1,:) = isnan(S1.MT);
datacheck(2,:) = isnan(S21.MT);
datacheck(3,:) = isnan(S22.MT);
datacheck(4,:) = isnan(S23.MT);
datacheck(5,:) = isnan(S3.MT);
datacheck(6,:) = isnan(S41.MT);
datacheck(7,:) = isnan(S42.MT);
datacheck(8,:) = isnan(S43.MT);
datacheck(9,:) = isnan(S5.MT);

save([rtdir 'CTD.mat'], 'tt', 'Sug', 'Slg', 'Tug', 'Tlg')

%% Read HS CTD casts

% -------------------------------------------------------------------------
% Revision June 04, 2014
% Because I use hypsography to weight the average, the messy depth in SJ**
% is hard to use. To simplify it I interpolate the original data to a grid
% of 1:1:200m.
% -------------------------------------------------------------------------

clc; close all
clearvars -except rtdir

load('/ocean/oriche/SoG/JEMS_timeseries/JEMS.mat');
% HS2 = load('/ocean/oriche/SoG/JEMS2005/JEMS.mat');
load([rtdir 'CTD.mat'],'tt');

% Load hypsography
load /ocean/rich/more/clim/bathy/SoGhyps
SoGhyps.depth = SoGhyps.depth(1:200);
SoGhyps.Area = SoGhyps.Area(1:200);
SoGhyps.Vol = SoGhyps.Vol(1:200);

SJ00.DP(SJ00.DP <= 0) = NaN;
SJ01.DP(SJ01.DP <= 0) = NaN;
SJ02.DP(SJ02.DP <= 0) = NaN;
SJ00.SS(SJ00.SS < 2) = NaN;
SJ01.SS(SJ01.SS < 2) = NaN;
SJ02.SS(SJ02.SS < 2) = NaN;
SJ00.TT(SJ00.TT < 2) = NaN;
SJ01.TT(SJ01.TT < 2) = NaN;
SJ02.TT(SJ02.TT < 2) = NaN;

% Interpolate onto depth from 1 to 200m

D = 1:1:200; D = D(:);

for i = 1:37
    tempd0 = SJ00.DP(:,i); temps0 = SJ00.SS(:,i); tempt0 = SJ00.TT(:,i);
    temps0(isnan(tempd0)) = []; tempt0(isnan(tempd0)) = []; tempd0(isnan(tempd0)) = [];
    tempd1 = SJ01.DP(:,i); temps1 = SJ01.SS(:,i); tempt1 = SJ01.TT(:,i);
    temps1(isnan(tempd1)) = []; tempt1(isnan(tempd1)) = []; tempd1(isnan(tempd1)) = [];
    
    sh00ss(:,i) = interp1(tempd0,temps0,D);
    sh01ss(:,i) = interp1(tempd1,temps1,D);
    
    sh00tt(:,i) = interp1(tempd0,tempt0,D);
    sh01tt(:,i) = interp1(tempd1,tempt1,D);
end

for i = 1:36
    tempd2 = SJ00.DP(:,i); temps2 = SJ00.SS(:,i); tempt2 = SJ00.TT(:,i);
    temps2(isnan(tempd2)) = []; tempt2(isnan(tempd2)) = []; tempd2(isnan(tempd2)) = [];
    sh02ss(:,i) = interp1(tempd2,temps2,D);
    sh02tt(:,i) = interp1(tempd2,tempt2,D);
end

sh02ss = [sh02ss(:,1:22), NaN(200,1), sh02ss(:,23:end)];
sh02tt = [sh02tt(:,1:22), NaN(200,1), sh02tt(:,23:end)];

th = SJ00.mtime;

for i = 1:37
    Sh(:,i) = nanmean([sh00ss(:,i), sh01ss(:,i), sh02ss(:,i)],2);
    Th(:,i) = nanmean([sh00tt(:,i), sh01tt(:,i), sh02tt(:,i)],2);
end

for i = 1:37
    kk = ~isnan(Sh(:,i)) & D<=50;
    tempd = D(kk); temps = Sh(kk,i); tempt = Th(kk,i); tempa = SoGhyps.Area(kk);
    Suh(i) = nansum(temps.*tempa')/nansum(tempa);
    Tuh(i) = nansum(tempt.*tempa')/nansum(tempa);
    
    kk = ~isnan(Sh(:,i)) & D>50;
    tempd = D(kk); temps = Sh(kk,i); tempt = Th(kk,i); tempa = SoGhyps.Area(kk);
    Slh(i) = nansum(temps.*tempa')/nansum(tempa);
    Tlh(i) = nansum(tempt.*tempa')/nansum(tempa);
end

% Interpolate
Suh = interp1(th,Suh,tt);
Tuh = interp1(th,Tuh,tt);
Slh = interp1(th,Slh,tt);
Tlh = interp1(th,Tlh,tt);

% Weight Average

% t = SJ00.mtime;
% Slh00 = interp1(t,Slh00,tt);

% % SJ00
% t = SJ00.mtime;
% v = SJ00.DP<=50;
% w = NaN(size(SJ00.DP));
% x = w;
% w(v) = SJ00.SS(v);
% x(v) = SJ00.TT(v);
% Suh00 = nanmean(w,1);
% Tuh00 = nanmean(x,1);
% Suh00 = interp1(t,Suh00,tt);
% Tuh00 = interp1(t,Tuh00,tt);
% 
% v = SJ00.DP>50 & SJ00.DP<150;
% w = NaN(size(SJ00.DP));
% x = w;
% w(v) = SJ00.SS(v);
% x(v) = SJ00.TT(v);
% Slh00 = nanmean(w,1);
% Tlh00 = nanmean(x,1);
% Slh00 = interp1(t,Slh00,tt);
% Tlh00 = interp1(t,Tlh00,tt);
% 
% % SJ01
% t = SJ01.mtime;
% v = SJ01.DP<=50;
% w = NaN(size(SJ01.DP));
% x = w;
% w(v) = SJ01.SS(v);
% x(v) = SJ01.TT(v);
% Suh01 = nanmean(w,1);
% Tuh01 = nanmean(x,1);
% Suh01(isnan(Suh01)) = nanmean(Suh01(find(isnan(Suh01))-1:find(isnan(Suh01))+1)); % Interpolate NaN
% Tuh01(isnan(Tuh01)) = nanmean(Tuh01(find(isnan(Tuh01))-1:find(isnan(Tuh01))+1)); % Interpolate NaN
% Suh01 = interp1(t,Suh01,tt);
% Tuh01 = interp1(t,Tuh01,tt);
% 
% v = SJ01.DP>50 & SJ01.DP<150;
% w = NaN(size(SJ01.DP));
% x = w;
% w(v) = SJ01.SS(v);
% x(v) = SJ01.TT(v);
% Slh01 = nanmean(w,1);
% Tlh01 = nanmean(x,1);
% Slh01 = interp1(t,Slh01,tt);
% Tlh01 = interp1(t,Tlh01,tt);
% 
% % SJ02
% t = SJ02.mtime;
% v = SJ02.DP<=50;
% w = NaN(size(SJ02.DP));
% x = w;
% w(v) = SJ02.SS(v);
% x(v) = SJ02.TT(v);
% Suh02 = nanmean(w,1);
% Tuh02 = nanmean(x,1);
% Suh02 = interp1(t,Suh02,tt);
% Tuh02 = interp1(t,Tuh02,tt);
% 
% v = SJ02.DP>50 & SJ02.DP<150;
% w = NaN(size(SJ02.DP));
% x = w;
% w(v) = SJ02.SS(v);
% x(v) = SJ02.TT(v);
% Slh02 = nanmean(w,1);
% Tlh02 = nanmean(x,1);
% Slh02 = interp1(t,Slh02,tt);
% Tlh02 = interp1(t,Tlh02,tt);
% 
% % Average
% Suh = (1/3)*(Suh00 + Suh01 + Suh02);
% Slh = (1/3)*(Slh00 + Slh01 + Slh02);
% Tuh = (1/3)*(Tuh00 + Tuh01 + Tuh02);
% Tlh = (1/3)*(Tlh00 + Tlh01 + Tlh02);
% 
% tt = tt(:); Suh = Suh(:); Slh = Slh(:); Tuh = Tuh(:); Tlh = Tlh(:);
% 
save([rtdir 'CTD_HS.mat'], 'tt', 'Suh', 'Slh', 'Tuh', 'Tlh')















