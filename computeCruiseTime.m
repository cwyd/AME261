function cruiseTime = computeCruiseTime(Wstart, Wend, SFCp, etaGas, ev,...
    AR, S, CD0, hCruise, CL)

%COMPUTECRUISETIME will determine the time (in seconds!) it takes for a...
%propeller-powered aircraft to cruise at a constant altitude and a...
%constant CL.
%
%INPUTS:
%   - Wstart: Weight of plane at start of cruise (N).
%   - Wend: Weight of plane at end of cruise (N).
%   - SFCp: Specific fuel consumption for props (N/W/s).
%   - etaGas: The overall efficiency of the gas engine.
%   - ev: Oswald efficiency factor.
%   - AR: Wing aspect ratio.
%   - S: Wing planform area (m^2).
%   - CD0: Zero-lift drag coefficient.
%   - hCruise: Cruise altitude (m).
%   - CL: Lift coefficient during cruise. 


Wspan = [Wend, Wstart];

tInitial = 0;

[W, t]= ode45(@derivativeFunction, Wspan, tInitial, [], Wstart, Wend,...
    SFCp, etaGas, ev, AR, S, CD0, hCruise, CL);

cruiseTime = t(end);

end 


function dtdW = derivativeFunction(W, t, Wstart, Wend, SFCp, etaGas, ev,...
    AR, S, CD0, hCruise, CL)

[~, rho] = standardatmosphere(hCruise);

CD = CD0+  CL^2 / (pi * ev * AR);

PR = CD / CL^(3/2) * sqrt(2 * W^3 / (rho * S)); 

dtdW = etaGas / (SFCp * PR); 

end 





