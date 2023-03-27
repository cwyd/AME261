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
C_D0            = 0.02:0.001:0.04;
C_Lmax          = 
W0              = 60;
W_fuel          = 
W_battery       =
S               = 3;
b               = ;
Cg              = ;
t_c             = ;
lambda          = ;
P_maxSL         = ;
P_maxBattery    = ;
eta_prop        = ;
d_wing_ground   = ; % Distance from wing to ground
SFC_P           = ; % Specific fuel consumption
h_battery       = ;
eta_battery     = ;
phi             = ; % Bank angle

%% DESIGN REQUIREMENTS
X_hClmax    = [,];
X_hClmax    = [,];
x_hv        = [,];
dG          = [,];
dLo         = [,];
emissions   = [,];
turning     = [,];  % 
ground      = [,];

%% COMPUTATIONS
% Calculate each output parameter and store in array

AR
Wpayload = W1 - W_empty - W_battery;

% Lift and Drag Calcs
C_L = 
LDmax           = 

% Range Calcs

% Emission calcs

% Takeoff and Landing

% Turning Performance Calcs
L = C_L*cos(phi);
n = L/W;

% Stability (static margin)


% Ground effect calcs
phi_ground      = ; % Ground effect parameter


%% PRINTING

% Create filtered arrays by going through each

% Write text file that prints out filtered arrays

for i = 1:numel(spread{1,3})
   

    % Change cells
    for j = 1:size(spread, 1)
        value           = spread{j,3};
        argument        = [char(spread{j,2}), ' = ', num2str(value(i))];
        A{spread{j,1}}  = sprintf(argument);
    end

    % Write cell A into txt
   
    fid = fopen('masterFile.txt', 'a');
    for k = 1:numel(A)
        if A{k+1} == -1
            fprintf(fid,'%s', A{k});
            break
        else
            fprintf(fid,'%s\n', A{k});
        end
    end
end

