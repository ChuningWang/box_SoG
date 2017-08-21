% Constants for the box model

% Time
deltat    = 1; % [day]
% t0        = 0; % [day]
% tstep     = yearcount*deltat*365+1; % [#]
% t         = t0 + deltat*(0:1:tstep-1); t = t(:); % [day]
% tcount    = 365/deltat; % [#]

% Relaxation Timescale [Li et al 1999]
tr = 20.4; % [day]

% Reference Salinity
S0 = 33.5; % [PSU]

% Initial Salinity
Sinitbar = S0*ones(6,1); % [PSU]

% Stratification Damp
deltaSbar = 0.2; % [PSU]

% To match the topography I set the shape of the box to be upturned
% trapzoids. The area here is the area at 50 m depth. The ratio
% surface/interface/bottom = 5:4:1. Thus the volume has to be changed
% accordingly - V_upper = 1.125*A*h, V_lower = 0.625*A*h.

% Interface Area
Ag = 4e9; % [m^2]
Ah = 0.5e9; % [m^2]
Af = 2e9; % [m^2]

% Thickness
hu = 50; % [m]
hl = 150; % [m]

% Volume
V = [Ag*hu; Ag*hl; Ah*hu; Ah*hl; Af*hu; Af*hl]; % [m^3]
% Vgu = Ag*hu; % [m^3]
% Vgl = Ag*hl; % [m^3]
% Vhu = Ah*hu; % [m^3]
% Vhl = Ah*hl; % [m^3]
% Vfu = Af*hu; % [m^3]
% Vfl = Af*hl; % [m^3]
Vgu = 1.125*Ag*hu; % [m^3]
Vgl = 0.625*Ag*hl; % [m^3]
Vhu = 1.125*Ah*hu; % [m^3]
Vhl = 0.625*Ah*hl; % [m^3]
Vfu = 1.125*Af*hu; % [m^3]
Vfl = 0.625*Af*hl; % [m^3]

Vg = Vgu + Vgl; % [m^3]
Vh = Vhu + Vhl; % [m^3]
Vf = Vfu + Vfl; % [m^3]

% Cg*beta*rho0*S0
Cbrs = 0.83e6; % [m^3s^-1]

% Mixing Velocity
omegag  = 0.0075e-3; % [m/s]
omegahm = (1e-3); % [m/s] !!!!!!!!!!!!!!!!!! Not consistent with reference
omegaf  = 0.025e-3; % [m/s]

% Salinity [Li et al. 1999]
% Non-dimensionalize
lamdad  = hu/hl;
lamdahg = Vh/Vg;
lamdahf = Vh/Vf;

R2      = omegag*Ag/Cbrs;
R3      = 3; % Cf/Cg
R4m     = omegahm*Ah/Cbrs;
R5      = omegaf*Af/Cbrs;
ts      = Vgu/Cbrs/24/60/60;
R6      = ts/tr;
% R6 = 0.12; % In Li et al. 1999 they 'choose' 0.12

%% for tracers
Trc0    = 1;
CbrsTrc = Cbrs*Trc0/S0;
R2Trc   = omegag*Ag/CbrsTrc;
R4mTrc  = omegahm*Ah/CbrsTrc;
R5Trc   = omegaf*Af/CbrsTrc;
tsTrc   = Vgu/CbrsTrc/24/60/60;
R6Trc   = ts/tr;