% =========================================================================
% CHG 433: Chemical Engineering Analysis - Assignment II (Question 3)
% Parts (e) and (f): Euler's Method and RK4 Method
% =========================================================================

clc; clear; close all;

fprintf('==================================================\n');
fprintf('   CHG 433 Assignment II - Q3 MATLAB Solution\n');
fprintf('==================================================\n\n');

% -------------------------------------------------------------------------
% 1. DEFINE SYSTEM PARAMETERS
% -------------------------------------------------------------------------
A  = 100;    % Cross-sectional area (cm^2)
R  = 1;      % Assumed linear valve resistance (s/cm^2)
h0 = 10;     % Initial steady-state liquid level (cm)
qi = 15;     % New inlet flow after 50% step increase (cm^3/s)
t_end = 500; % Simulation time to reach new steady state (5 * time constant)

% ODE Function: dh/dt = (qi - h/R) / A
f = @(t, h) (qi - h/R) / A;

% Step lengths to investigate
dt_values = [0.01, 0.05, 0.1, 0.5, 1, 10];

% Setup Plot figure
figure('Name', 'Dynamic Response of Liquid Level', 'Position', [100, 100, 1000, 450], 'Color', 'w');

% =========================================================================
% PART (E): EXPLICIT EULER'S METHOD
% =========================================================================
subplot(1, 2, 1); hold on; grid on;
title('Part (e): Explicit Euler''s Method');
xlabel('Time (s)');
ylabel('Liquid Level h(t) [cm]');

colors = lines(length(dt_values)); % distinct colors for plots

for i = 1:length(dt_values)
    dt = dt_values(i);
    N = floor(t_end / dt) + 1;
    t = zeros(1, N);
    h = zeros(1, N);
    
    % Initial conditions
    t(1) = 0;
    h(1) = h0;
    
    % Euler Loop
    for k = 1:(N-1)
        t(k+1) = t(k) + dt;
        h(k+1) = h(k) + dt * f(t(k), h(k));
    end
    
    plot(t, h, 'Color', colors(i,:), 'LineWidth', 1.5, 'DisplayName', sprintf('dt = %g s', dt));
end
legend('Location', 'best');

% =========================================================================
% PART (F): RUNGE-KUTTA 4th-ORDER (RK4) METHOD
% =========================================================================
subplot(1, 2, 2); hold on; grid on;
title('Part (f): Runge-Kutta 4th-Order (RK4) Method');
xlabel('Time (s)');
ylabel('Liquid Level h(t) [cm]');

for i = 1:length(dt_values)
    dt = dt_values(i);
    N = floor(t_end / dt) + 1;
    t = zeros(1, N);
    h = zeros(1, N);
    
    % Initial conditions
    t(1) = 0;
    h(1) = h0;
    
    % RK4 Loop
    for k = 1:(N-1)
        t(k+1) = t(k) + dt;
        
        k1 = f(t(k), h(k));
        k2 = f(t(k) + dt/2, h(k) + k1*dt/2);
        k3 = f(t(k) + dt/2, h(k) + k2*dt/2);
        k4 = f(t(k) + dt, h(k) + k3*dt);
        
        h(k+1) = h(k) + (dt/6) * (k1 + 2*k2 + 2*k3 + k4);
    end
    
    plot(t, h, 'Color', colors(i,:), 'LineWidth', 1.5, 'DisplayName', sprintf('dt = %g s', dt));
end
legend('Location', 'best');

fprintf('Simulation complete. Plots generated for Explicit Euler and RK4 methods.\n');
fprintf('==================================================\n');