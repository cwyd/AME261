%   =======================================================================
% 	CoarsePlaneSpreadParameters.m
%   =======================================================================
%   PARENT SCRIPT
%
%   PROGRAM INFORMATION
%   Author:     Gabriel Calub
%   Date:       03/26/2023
%   Version:    4.4
%   References: 1.
%               2.
%
%   Trade study script used to create rough plane parameters for each
%   subteam to target in matching design requirements.
%
%   TO-DO:
%       Several functions output vectors. Which values to look at?
%
%   Documentation: https://docs.google.com/document/d/1s04e2THURuhZ66hpbRJmpVLHB_bnvNXdhlUeKBF3msU/edit
%
clc; clear; close all;

%% DESIGN INPUTS
C_D0            = 0.0202;
C_Lmax          = 2;
W_craft         = 41005;    % [N]
e               = 0.87;     
W_fuel          = 4188;     % [N]
W_battery       = 1000;     % [N]
S               = 100;      % [m^2]
b               = 10;       
Cg              = 5;
t_c             = 1;
lambda          = 10;
P_maxSL         = 2160;
T               = 3; % Remove since we are using a prop plane
P_maxBattery    = 50;
eta_prop        = 0.86;
d_wing_ground   = 10; % Distance from wing to ground
SFC_P           = 1; % Specific fuel consumption
h_battery       = 1;
eta_battery     = 1;
phi             = 1; % Bank angle
mu_r            = 1;
wingDistFromGround = 1;
engineNumber    = 2;
cruiseAlt = 50;

%% DESIGN REQUIREMENTS
X_hv_req        = [1000*1852, Inf]; % Minimum range of 1000 nautical miles [m]
dTOFL_req       = 4500*0.3048;      % TOFL dictated by 4500 feet
dLFL_req        = 4500*0.3048;      % LFL dictated by 4500 feet
hObstacle_req   = 50*0.3048;        % 50 foot obstacle [m]
deltaWeight_req = 1;                % Must be 80% of the ATR (competing plane)
RoCtheta_req    = atand(28000/1.215e+6);
approachV_req   = 1;
stability_req   = [0, Inf];         % Don't know stability requirement yet
turning_req     = [0, Inf];         % Don't know turning requirement

%% COMPUTATIONS
% Initial Calculations - What flying altitude? And does it change for each
% computation?
AR = b^2/S;
h = 1;

% Weights
W_0 = W_fuel+W_battery+W_craft;

% Drag - Which value to isolate from drag?
[velocityVec, DincVec, DcompVec] = computedragPROPS(h, W_0, S, b, C_D0, e, t_c, lambda, false);

% Power - Which value to isolate?
h = cruiseAlt;
[P_R, PA, P_Rmin, v] = computePowerPROPS(h, C_D0, e, S,b, C_Lmax, W_0, P_maxSL, eta_prop);

% Range - What CL to use?
CL = 1;
range = computeRangeBATT(eta_prop, h_battery, C_D0, e, AR, CL, W_battery, W_0);

% Emissions

% Rate of Climb
throttleSetting = 1;
[velocityVec, RoCVec] = computeRateOfClimbPROPS(h, W_0, P_maxSL, throttleSetting, eta_prop, C_D0, e, AR, S, false);

% Takeoff
hAirport = 0;
P_maxSLOneEngine = P_maxSL/engineNumber;
TOFL = computeTakeoffFieldLength(W_0, hAirport, S, C_Lmax, throttleSetting, P_maxSLOneEngine);

% Landing
landingFieldLength = computeLandingFieldLength(W_1, hAirport, C_D0, e, AR, S, b, C_Lmax, mu_r, wingDistFromGround);

% Turning Performance Calcs

% Stability (static margin)

%% OUTPUT
test = '| OK';
test2 = ("| OFF BY " + groundRoll);
fprintf("=============== FINAL PLANE PARAMETERS ===============\n")
fprintf("Takeoff Weight:        %14.2f lbs           %s \n", W_0, test)
fprintf("Landing Weight:        %14.2f lbs           %s \n", W_1, test2)
fprintf("Minimum Drag:          %14.2f lbs           %s \n", min(DincVec), test)
fprintf("Minimum Power:         %14.2f lbs-ft/s      %s \n", P_R, test)
fprintf("Range:                 %14.2f               %s \n", range, test2)
fprintf("Maximum Rate of Climb: %14.2f               %s \n", max(RoCVec), test)

