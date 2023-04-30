function time = computeTimeToClimb(PmaxSL, W0, hAirport, hCruise,...
    etaProp, SFCp, throttleSetting, ev, AR, S, CD0)

%COMPUTETIMETOCLIMB will use a Runge-Kutta integration scheme in ode45 to
%esestimate the time (in seconds) it takes a propeller-powered aircraft to climb to its
%cruising altitude. This function assmes that the aircraft maintains a
%horizontal velocity of V = 1.3 * V_PR_min.
%
%INPUTS: 
%   - PmaxSL: Combined max thrust available at sea-level (W)
%   - W0: Initial weight during climb
%   - hAirport: Initial altitude (m)
%   - hCruise: Cruise altitude (m)
%   - etaProp: Propeller efficiency 
%   - SFCp: Specific fuel consumption for props (Nfuel/W/s)
%   - throttleSetting: Throttle setting 
%   - ev: Oswald efficiency factor 
%   - AR: Wing aspect ratio 
%   - S: Wing planform area (m^2)
%   - CD0: Zero-lift drag coefficient
%
%OUTPUTS: 
%   time: The time it takes the aircraft to reach its cruise altitude (in
%   seconds)

zInitial = [W0;0]; 

hSpan = [hAirport, hCruise]; 


[h, z] = ode45(@derivativeFunction, hSpan, zInitial, [], PmaxSL, W0, hAirport, hCruise, etaProp, SFCp, throttleSetting, ev, AR, S, CD0);

t = z(:,2);

time = t(end);



end 


function dzdh = derivativeFunction(h, z, PmaxSL, W0, hAirport, hCruise, etaProp, SFCp, throttleSetting, ev, AR, S, CD0)

W = z(1);

t = z(2);

[~, rho] = standardatmosphere(h);

rhoSL = 1.225; %kg/m^3

VPRmin = sqrt(2 * W / (rho * S * sqrt(3 * pi * ev * AR * CD0)));

Emax = 0.5 * sqrt(pi * ev * AR / CD0);

PA = throttleSetting * rho / rhoSL * PmaxSL;

rateOfClimb = PA / W - 2 * (1.3)^2 * VPRmin / (sqrt(3) * Emax);

dWdh = -1 * (SFCp / etaProp) * PA / rateOfClimb;

dtdh = 1/rateOfClimb;

dzdh = [dWdh; dtdh];

end 




