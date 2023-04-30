%   =======================================================================
% 	greenlight.m
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
%   Checks if input parameters from individual design divisions can satisfy
%   mission plan and requirements
%
%   TO-DO:
%       Several functions output vectors. Which values to look at?
%
%   Documentation: https://docs.google.com/document/d/1s04e2THURuhZ66hpbRJmpVLHB_bnvNXdhlUeKBF3msU/edit
%
clc; clear; close all;

%% DESIGN INPUTS
C_D0            = 0.0202;
C_Lmax          = 0.2;
W_craft         = 1.82*10^5;    % [N]
e               = 0.9;      
W_fuel          = 4.41*10^4;    % [N]
W_battery       = 3*10^4;       % [N]
S               = 66.6;         % [m^2]
b               = 30;           % [m]
Cg              = 5;            % [m]
t_c             = 0.18;         
lambda          = 0;        
P_maxSL         = 5.37*10^6;
P_maxBattery    = 3.58*10^6;
eta_prop        = 0.9;
SFC_P           = 7.84*10^(-7);  % Specific fuel consumption
h_battery       = 781200;
eta_battery     = 0.9;
phi             = 0;            % Bank angle
mu_r            = 0.4;
wingDistFromGround = 4;
engineNumber    = 2;

%% ATR PARAMETERS (Constants)
ATR.C_D0            = 0.0202;
ATR.C_Lmax          = 0.2;
ATR.W_craft         = 1.82*10^5;    % [N]
ATR.e               = 0.8;     
ATR.W_fuel          = 4.41*10^4;     % [N]
ATR.S               = 66.6;      % [m^2]
ATR.b               = 30;       
ATR.Cg              = 5;
ATR.t_c             = 0.18;
ATR.lambda          = 0;
ATR.P_maxSL         = 3.58*10^6;
ATR.eta_prop        = 0.8;
ATR.SFC_P           = 7.84*10^(-7); % Specific fuel consumption
ATR.phi             = 0; % Bank angle
ATR.mu_r            = 0.4;
ATR.wingDistFromGround = 4;
ATR.engineNumber    = 2;

%% DESIGN REQUIREMENTS
X_hv_req        = [1000*1852, Inf]; % Minimum range of 1000 nautical miles [m]
dTOFL_req       = 4500*0.3048;      % TOFL dictated by 4500 feet
dLFL_req        = 4500*0.3048;      % LFL dictated by 4500 feet
hObstacle_req   = 50*0.3048;        % 50 foot obstacle [m]
RoCtheta_req    = atand(28000/1.215e+6);
approachV_req   = 1;
stability_req   = [0, Inf];         % Don't know stability requirement yet
turning_req     = [0, Inf];         % Don't know turning requirement

%% COMPUTATIONS
% Initial Calculations
AR = b^2/S;
W_0 = W_fuel + W_battery + W_craft;
takeoffWeight = W_0;
ATR.W_0 = ATR.W_fuel + ATR.W_craft;
ATR.AR = ATR.b^2/ATR.S;

% Nominal ATR-42 Block Fuel Consumption
ATR.CL = 0.4; % Which CL to use
ATR.h = 8534.4; % Cruise altitude [m]
CL = 0.4;
h = 8534.4;
ATR_NominalFuelConsumption = computeBlockFuelConsumedFor400nmiJourney([ATR.CL, ATR.h], ATR.W_0, ATR.SFC_P, ATR.eta_prop, ATR.e, ATR.S, ATR.AR, ATR.C_D0, 'constantCLh');
OurNominalFuelConsumption = computeBlockFuelConsumedFor400nmiJourney([CL, h], W_0, SFC_P, eta_prop, e, S, AR, C_D0, 'constantCLh');

% Takeoff
hAirport = 0;
throttleSetting = 0.9;
numEngines = 2;
propDiameterMeters = 2;
TOFL = computeTakeoffFieldLength(W_0, hAirport, S, C_D0, b, e, eta_prop, C_Lmax,...
    wingDistFromGround, P_maxSL, numEngines, propDiameterMeters);

% Climb
throttleSetting = 0.8;
hAirport = 0; % Assume sea level conditions on average for climbing
[velocityVec, RoCVec] = computeRateOfClimbPROPS(hAirport, W_craft, P_maxSL, throttleSetting, eta_prop, C_D0, e, AR, S, 0);
RoC_Vmax = max(RoCVec/velocityVec); % Determine if fastest climb has a velocity triangle with a steeper gradient than required
climbFuelLost = weightLossDuringClimb(P_maxSL,W_0,hAirport,h,eta_prop,SFC_P,throttleSetting,e,AR,S,C_D0);

% Cruise
CL = 0.84; % Which CL to use
h = 8534.4; % Cruise altitude [m]
W_0 = W_0 - climbFuelLost;
W_1 = W_0 - OurNominalFuelConsumption*2;
X_1 = computeRangePROPS([CL, h], W_0, W_1, SFC_P, eta_prop, e, S, AR, C_D0, 'constantCLh');

W_0 = W_1;
X_2 = computeRangeBATT(eta_prop, h_battery, C_D0, e, AR, CL, W_battery, W_0);

totalRange = X_1 + X_2;

% % Drag - Which value to isolate from drag?
% [velocityVec, DincVec, DcompVec] = computedragPROPS(h, W_0, S, b, C_D0, e, t_c, lambda, false);

% Descent
% Compute approach speed

% Landing
landingFieldLength = computeLandingFieldLength(W_1, hAirport, C_D0, e, AR, S, b, C_Lmax, mu_r, wingDistFromGround, 1);

% Turning Performance Calcs

% Stability (static margin)

%% OUTPUT
% test = '| OK';
% test2 = ("| OFF BY " + h);
fprintf("=============== FINAL PLANE PARAMETERS ===============\n")
%fprintf("Minimum Power:         %14.2f lbs-ft/s      %s \n", P_R)
fprintf("Takeoff Weight:        %14.2f lbs            \n", takeoffWeight)
fprintf("Takeoff Field Length:  %14.2f m              \n", TOFL)
fprintf("Climb Fuel:            %14.2f N              \n", climbFuelLost)
fprintf("Rate of Climb Slope:   %14.2f                \n", RoC_Vmax)
fprintf("Nominal Fuel:         %14.2f N              \n", ATR_NominalFuelConsumption)
fprintf("Our Fuel Consumption:  %14.2f N              \n", OurNominalFuelConsumption)
fprintf("Gas Range:             %14.2f nmi            \n", X_1*0.000621371*0.868976)
fprintf("Battery Range:         %14.2f nmi            \n", X_2*0.000621371*0.868976)
fprintf("Total Range:           %14.2f nmi            \n", X_1*0.000621371*0.868976 + X_2*0.000621371*0.868976)
