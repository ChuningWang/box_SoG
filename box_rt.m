% Box model for Georgia-Haro-Juan system
%
% Real-time run with actual river discharge and Sp
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
% Revision
% 2014/03/17
% Rearranged the equations again - improved mass conservation
%
% 2014/06/15
% Redefine river discharge - use linear regression with Fraser & Englishman
% river. See the details in get_river.m
% 
% 2014/06/16
% Redefine Pacific Salinity - relate it with along-shore wind acquired from
% bouy station C46206. Assume a base salinity, then add a DeltaSp onto it 
% when it is upwelling favored wind. See the details in get_sp.m

clc; clear; close all

global lamdad lamdahg lamdahf R2 R3 R4m R5 R6 ts deltaS f Spbar mtime Cbrs S0

% Constants
box_const

% Time Steps
mtime = datenum([1995 01 01 00 00 00]):deltat:datenum([2015 01 01 00 00 00]);

% Initial Condition
load('init_cond.mat', 'S_i')

% River Discharge
[t1, f] = get_river([1995 01 01 00 00 00]); % [m^3/s]
f = interp1(t1,f,mtime);

% Pacific Salinity
[t2, Spbar] = get_sp([1995 01 01 00 00 00]); % [PSU]
Spbar = interp1(t2,Spbar,mtime);

%% 
% First calculate salinity in each box
% Salinity is conserved so it can be used as an approximation for mass
% transfer

S      = NaN(length(mtime),6); % Non-dimensionalized Salinity
S(1,:) = S_i/S0; % Non-dimensionalized Initial Salinity

deltaS = deltaSbar/S0;

% Solve the equation using RK solver
S = rk_solver(S(1,:),mtime,@odefunc_salt_v2);

%%
% Calculate Flux Qg & Qf
% Q = C*beta*rho0*deltaS
Qg = Cbrs*(S(3,:)-S(1,:)); % [m^3s^-1]
Qf = R3*Cbrs*(S(5,:)-S(3,:)); % [m^3s^-1]

% if only use the last year output
% 
% yearcount = 1;
% tstep = tcount+1;
% tt = t(1:tcount+1);
% 
% S(1:end-tcount-1,:) = [];
% omegah(1:end-tcount-1) = [];
% Qg(1:end-tcount-1) = [];
% Qf(1:end-tcount-1) = [];

save('salt_flux.mat')