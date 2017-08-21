% ODE function for tracer flux
%
% Chuning Wang
% 2015/02/11

function dy = odefunc_tracer(t,y)

global mtime f Qg Qf trcf trcp S
global deltaSbar lamdad lamdahg lamdahf
global Trc0 CbrsTrc R2Trc R4mTrc R5Trc R6Trc tsTrc

ft = interp1(mtime,f,t)/CbrsTrc;
qg = interp1(mtime,Qg,t)/CbrsTrc;
qf = interp1(mtime,Qf,t)/CbrsTrc;

yf = interp1(mtime,trcf,t)/Trc0;
yp = interp1(mtime,trcp,t)/Trc0;

Shubar = interp1(mtime,S(3, :),t);
Shlbar = interp1(mtime,S(4, :),t);
fs = min(deltaSbar./(Shlbar-Shubar), 1);
R4Trc = 0.5*R4mTrc*fs*(Shlbar-Shubar)*(1+sin(2*pi*t/(365/24)));

qg1 = qg-ft;
qf1 = qf-ft;

dy = zeros(6,1);

dy(1) = (1/tsTrc)*...
        ( ft*yf + qg1*y(2)-qg*y(1)            +R2Trc*(y(2)-y(1)));
dy(2) = (1/tsTrc)*...
        ( qg1*(y(4)-y(2))                     -R2Trc*(y(2)-y(1)))*...
        lamdad;
dy(3) = (1/tsTrc)*...
        ( qg*y(1)-qg1*y(3) + qf1*y(4)-qf*y(3) +R4Trc*(y(4)-y(3)))*...
        (1/lamdahg);
dy(4) = (1/tsTrc)*...
        ( qg1*(y(3)-y(4))  + qf1*(y(6)-y(4))  -R4Trc*(y(4)-y(3)))*...
        (lamdad/lamdahg);
dy(5) = (1/tsTrc)*...
        (                    qf*(y(3)-y(5))   +R5Trc*(y(6)-y(5)))*...
        (lamdahf/lamdahg);
dy(6) = (1/tsTrc)*...
        ((                   qf1*(yp-y(6))    -R5Trc*(y(6)-y(5)))*...
        (lamdahf*lamdad/lamdahg)+...
        R6Trc*(yp-y(6)));

% Original, before non-dimensionalized formular
% dy(1) = (1/Vgu)*(ft*yf+qg1*y(2)-qg*y(1)+omegag*Ag*(y(2)-y(1)));
% dy(2) = (1/Vgl)*(qg1*y(4)-qg1*y(2)-omegag*Ag*(y(2)-y(1)));
% dy(3) = (1/Vhu)*(qg*y(1)-qg1*y(3)+qf1*y(4)-qf*y(3)+omegah*Ah*(y(4)-y(3)));
% dy(4) = (1/Vhl)*(qg1*y(3)-qg1*y(4)+qf1*y(6)-qf1*y(4)-omegah*Ah*(y(4)-y(3)));
% dy(5) = (1/Vfu)*(qf*y(3)-qf*y(5)+omegaf*Af*(y(6)-y(5)));
% dy(6) = (1/Vfl)*(qf1*yp-qf1*y(6)-omegaf*Af*(y(6)-y(5)))+(1/tr)*(yp-y(6));

end