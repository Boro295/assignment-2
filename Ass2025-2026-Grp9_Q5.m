% =========================================================================
% CHG 433: Chemical Engineering Analysis
% 2025/2026 Assignment II - Question 5 (Flash Vaporization)
%
% Feed: F = 100 lbmol/h
% z = [0.21 n-butane, 0.60 n-pentane, 0.19 n-hexane]
% Operating conditions: P = 10 atm, T = 270 degF
%
% Objective:
% 1) Set up and solve flash equations
% 2) Determine V, L, xi, yi
% 3) Provide validation and comparison-ready outputs
%
% Note:
% 
% .
% =========================================================================

clc; clear; close all;

fprintf('=============================================================\n');
fprintf(' CHG 433 Assignment II - Q5 Flash Calculation (MATLAB)\n');
fprintf('=============================================================\n\n');

%% ------------------------- GIVEN DATA ------------------------------------
F = 100.0;                  % lbmol/h
z = [0.21; 0.60; 0.19];     % feed mole fractions [C4, C5, C6]
comp = {'n-Butane','n-Pentane','n-Hexane'};

P = 10.0;                   % atm
T_F = 270.0;                % degF
T_K = (T_F - 32)*(5/9) + 273.15;   % K

% Critical properties (approximate accepted values for hydrocarbons)
Tc = [425.12; 469.70; 507.60];     % K
Pc = [37.96; 33.70; 30.25];        % atm
w  = [0.200; 0.251; 0.301];        % acentric factor

%% ----------------- MODEL EQUATIONS (FLASH, IDEAL VLE) -------------------
% VLE relation: yi = Ki*xi
% Component balance: F*zi = L*xi + V*yi
% Total balance: F = L + V
% Rachford-Rice equation in beta = V/F:
% f(beta) = sum[ zi*(Ki-1)/(1 + beta*(Ki-1)) ] = 0

% Wilson Ki correlation
K = (Pc./P).*exp(5.373.*(1 + w).*(1 - Tc./T_K));

fprintf('Operating T = %.2f K, P = %.2f atm\n', T_K, P);
fprintf('Estimated Ki values (Wilson):\n');
for i = 1:3
    fprintf('  %-10s : K = %.6f\n', comp{i}, K(i));
end
fprintf('\n');

%% ----------------- PHASE FEASIBILITY CHECK ------------------------------
S1 = sum(z.*K);      % at beta = 0 => sum(zKi)
S2 = sum(z./K);      % at beta = 1 => sum(z/Ki)

if (S1 <= 1)
    % All liquid
    beta = 0;
    V = 0; L = F;
    x = z;
    y = K.*x; y = y/sum(y);  % normalized hypothetical vapor
    phaseMsg = 'Single-phase LIQUID predicted at these conditions.';
elseif (S2 <= 1)
    % All vapor
    beta = 1;
    V = F; L = 0;
    y = z;
    x = y./K; x = x/sum(x);  % normalized hypothetical liquid
    phaseMsg = 'Single-phase VAPOR predicted at these conditions.';
else
    % Two-phase flash
    rr = @(b) sum(z.*(K-1)./(1 + b.*(K-1)));
    beta = fzero(rr, [0,1]);   % robust bracket
    V = beta*F;
    L = F - V;

    x = z ./ (1 + beta.*(K-1));
    y = K .* x;

    % normalize (to remove tiny floating errors)
    x = x/sum(x);
    y = y/sum(y);

    phaseMsg = 'Two-phase VLE flash solution obtained.';
end

%% ----------------------- PRINT RESULTS -----------------------------------
fprintf('--- FLASH RESULTS ---\n');
fprintf('%s\n\n', phaseMsg);
fprintf('Vapor fraction, beta = V/F = %.8f\n', beta);
fprintf('Vapor flow,   V = %.6f lbmol/h\n', V);
fprintf('Liquid flow,  L = %.6f lbmol/h\n\n', L);

fprintf('Phase compositions:\n');
fprintf('-------------------------------------------------------------\n');
fprintf('%-12s   z_i         x_i (liquid)   y_i (vapor)\n', 'Component');
fprintf('-------------------------------------------------------------\n');
for i = 1:3
    fprintf('%-12s   %.6f     %.6f       %.6f\n', comp{i}, z(i), x(i), y(i));
