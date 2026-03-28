% =========================================================================
% University of Lagos, Akoka, Lagos
% Chemical Engineering Department
% CHG 433: Chemical Engineering Analysis
% 2025/2026 Academic Session - Group Assignment II (Question 1)
% 
% Group Name: Group 1 (Update if necessary)
% Description: This script solves the steady-state mass continuity 
% equations for a three-reactor system to find concentrations xA, xB, xC.
% =========================================================================

% Clear command window, workspace variables, and close any open figures
clc; clear; close all;

fprintf('==================================================\n');
fprintf('   CHG 433 Assignment II - Q1 MATLAB Solution\n');
fprintf('==================================================\n\n');

% -------------------------------------------------------------------------
% 1. DEFINE THE COEFFICIENT MATRIX (A) AND CONSTANT VECTOR (b)
% -------------------------------------------------------------------------
% From the mass balances derived:
% Reactor A: 120*xA -  60*xB +    0*xC =  1320
% Reactor B:  40*xA -  80*xB +    0*xC =     0
% Reactor C:  80*xA +  20*xB -  150*xC =  -195

A = [ 120, -60,    0;
       40, -80,    0;
       80,  20, -150 ];

b = [ 1320;
         0;
      -195 ];

% -------------------------------------------------------------------------
% 2. COMPUTE THE PRIMARY SOLUTION 
% -------------------------------------------------------------------------
% The backslash operator (\) is the most efficient and numerically 
% stable way to solve linear systems (A*x = b) in MATLAB.
x = A \ b;

xA = x(1);
xB = x(2);
xC = x(3);

fprintf('--- 1) Primary Solution (Using MATLAB backslash operator) ---\n');
fprintf('Concentration in Reactor A (xA) = %10.4f mg/m^3\n', xA);
fprintf('Concentration in Reactor B (xB) = %10.4f mg/m^3\n', xB);
fprintf('Concentration in Reactor C (xC) = %10.4f mg/m^3\n\n', xC);

% -------------------------------------------------------------------------
% 3. VERIFICATION USING MATRIX INVERSE METHOD
% -------------------------------------------------------------------------
x_inv = inv(A) * b;

fprintf('--- 2) Verification via Matrix Inverse (inv(A)*b) ---\n');
fprintf('xA = %10.4f mg/m^3\n', x_inv(1));
fprintf('xB = %10.4f mg/m^3\n', x_inv(2));
fprintf('xC = %10.4f mg/m^3\n\n', x_inv(3));

% -------------------------------------------------------------------------
% 4. VERIFICATION USING CRAMER'S RULE
% -------------------------------------------------------------------------
detA = det(A);

% Replace columns with vector b
A1 = A; A1(:, 1) = b;
A2 = A; A2(:, 2) = b;
A3 = A; A3(:, 3) = b;

x_cramer = [det(A1)/detA; det(A2)/detA; det(A3)/detA];

fprintf('--- 3) Verification via Cramer''s Rule ---\n');
fprintf('xA = %10.4f mg/m^3\n', x_cramer(1));
fprintf('xB = %10.4f mg/m^3\n', x_cramer(2));
fprintf('xC = %10.4f mg/m^3\n\n', x_cramer(3));

% -------------------------------------------------------------------------
% 5. FINAL ERROR / RESIDUAL CHECK
% -------------------------------------------------------------------------
% If the math is perfect, A*x - b should equal exactly zero.
residual = A * x - b;

fprintf('--- 4) Residual Check (A*x - b) ---\n');
fprintf('Values effectively at zero confirm absolute precision:\n');
fprintf('Residual A: %g\n', residual(1));
fprintf('Residual B: %g\n', residual(2));
fprintf('Residual C: %g\n', residual(3));
fprintf('\n==================================================\n');
fprintf('Solution generated successfully.\n');