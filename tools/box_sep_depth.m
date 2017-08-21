% Box model for Georgia-Haro-Juan system
%
% This six box model calculate salinity and mass flux in the
% Georgia-Haro-Juan system. More detail in Li et al. 1999
%
% Reference
% Li, M., Gargett, A. E. & Denman, K. L. 1999, Seasonal and interannual
% variability of estuarine circulation in a box model of the Strait of
% Georgia and Juan de Fuca Strait. Atmosphere-Ocean 37, 1-19
%
% Chuning Wang
%
% Created in early 2014
%
% Revised on 2014/03/17
% Rearranged the equations again - improved mass conservation

clc; clear; close all

% addpath(genpath('/ocean/cnwang/courses/eosc511/project/code/'))

% Parameters

global lamdad lamdahg lamdahf R2 R3 R4m R5 R6 ts deltaS f Spbar mtime Cbrs S0

box_const

hu_i = [20, 21, 23, 25, 30, 35, 40, 50, 60, 70, 80, 100];

% River Discharge

[t1, f] = get_river([1995 01 01 00 00 00]); % [m^3/s]

dvec = datevec(t1);
msk = dvec(:,2)==2 & dvec(:,3)==29;
f(msk) = [];
f = f(1:365*17);
f = nanmean(reshape(f,365,17),2);
f(366) = f(1);

% Pacific Salinity
[t2, Spbar] = get_sp([1995 01 01 00 00 00]); % [PSU]

dvec = datevec(t2);
msk = dvec(:,2)==2 & dvec(:,3)==29;
Spbar(msk) = [];
Spbar = Spbar(1:365*17);
Spbar = nanmean(reshape(Spbar,365,17),2);
Spbar(366) = Spbar(1);

for iter = 1:length(hu_i)

% Surface Area
Agu = 5e9; % [m^2]
Ahu = 0.625e9; % [m^2]
Afu = 2.5e9; % [m^2]

% Bottom Area
Agl = 1e9; % [m^2]
Ahl = 0.125e9; % [m^2]
Afl = 0.5e9; % [m^2]

% Thickness
hu = hu_i(iter); % [m]
hl = 200-hu; % [m]

% Interface Area
% Ag = 4e9; % [m^2]
% Ah = 0.5e9; % [m^2]
% Af = 2e9; % [m^2]
Ag = hu/200*Agu+hl/200*Agl; % [m^2]
Ah = hu/200*Ahu+hl/200*Ahl; % [m^2]
Af = hu/200*Afu+hl/200*Afl; % [m^2]

% Volume
V = [Ag*hu; Ag*hl; Ah*hu; Ah*hl; Af*hu; Af*hl]; % [m^3]
% Vgu = Ag*hu; % [m^3]
% Vgl = Ag*hl; % [m^3]
% Vhu = Ah*hu; % [m^3]
% Vhl = Ah*hl; % [m^3]
% Vfu = Af*hu; % [m^3]
% Vfl = Af*hl; % [m^3]
% Vgu = 1.125*Ag*hu; % [m^3]
% Vgl = 0.625*Ag*hl; % [m^3]
% Vhu = 1.125*Ah*hu; % [m^3]
% Vhl = 0.625*Ah*hl; % [m^3]
% Vfu = 1.125*Af*hu; % [m^3]
% Vfl = 0.625*Af*hl; % [m^3]
Vgu = 0.5*(Agu+Ag)*hu; % [m^3]
Vgl = 0.5*(Ag+Agl)*hl; % [m^3]
Vhu = 0.5*(Ahu+Ah)*hu; % [m^3]
Vhl = 0.5*(Ah+Ahl)*hl; % [m^3]
Vfu = 0.5*(Afu+Af)*hu; % [m^3]
Vfl = 0.5*(Af+Afl)*hl; % [m^3]

Vg = Vgu + Vgl; % [m^3]
Vh = Vhu + Vhl; % [m^3]
Vf = Vfu + Vfl; % [m^3]

%% ------------------------------------------------------------------------

% First calculate salinity in each box
% Salinity is conserved so it can be used as an approximation for mass
% transfer

% Initial Condition
S            = NaN(6,365); % Non-dimensionalized Salinity
S(:,1)       = Sinitbar/S0; % Non-dimensionalized Initial Salinity

% Time Steps
mtime = 1:1:366;

% Salinity [Li et al. 1999]
% Non-dimensionalize
lamdad  = hu/hl;
lamdahg = Vh/Vg;
lamdahf = Vh/Vf;

R2      = omegag*Ag/Cbrs;
R3      = 3; % Cf/Cg
R4m     = omegahm*Ah/Cbrs;
R5      = omegaf*Af/Cbrs;
ts      = deltat*Vgu/Cbrs/24/60/60;
R6      = ts/tr;
% R6 = 0.12; % In Li et al. 1999 they 'choose' 0.12

deltaS = deltaSbar/S0;

delta = 1;
kk    = 0; % Counter

while delta>1e-6
    kk = kk+1;
    % Solve the equation using RK solver
    S = rk_solver(S(:,1),mtime,@odefunc_salt_v2_init);
    delta = sum((S(:,end)-S(:,1)).^2)/6;
    S(:,1) = S(:,end);
end

S   = S*S0;
S_i(iter,:) = mean(S,2);

end

save sep_depth hu_i S_i

%%

figure('visible','off')
plot(hu_i,S_i(:,1),'-ok','linewidth',1.5)
hold on
plot(hu_i,S_i(:,2),'--ok','linewidth',1.5)
plot(hu_i,S_i(:,3),'-^k','linewidth',1.5)
plot(hu_i,S_i(:,4),'--^k','linewidth',1.5)
plot(hu_i,S_i(:,5),'-sk','linewidth',1.5)
plot(hu_i,S_i(:,6),'--sk','linewidth',1.5)
% ylim([29 34])
xlabel('Separation Depth [m]')
ylabel('Salinity [g/kg]')
legend('S_g_u','S_g_l','S_h_u','S_h_l','S_j_u','S_j_l','orientation','horizontal')

print -depsc sep_depth


