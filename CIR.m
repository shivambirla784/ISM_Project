%cox ingersoll ross model
kappa = 0.5;  % speed of mean reversion
theta = 0.04; % long-term average interest rate
sigma = 0.1;  % volatility of interest rate
r0 = 0.05;    % initial interest rate
T = 1;        % time horizon
N = 1000;     % number of time steps

dt = T/N;          % time step
t = linspace(0, T, N+1); % time grid

r = zeros(1, N+1); % interest rate process
r(1) = r0;         % initial interest rate

for i = 1:N
    dW = sqrt(dt)*randn(); % Wiener process increment
    dR = kappa*(theta - r(i))*dt + sigma*sqrt(r(i))*dW + 0.25*sigma^2*(dW^2 - dt); % CIR model increment
    r(i+1) = r(i) + dR;    % update interest rate
end
hold on
plot(t, r)
hold off
xlabel('Time')
ylabel('Interest rate')
title('Simulation of CIR Model using Milstein Method')