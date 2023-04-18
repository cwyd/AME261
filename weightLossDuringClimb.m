function fuelConsumedDuringClimb = weightLossDuringClimb(PmaxSL, W0, hAirport, hCruise, etaProp, SFCp, throttleSetting, ev, AR, S, CD0)

%WEIGHTLOSSDURINGCLIMB will use ode45 to determine the weight of fuel
%consumed during climb for a propeller-powered aircraft. This program
%assumed the aircraft will be climbing at PRmin.
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
%   - fuelConsumedDuringClimb: The weight of fuel consumed during climb (N)


Winitial = W0; 


hSpan = [hAirport, hCruise]; 


[h, W] = ode45(@derivativeWeight, hSpan, Winitial, [], PmaxSL, W0, hAirport, hCruise, etaProp, SFCp, throttleSetting, ev, AR, S, CD0);

WAtCruiseStart = W(end);

fuelConsumedDuringClimb = W0 - WAtCruiseStart;

end 




function dWdh = derivativeWeight(h, W, PmaxSL, W0, hAirport, hCruise, etaProp, SFCp, throttleSetting, ev, AR, S, CD0)

[~, rho] = standardatmosphere(h);

rhoSL = 1.225; %kg/m^3

VPRmin = sqrt(2 * W / (rho * S * sqrt(3 * pi * ev * AR * CD0)));

Emax = 0.5 * sqrt(pi * ev * AR / CD0);

PA = throttleSetting * rho / rhoSL * PmaxSL;

rateOfClimb = PA / W - 2 * VPRmin / (sqrt(3) * Emax);

dWdh = -1 * (SFCp / etaProp) * PA / rateOfClimb;

end 



