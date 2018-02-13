% syms f(t) g(t) delta
% eqn1 = diff(f) == -0.3149*f + 235.89*g - 5.5079*delta;
% eqn2 = diff(g) == -0.0034*f -0.4282*g + 0.00021*delta;
% c1 = f(0) == 0;
% c2 = g(0) == 1;
% [fSol(t), gSol(t)] = dsolve(eqn1, eqn2, c1, c1);
q = zeros(1,21);
ref = 0.15;
theta_curr = 0;
theta = zeros(1,11);
error = zeros(1,11);
time = 0:0.2:20;
delta = sin(time);
for i = 1:1:101
    t = time(i);
    q(i) = 0.02*delta + cos(0.8937*t)/(exp(t)^0.3715) - 1133*sin(0.8937*t)/(17875.31*exp(t)^0.37155) - 0.09375*delta*sin(0.8937*t)/exp(t)^(0.3715);
    theta_curr = theta_curr + t*q(i);
    theta(i) = theta_curr;
    error(i) = theta(i) - ref;
    delta = delta+0.01;
end
plot(time,theta)