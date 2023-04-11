% returns values to plot incompressible power required and power available
function [P_R, PA, P_Rmin, v] = computePowerPROPS(h, CDo, e, S, b, CLmaxn, Wto, Pmax_SL, eta)

%% Preliminary Calculations
AR = b^2/S; % Aspect Ratio
k = 1/(pi*e*AR); % Design constant
Em = 1/sqrt(4*k*CDo); % Max Lift-to-Drag ratio
[T, dens, mu] = standardatmosphere(h); % Atmospheric density at specified altitude h
PA = eta * Pmax_SL * dens/1.225; % Power available at h

% Minimum and Maximum velocities at h
v_stall = sqrt(2*Wto / (dens*S*CLmaxn));
v_cr = (2*PA/(dens*CDo*S))^(1/3);

% Vector of range of velocities
v = v_stall/2:2:v_cr;

% Dynamic Pressure 
q = 0.5*dens*v.^2;

% Incompressible Drag
CL = Wto./(q.*S);
CD = CDo + k.*CL.^2;
Dinc = CD.*q.*S;

% Power Required
P_R = Dinc.*v;

% P_Rmin
CD = 4*CDo;
CL = sqrt(3*CDo/k);
V_PRmin = sqrt(2*Wto/(dens*S*CL));
D_PRmin = 4*CDo*Wto/CL;
P_Rmin = sqrt(2*Wto^3/(dens*S)) * 1/(CL^(3/2)/CD);
end