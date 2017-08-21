% Calculate tracer fluxes and concentration based on the output of box
% model
%
% The usage of this script is similar to box_rt.m. Instead of salinity, a
% tracer concentration (in this example, fraser O2) is needed to drive this
% model. O2 is not a very good tracer in the system since it is not
% conservative. In further cases other tracers should be used.
%
% Chuning Wang
% 2017/08/20
%

clc; clear; close all

global mtime f Qg Qf trcf trcp S
global deltaSbar Ag Ah Af Vgu Vgl Vhu Vhl Vfu Vfl omegag omegahm omegaf tr

% Constants
box_const

%% Load model outputs
load('salinity_flux3.mat', 'mtime', 'f', 'Qg', 'Qf', 'S')
load('frasero2.mat','o2_m')

f = f(:); mtime = mtime(:); Qg = Qg(:); Qf = Qf(:);
S = S*S0;
o2_m = o2_m(:);

yr = ceil((mtime(end)-mtime(1))/365)+1;
dvec = datevec(mtime(1));
yr1 = dvec(1)-1;

o2_m = repmat(o2_m,yr,1);

for iter = 1:yr*12
    mt2(iter) = datenum([yr1+floor(iter/12-0.000001) mod(iter-1,12)+1 15 00 00 00]);
end

mt2 = mt2(:);

trcf = interp1(mt2,o2_m,mtime);
trcp = zeros(size(trcf));

%% Calcualte tracer concentration
trc = ones(length(mtime), 6)*trcf(1);
trc = rk_solver(trc(1,:),mtime,@odefunc_tracer);

