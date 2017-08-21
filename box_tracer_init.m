% Calculate initial conditions for tracer fluxes and concentration based on
% the output of box model
%
% The usage of this script is similar to box_init.m. Instead of salinity, a
% tracer concentration (in this example, fraser O2) is needed to drive this
% model. O2 is not a very good tracer in the system since it is not
% conservative. In further cases other tracers should be used.
%
% Chuning Wang
% 2017/08/20
%

clc; clear; close all

global mtime f Qg Qf trcf trcp S
global deltaSbar lamdad lamdahg lamdahf
global Trc0 CbrsTrc R2Trc R4mTrc R5Trc R6Trc tsTrc

% Constants
box_const
load salt_flux_clim

%% Load model outputs
load('data/frasero2.mat','o2_m')

f = f(:); mtime = mtime(:); Qg = Qg(:); Qf = Qf(:);
S = S*S0;
o2_m = o2_m(:);
mt2 = zeros(size(o2_m));

for i = 1:12
    mt2(i) = datenum([0 i 15 00 00 00]);
end

o2_m = [o2_m(end); o2_m; o2_m(1)];
mt2 = [mt2(end)-366; mt2; mt2(1)+366];

trcf = interp1(mt2,o2_m,mtime);
trcp = zeros(size(trcf));

%% Calcualte tracer concentration
trc = ones(6, length(mtime))*Trc0;

delta = 1;
kk    = 0; % Counter

while delta>1e-6
    kk = kk+1;
    % Solve the equation using RK solver
    trc = rk_solver(trc(:,1),mtime,@odefunc_tracer);
    delta = sum((trc(:,end)-trc(:,1)).^2)/6;
    trc(:,1) = trc(:,end);
end