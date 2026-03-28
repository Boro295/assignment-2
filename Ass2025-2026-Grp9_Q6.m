% =========================================================================
% University of Lagos, Akoka, Lagos
% Chemical Engineering Department, CHG 433: Chemical Engineering Analysis
% 2025/2026 Academic Session - Group Assignment II (Question 6)
% =========================================================================

clc; clear; close all;

fprintf('============================================================\n');
fprintf('       CHG 433 Assignment II - Q6 MATLAB Solution\n');
fprintf('============================================================\n\n');

%% ------------------------------------------------------------------------
% 1. SET UP THE MODELING EQUATIONS (A * x = b)
% -------------------------------------------------------------------------
% Let the unknowns be the cost per pound ($/lb) of each ingredient:
% x1 = Peanuts
% x2 = Raisins
% x3 = Almonds
% x4 = Chocolate Chips
% x5 = Dried Plums
%
% The linear equations based on the table are:
% Mix A: 0.20*x1 + 0.20*x2 + 0.20*x3 + 0.20*x4 + 0.20*x5 = 1.44
% Mix B: 0.35*x1 + 0.15*x2 + 0.35*x3 + 0.00*x4 + 0.15*x5 = 1.16
% Mix C: 0.10*x1 + 0.30*x2 + 0.10*x3 + 0.10*x4 + 0.40*x5 = 1.38
% Mix D: 0.00*x1 + 0.30*x2 + 0.10*x3 + 0.40*x4 + 0.20*x5 = 1.78
% Mix E: 0.15*x1 + 0.30*x2 + 0.20*x3 + 0.35*x4 + 0.00*x5 = 1.61

% Coefficient Matrix (Composition in lb)
A = [0.20, 0.20, 0.20, 0.20, 0.20;
     0.35, 0.15, 0.35, 0.00, 0.15;
     0.10, 0.30, 0.10, 0.10, 0.40;
     0.00, 0.30, 0.10, 0.40, 0.20;
     0.15, 0.30, 0.20, 0.35, 0.00];

% Constant Vector (Total Cost in $)
b = [1.44;
     1.16;
     1.38;
     1.78;
     1.61];

%% ------------------------------------------------------------------------
% 2. SOLVE FOR THE UNKNOWNS
% -------------------------------------------------------------------------
% Using the highly efficient matrix left division operator (\)
x = A \ b;

% Extracting individual costs for clarity
cost_peanuts   = x(1);
cost_raisins   = x(2);
cost_almonds   = x(3);
cost_choc_chip = x(4);
cost_plums     = x(5);

%% ------------------------------------------------------------------------
% 3. DISPLAY RESULTS
% -------------------------------------------------------------------------
fprintf('--- Calculated Cost per Pound of Ingredients ---\n');
fprintf('  Peanuts         : $ %4.2f / lb\n', cost_peanuts);
fprintf('  Raisins         : $ %4.2f / lb\n', cost_raisins);
fprintf('  Almonds         : $ %4.2f / lb\n', cost_almonds);
fprintf('  Chocolate Chips : $ %4.2f / lb\n', cost_choc_chip);
fprintf('  Dried Plums     : $ %4.2f / lb\n\n', cost_plums);

%% ------------------------------------------------------------------------
% 4. VALIDATION CHECK
% -------------------------------------------------------------------------
% Multiply the solved costs back into the original composition matrix
% to ensure it perfectly matches the original given Total Costs.
b_check = A * x;
residual = b - b_check;

fprintf('--- Validation Check ---\n');
fprintf('Comparing Original Costs with Back-calculated Costs:\n');
fprintf('  Mix   |  Given Cost ($)  |  Calculated Cost ($)  |  Difference\n');
fprintf('------------------------------------------------------------------\n');
fprintf('   A    |      %5.2f       |        %5.2f          |  %8.2e\n', b(1), b_check(1), residual(1));
fprintf('   B    |      %5.2f       |        %5.2f          |  %8.2e\n', b(2), b_check(2), residual(2));
fprintf('   C    |      %5.2f       |        %5.2f          |  %8.2e\n', b(3), b_check(3), residual(3));
fprintf('   D    |      %5.2f       |        %5.2f          |  %8.2e\n', b(4), b_check(4), residual(4));
fprintf('   E    |      %5.2f       |        %5.2f          |  %8.2e\n', b(5), b_check(5), residual(5));

if max(abs(residual)) < 1e-10
    fprintf('\nValidation Successful: Differences are practically zero (machine precision).\n');
else
    fprintf('\nWarning: Significant discrepancy detected.\n');
end
fprintf('============================================================\n');