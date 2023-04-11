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
%   Documentation: https://docs.google.com/document/d/1s04e2THURuhZ66hpbRJmpVLHB_bnvNXdhlUeKBF3msU/edit
%

%% DESIGN INPUTS
C_D0            = 0.02;
C_Lmax          = 1;
W_craft             = 60;
e               = 0.87;
W_fuel          = 1;
W_battery       = 1;
S               = 3;
b               = 1;
Cg              = 1;
t_c             = 1;
lambda          = 1;
P_maxSL         = 1;
T               = 3; % Remove since we are using a prop plane
P_maxBattery    = 1;
eta_prop        = 1;
d_wing_ground   = 1; % Distance from wing to ground
SFC_P           = 1; % Specific fuel consumption
h_battery       = 1;
eta_battery     = 1;
phi             = 1; % Bank angle
mu_r            = 1;
wingDistFromGround = 1;
engineNumber    = 2;
cruiseAlt = 1;

%% DESIGN REQUIREMENTS
X_Clmax_req    = [,];
x_hv_req        = [,];
dG_req          = [,];
dLo_req         = [,];
emissions_req   = [,];
turning_req     = [,];  % 
ground_req      = [,];

%% COMPUTATIONS
% Calculate each output parameter and store in array

% Aspect Ratio
AR = b^2/S;

% % Weights
W_0 = W_fuel+W_battery+W_craft;
W_1 = W_0 - W_fuel;
% Wpayload = W1 - W_empty - W_battery;

% Drag 
[velocityVec, DincVec, DcompVec] = computedragPROPS(h, W_0, S, b, C_D0, e, t_c, lambda, false)'

% Power
h = cruiseAlt;
[P_R, PA, P_Rmin, v] = computePowerPROPS(h, C_D0, e, S,b, C_Lmax, W_0, P_maxSL, eta_prop);

% % Range
CL = 1;
range = computeRangeBATT(eta_prop, h_battery, C_D0, e, AR, CL, W_battery, W_0);

% Emissions

% Rate of Climb - What weight to use, and what throttle setting?
throttleSetting = 1;
[velocityVec, RoCVec] = computeRateOfClimbPROPS(h, W_0, P_maxSL, throttleSetting, eta_prop, C_D0, e, AR, S, false);

% Endurances of Prop
h = 1;
V = 1;
endurance_Clh = computeEndurancePROPS([C_Lmax, h], W_0, W_1, SFC_P, eta_prop, e, S, AR, C_D0, 'constantCLh');
endurance_Clv = computeEndurancePROPS([C_Lmax, V], W_0, W_1, SFC_P, eta_prop, e, S, AR, C_D0, 'constantCLV');
endurance_hv  = computeEndurancePROPS([h, V], W_0, W_1, SFC_P, eta_prop, e, S, AR, C_D0, 'constanthV');

% Takeoff
hAirport = 0;
P_maxSLOneEngine = P_maxSL/engineNumber;
dLo = computeDLO(W_0, hAirport, C_D0, e, AR, S, b, C_Lmax, mu_r, wingDistFromGround, P_maxSL, eta_prop);
TOFL = computeTakeoffFieldLength(W_0, hAirport, S, C_Lmax, throttleSetting, P_maxSLOneEngine);

% Landing
groundRoll = computeGroundRoll(W_1, hAirport, C_D0, e, AR, S, b, C_Lmax, mu_r, wingDistFromGround);
landingFieldLength = computeLandingFieldLength(W_1, hAirport, C_D0, e, AR, S, b, C_Lmax, mu_r, wingDistFromGround);

% Turning Performance Calcs

% Stability (static margin)

% Ground effect calcs

%% PRINTING

% Create filtered arrays by going through each

% Write text file that prints out filtered arrays
% 
% for i = 1:numel(spread{1,3})
%    
% 
%     Change cells
%     for j = 1:size(spread, 1)
%         value           = spread{j,3};
%         argument        = [char(spread{j,2}), ' = ', num2str(value(i))];
%         A{spread{j,1}}  = sprintf(argument);
%     end
% 
%     Write cell A into txt
%    
%     fid = fopen('masterFile.txt', 'a');
%     for k = 1:numel(A)
%         if A{k+1} == -1
%             fprintf(fid,'%s', A{k});
%             break
%         else
%             fprintf(fid,'%s\n', A{k});
%         end
%     end
% end
% 
