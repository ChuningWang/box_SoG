% All other calculations needed for the paper
%
% fpeak: maximum river discharge of a year
% sgupeak: maximum salinity in SoG upper box
% sgulow: minimum salinity in SoG lower box
%
% Chuning Wang
% 2015/02/11
%
% Revision:
% Since all the sections (asgasflux, boxmodel, o2, productivity, etc.) have
% different outputs, which are difficult to maintain, here I write a
% function to generate a mat file containing all the useful outputs for
% each section, and name it after the main variable name (o2gasf, o2adv,
% o2, pnc). The function itself names like *_calc.m (as_calc.m, box_calc.m,
% o2_calc.m, prod_calc.m).
% The mat file contains:
%     mtime for each variable
%     data for each variable
%     unit for each variable
%
% Chuning Wang
% 2015/03/10
%

clc; clear; close all

rtdir = '/ocean/cnwang/code/boxmodel/';

load([rtdir 'salinity_flux3.mat'])

% Find maximum river flow in each year

dvec = datevec(mtime);
yr   = dvec(:,1);

S = S*S0;

k = 0;
for i = 1995:2014
    kk = yr==i;
    k=k+1;
    fpeak(k) = max(f(kk));
    sgupeak(k) = max(S(1,kk));
    sgulow(k) = min(S(1,kk));
end

%% Calculate volume fluxes and o2 fluxes

clearvars -except rtdir

load([rtdir 'salinity_flux3.mat'], 'mtime','f','Qg','Ag')
load([rtdir 'frasero2.mat'],'o2_m')
load([rtdir 'o2climatological.mat'],'o2u','o2l')

Qg = Qg(:); f = f(:); mtime = mtime(:); o2_m = o2_m(:); o2l = o2l(:); o2u = o2u(:);

% Filter with a window of 2 weeks
Qg = smooth(Qg,15);

yr = ceil((mtime(end)-mtime(1))/365);
dvec = datevec(mtime(1));
yr1 = dvec(1);

o2u = repmat(o2u,yr,1);
o2l = repmat(o2l,yr,1);
o2_m = repmat(o2_m,yr,1);

for iter = 1:yr*12
    mt2(iter) = datenum([yr1+floor(iter/12-0.000001) mod(iter-1,12)+1 15 00 00 00]);
end

mt2 = mt2(:);

o2f   = interp1(mt2,o2_m,mtime);
o2gu   = interp1(mt2,o2u,mtime);
o2gl   = interp1(mt2,o2l,mtime);

o2a = -Qg.*o2gu+(Qg-f).*o2gl+f.*o2f;

% Change Units
s2day = 24*60*60; % s to day
ml2mg = 1.43; % ml/l(o2) to mg/l(o2)
Ro2c = (106*12)/(138*32); % o2 to c (Redfield Ratio)

o2a = o2a*s2day*Ro2c*ml2mg/Ag;

o2adv.mt = mtime(:);
o2adv.o2adv = o2a(:);
o2adv.o2adv_unit = 'gCm-2day-1';
o2adv.Qg = Qg(:);
o2adv.Qg_unit = 'm3s-1';
o2adv.f = f(:);
o2adv.f_unit = 'm3s-1';
o2adv.o2f = o2f(:);
o2adv.o2f_unit = 'ml/l';
o2adv.o2gu = o2gu(:);
o2adv.o2gu_unit = 'ml/l';
o2adv.o2gl = o2gl(:);
o2adv.o2gl_unit = 'ml/l';

save([rtdir 'o2adv.mat'],'o2adv')

