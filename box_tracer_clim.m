% Calculate tracer fluxes and concentration based on the output of box
% model (climatology run).
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

% Constants and volume fluxes
box_const
load salt_flux_clim

%% Load Fraser O2 climatology
% This is only a test. O2 is a bad conservative tracer because of the
% sources/sinks and air sea flux.

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

% initial conditions
Trc_init = ones(6, 1)*0;

%% Calcualte tracer concentration
trc = zeros(6, length(mtime));
trc(:, 1) = Trc_init;

delta = 1;
kk    = 0; % Counter

while delta>1e-6
    kk = kk+1;
    % Solve the equation using RK solver
    trc = rk_solver(trc(:,1),mtime,@odefunc_tracer);
    delta = sum((trc(:,end)-trc(:,1)).^2)/6;
    trc(:,1) = trc(:,end);
end
