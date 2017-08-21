% Box model for Georgia-Haro-Juan system
%
% Use to generate the initial condition
% 
% This six box model calculate salinity and mass flux in the
% Georgia-Haro-Juan system. More detail in Li et al. 1999
%
% Reference
% Li, M., Gargett, A. E. & Denman, K. L. 1999 Seasonal and interannual
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

% River Discharge
[t1, f] = get_river([1995 01 01 00 00 00]); % [m^3/s]

dvec = datevec(t1);
msk = dvec(:,2)==2 & dvec(:,3)==29;
f(msk) = [];
f = f(1:365*17);
f = nanmean(reshape(f,365,17),2);
f(366) = f(1);
t1 = 1:366;

% Pacific Salinity
[t2, Spbar] = get_sp([1995 01 01 00 00 00]); % [PSU]

dvec = datevec(t2);
msk = dvec(:,2)==2 & dvec(:,3)==29;
Spbar(msk) = [];
Spbar = Spbar(1:365*17);
Spbar = nanmean(reshape(Spbar,365,17),2);
Spbar(366) = Spbar(1);
t2 = 1:366;

%%
% First calculate salinity in each box
% Salinity is conserved so it can be used as an approximation for mass
% transfer

% Time Steps
mtime = 1:deltat:366;
% Interpolate forcings
f = interp1(t1,f,mtime);
Spbar = interp1(t2,Spbar,mtime);

% Initial Condition
S            = NaN(6,length(mtime)); % Non-dimensionalized Salinity
S(:,1)       = Sinitbar/S0; % Non-dimensionalized Initial Salinity

deltaS = deltaSbar/S0;

delta = 1;
kk    = 0; % Counter

while delta>1e-6
    kk = kk+1;
    % Solve the equation using RK solver
    S = rk_solver(S(:,1),mtime,@odefunc_salt_v2);
    delta = sum((S(:,end)-S(:,1)).^2)/6;
    S(:,1) = S(:,end);
end

S_i = S(:,end)*S0;

save('init_cond.mat', 'S_i')

%% Save climatology
% Calculate Flux Qg & Qf
% Q = C*beta*rho0*deltaS
Qg = Cbrs*(S(3,:)-S(1,:)); % [m^3s^-1]
Qf = R3*Cbrs*(S(5,:)-S(3,:)); % [m^3s^-1]

save('salt_flux_clim.mat', 'mtime', 'f', 'Spbar', 'S', 'Qg', 'Qf')