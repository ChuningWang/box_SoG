% ODE function for density flow
% See Eq 3.6~3.28 in the thesis
%
% Chuning Wang
% 2015/02/11

function dy = odefunc_salt_v2(t,y)

global lamdad lamdahg lamdahf R2 R3 R4m R5 R6 ts deltaS f Spbar mtime Cbrs S0

F1 = @(t) interp1(mtime,f,t)/Cbrs;
Sp = @(t) interp1(mtime,Spbar,t)/S0;
R4 = @(t) 0.5*R4m*min(deltaS./(y(4)-y(3)),1)*(1+sin(2*pi*t/(365/24)));

qg  = y(3)-y(1);
qg1 = qg-F1(t);
qf  = y(5)-y(3);
qf  = qf*R3;
qf1 = qf-F1(t);

dy = zeros(6,1);

dy(1) = (1/ts)*...
        ( qg1*y(2)-qg*y(1)                     +R2   *(y(2)-y(1)));
dy(2) = (1/ts)*...
        ( qg1*(y(4)-y(2))                      -R2   *(y(2)-y(1)))*...
        lamdad;
dy(3) = (1/ts)*...
        ( qg*y(1)-qg1*y(3) +(qf1*y(4)-qf*y(3)) +R4(t)*(y(4)-y(3)))*...
        (1/lamdahg);
dy(4) = (1/ts)*...
        ( qg1*(y(3)-y(4))  +qf1*(y(6)-y(4))    -R4(t)*(y(4)-y(3)))*...
        (lamdad/lamdahg);
dy(5) = (1/ts)*...
        (                   qf*(y(3)-y(5))     +R5   *(y(6)-y(5)))*...
        (lamdahf/lamdahg);
dy(6) = (1/ts)*...
        ((                  qf1*(Sp(t)-y(6))   -R5   *(y(6)-y(5)))*...
        (lamdahf*lamdad/lamdahg)+...
        R6*(Sp(t)-y(6)));

end