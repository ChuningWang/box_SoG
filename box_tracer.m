% Calculate tracer fluxes and concentration based on the output of box
% model
%
% The usage of this script is similar to box_rt.m. Instead of salinity, a
% tracer concentration (in this example, prescribed values) is needed to
% drive this model.
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
load('salt_flux.mat', 'mtime', 'f', 'Qg', 'Qf', 'S')

%% Load tracer data and initial conditions
% here I use prescribed values in river and Pacific Ocean, and
% initiated with zeros (none tracers in Salish Sea).

% Load your river/pacific tracer concentration here
trcf = ones(size(mtime))*10;
trcf(365*5+1:end) = 0;
trcp = zeros(size(mtime));
trcp(365*10+1:end) = 2;

% initial conditions
Trc_init = ones(6, 1)*0/Trc0;

%% Calcualte tracer concentration
trc = zeros(6, length(mtime));
trc(:, 1) = Trc_init;
trc = rk_solver(trc(:,1),mtime,@odefunc_tracer);

trc = trc*Trc0;
