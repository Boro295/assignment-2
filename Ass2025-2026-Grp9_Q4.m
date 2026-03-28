
% University of Lagos, Akoka, Lagos
% Chemical Engineering Department, CHG 433: Chemical Engineering Analysis
%  Group Assignment II (Question 4)
% =========================================================================

clc; clear; close all;

fprintf('==================================================\n');
fprintf('   CHG 433 Assignment II - Q4 MATLAB Solution\n');
fprintf('==================================================\n\n');

%% ------------------------------------------------------------------------
% 1. INPUT DATA
% -------------------------------------------------------------------------
% Temperature in Kelvin
T = [595; 623; 761; 849; 989; 1076; 1146; 1202; 1382; 1445; 1562];

% Rate coefficient k (Table gives k * 10^20, so we multiply by 1e-20)
k_table = [2.12; 3.12; 14.4; 30.6; 80.3; 131; 186; 240; 489; 604; 868];
k = k_table * 1e-20; 

% Universal gas constant (J/mole/K)
R = 8.314;

%% ------------------------------------------------------------------------
% Q4(a): LEAST SQUARES REGRESSION
% -------------------------------------------------------------------------
% Model: ln(k) = C + b*ln(T) - D/T
% This is a multiple linear regression of the form y = X*beta
% where y = ln(k), and the columns of X are [1, ln(T), -1/T].
% The coefficients vector beta will be [C; b; D].

y = log(k); % log() in MATLAB computes the natural logarithm ln()

% Formulate the design matrix X
X = [ones(length(T), 1), log(T), -1./T];

% Solve for the coefficients using the backslash operator (least squares)
beta = X \ y;

C = beta(1);
b = beta(2);
D = beta(3);

fprintf('--- Q4(a): Least-Squares Model Parameters ---\n');
fprintf('Model equation: ln(k) = C + b*ln(T) - D/T\n');
fprintf('Constant C = %12.4f\n', C);
fprintf('Constant b = %12.4f\n', b);
fprintf('Constant D = %12.4f K\n\n', D);

%% ------------------------------------------------------------------------
% Q4(b): ARRHENIUS EQUATION PARAMETERS
% -------------------------------------------------------------------------
% The modified Arrhenius equation is: k = A * T^b * exp(-Ea / (RT))
% Taking the natural logarithm: ln(k) = ln(A) + b*ln(T) - (Ea/R)*(1/T)
%
% Comparing this with the empirical model from part (a):
% 1) C = ln(A)       => A = exp(C)
% 2) b = b           => (already found)
% 3) D/T = Ea/(RT)   => Ea = D * R

A_arrhenius = exp(C);
Ea = D * R;

fprintf('--- Q4(b): Arrhenius Constants ---\n');
fprintf('Pre-exponential factor A = %10.4e m^3/s\n', A_arrhenius);
fprintf('Activation Energy Ea     = %10.4f J/mole\n', Ea);
fprintf('                         = %10.4f kJ/mole\n\n', Ea/1000);

%% ------------------------------------------------------------------------
% VALIDATION & PLOTTING
% -------------------------------------------------------------------------
% Compute predicted k values using the determined model
ln_k_pred = X * beta;
k_pred = exp(ln_k_pred);

% Compute R-squared to validate goodness of fit
SS_tot = sum((y - mean(y)).^2);
SS_res = sum((y - ln_k_pred).^2);
R_squared = 1 - (SS_res / SS_tot);

fprintf('--- Validation Check ---\n');
fprintf('R-squared value of the fit = %.6f\n', R_squared);
if R_squared > 0.99
    fprintf('Excellent fit achieved. Validation successful.\n');
end

% Plot Experimental vs Predicted Data
figure('Name', 'Rate Coefficient Fit', 'Color', 'w');
plot(T, k, 'bo', 'MarkerSize', 8, 'LineWidth', 1.5); hold on;
plot(T, k_pred, 'r-', 'LineWidth', 2);
grid on;
title('Reaction Rate Coefficient vs Temperature');
xlabel('Temperature (K)');
ylabel('Rate Coefficient k (m^3/s)');
legend('Experimental Data', 'Least-Squares Fit', 'Location', 'best');

fprintf('==================================================\n');