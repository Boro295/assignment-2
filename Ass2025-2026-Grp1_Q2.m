% =========================================================================
% University of Lagos, Akoka, Lagos
% Chemical Engineering Department, CHG 433: Chemical Engineering Analysis
% 2025/2026 Academic Session - Group Assignment II (Question 2)
% =========================================================================

clc; clear; close all;

fprintf('==================================================\n');
fprintf('   CHG 433 Assignment II - Q2 MATLAB Solution\n');
fprintf('==================================================\n\n');

%% ========================================================================
% Q2a: RESISTANCE TEMPERATURE DETECTOR (RTD)
% Requirement: Write your own program. DO NOT use built-in functions.
% =========================================================================
fprintf('--- Q2a: RTD Temperature Determination ---\n');

% Constants
R0 = 100;
A  = 5.485e-3;
B  = 6.65e-6;
C  = 2.805e-11;
D  = -2e-17;
RT_target = 300;

% Define the function f(T) = RT(T) - 300 = 0
% and its derivative f'(T) for Newton-Raphson
f  = @(T) R0 * (1 + A*T + B*T^2 + C*T^4 + D*T^6) - RT_target;
df = @(T) R0 * (A + 2*B*T + 4*C*T^3 + 6*D*T^5);

% 1. Newton-Raphson Method (Custom Implementation)
tol = 1e-6;
max_iter = 100;
T_nr = 300; % Initial guess
iter_nr = 0;
error = 100;

while error > tol && iter_nr < max_iter
    T_new = T_nr - f(T_nr)/df(T_nr);
    error = abs(T_new - T_nr);
    T_nr = T_new;
    iter_nr = iter_nr + 1;
end

fprintf('1) Newton-Raphson Method:\n');
fprintf('   Temperature = %.4f deg C (converged in %d iterations)\n\n', T_nr, iter_nr);

% 2. Interval Bisection Method (Custom Implementation)
T_low = 0;
T_high = 500; % We know the root is around 250-300 based on RT
iter_bisect = 0;

if f(T_low) * f(T_high) > 0
    fprintf('Bisection error: f(T_low) and f(T_high) have the same sign.\n');
else
    while (T_high - T_low) / 2 > tol && iter_bisect < max_iter
        T_mid = (T_low + T_high) / 2;
        if f(T_mid) == 0
            break; % Exact root found
        elseif f(T_low) * f(T_mid) < 0
            T_high = T_mid;
        else
            T_low = T_mid;
        end
        iter_bisect = iter_bisect + 1;
    end
    T_bisect = (T_low + T_high) / 2;
    
    fprintf('2) Interval Bisection Method:\n');
    fprintf('   Temperature = %.4f deg C (converged in %d iterations)\n', T_bisect, iter_bisect);
end
fprintf('\n');


%% ========================================================================
% Q2b: VAN DER WAALS EQUATION OF STATE
% Requirement: Use built-in functions.
% =========================================================================
fprintf('--- Q2b: van der Waals Gas Volume ---\n');

% Constants
n = 1.5;            % moles
R = 0.08206;        % (L atm)/(mole K)
a = 1.39;           % L^2 atm/mole^2
b = 0.03913;        % L/mole
T_k = 25 + 273.15;  % Convert 25 deg C to Kelvin

% Pressure multipliers (Base + 15%, 30%, etc. above base)
% Base is 13.5 atm. Above base means Base * (1 + percentage/100)
base_P = 13.5;
percentages = [0, 15, 30, 45, 60, 75, 90, 105, 120, 135, 150];
P_array = base_P .* (1 + percentages/100);

% Initialize volume array
V_array = zeros(length(P_array), 1);

fprintf('   %% Above Base | Pressure (atm) | Volume (L) \n');
fprintf('   -------------------------------------------\n');

% Loop through each pressure and solve for V using built-in fzero
for i = 1:length(P_array)
    P_val = P_array(i);
    
    % Function to solve: f(V) = nRT/(V-nb) - n^2a/V^2 - P = 0
    vdw_func = @(V) (n*R*T_k)/(V - n*b) - (n^2*a)/(V^2) - P_val;
    
    % Initial guess using Ideal Gas Law (V = nRT/P)
    V_guess = (n * R * T_k) / P_val;
    
    % Use built-in 'fzero' to find the root
    V_sol = fzero(vdw_func, V_guess);
    V_array(i) = V_sol;
    
    fprintf('     %3d %%      |     %6.2f     |   %.4f \n', percentages(i), P_val, V_sol);
end

fprintf('\n(Plotting Pressure vs Volume...)\n');

% Plotting Pressure vs Volume
figure('Name', 'van der Waals Isotherm (25 deg C)', 'Color', 'w');
plot(V_array, P_array, '-o', 'LineWidth', 2, 'MarkerSize', 6, 'MarkerFaceColor', 'b');
title('Pressure vs. Volume for 1.5 moles of N_2 at 25^\circC');
xlabel('Volume (L)');
ylabel('Pressure (atm)');
grid on;

fprintf('==================================================\n');
fprintf('Script executed successfully.\n');