end
fprintf('-------------------------------------------------------------\n\n');

%% ----------------------- VALIDATIONS -------------------------------------
fprintf('--- VALIDATION CHECKS ---\n');

% 1) Summation checks
sumx = sum(x); sumy = sum(y); sumz = sum(z);
fprintf('Sum z_i = %.12f (should be 1)\n', sumz);
fprintf('Sum x_i = %.12f (should be 1)\n', sumx);
fprintf('Sum y_i = %.12f (should be 1)\n', sumy);

% 2) Total balance
total_res = F - (L + V);
fprintf('Overall balance residual: F-(L+V) = %.12e\n', total_res);

% 3) Component balances
res_comp = F*z - (L*x + V*y);
fprintf('Component balance residuals Fz-(Lx+Vy):\n');
for i = 1:3
    fprintf('  %-10s : %.12e\n', comp{i}, res_comp(i));
end

% 4) Equilibrium checks yi/(Ki*xi) should be 1
eq_ratio = y./(K.*x);
fprintf('Equilibrium ratio check y/(Kx):\n');
for i = 1:3
    fprintf('  %-10s : %.12f\n', comp{i}, eq_ratio(i));
end
fprintf('\n');

%% --------------------- COMPARISON TEMPLATE (DWSIM) ----------------------
fprintf('--- COMPARISON TEMPLATE (Fill DWSIM values in report) ---\n');
fprintf('Parameter                     MATLAB Value\n');
fprintf('V (lbmol/h)                  %12.6f\n', V);
fprintf('L (lbmol/h)                  %12.6f\n', L);
fprintf('x_n-Butane                   %12.6f\n', x(1));
fprintf('x_n-Pentane                  %12.6f\n', x(2));
fprintf('x_n-Hexane                   %12.6f\n', x(3));
fprintf('y_n-Butane                   %12.6f\n', y(1));
fprintf('y_n-Pentane                  %12.6f\n', y(2));
fprintf('y_n-Hexane                   %12.6f\n', y(3));
fprintf('\n');

%% --------------------------- PLOTS ---------------------------------------
% Plot 1: Liquid vs Vapor composition by component
figure('Color','w','Name','Q5 Flash Results');
subplot(1,2,1);
bar([x y], 'grouped');
set(gca,'XTickLabel',comp,'FontSize',10);
ylabel('Mole Fraction');
legend('x_i (liquid)','y_i (vapor)','Location','best');
title('Phase Composition Comparison');
grid on;

% Plot 2: Rachford-Rice function vs beta
subplot(1,2,2);
if exist('rr','var')
    bgrid = linspace(0,1,300);
    fgrid = arrayfun(rr,bgrid);
    plot(bgrid,fgrid,'LineWidth',1.8); hold on;
    yline(0,'k--');
    xline(beta,'r--','LineWidth',1.2);
    xlabel('\beta = V/F');
    ylabel('f(\beta)');
    title('Rachford-Rice Function');
    grid on;
else
    text(0.1,0.5,'Single-phase case: RR root not required','FontSize',11);
    axis off;
end

%% ------------------- OPTIONAL SENSITIVITY TABLE --------------------------
% Useful for report discussion (not required but valuable)
fprintf('--- OPTIONAL: Pressure Sensitivity (T fixed) ---\n');
P_test = [6 8 10 12 14];   % atm
fprintf('P(atm)      beta(V/F)\n');
for pp = P_test
    Kp = (Pc./pp).*exp(5.373.*(1 + w).*(1 - Tc./T_K));
    S1p = sum(z.*Kp); S2p = sum(z./Kp);

    if S1p <= 1
        betap = 0;
    elseif S2p <= 1
        betap = 1;
    else
        rrp = @(b) sum(z.*(Kp-1)./(1 + b.*(Kp-1)));
        betap = fzero(rrp,[0,1]);
    end
    fprintf('%5.1f       %10.6f\n', pp, betap);
end

fprintf('\nDone. Script executed successfully.\n');