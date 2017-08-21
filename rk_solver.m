% Use 4th order Runge_Kutta Method to solve linear/nonlinear ODEs
%
% USAGE:
%     y = rk_solver(y0,t,b)
%
% Input:
%     y0 - Initial condition
%     t  - Time vector
%     b  - Function handle
%
% Output:
%     y - Solution of the problem at time t
%
% Chuning Wang
% 2015/02/11

function y = rk_solver(y0,t,b)

t = t(:);

dy = b(t(1),y0);
y = NaN(size(dy,1),size(t,1));
y(:,1) = y0;

for iter = 2:size(t)
    h = t(iter)-t(iter-1);
    k1 = b(t(iter-1),y(:,iter-1));
    k2 = b(t(iter-1)+h/2,y(:,iter-1)+k1*h/2);
    k3 = b(t(iter-1)+h/2,y(:,iter-1)+k2*h/2);
    k4 = b(t(iter-1)+h,y(:,iter-1)+k3*h);
    y1 = y(:,iter-1)+(1/6)*h*(k1+2*k2+2*k3+k4);
    % check for negative values - concentration cannot be negative
    y1(y1<0) = 0;
    y(:,iter) = y1;
end

end