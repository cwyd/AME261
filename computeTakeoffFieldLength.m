function TOFL = computeTakeoffFieldLength(W0, hAirport, S, CD0, b, ev, etaProp, CLMax,...
    wingDistAboveGround, PmaxSL, numEngines, propDiameterMeters)

%COMPUTETAKEOFFFIELDLENGTH will estimate the takeoff field length for a
%two-engine aircraft. Technically this method was originally developed for
%jets, but we will cautiously apply it to our propeller-driven aircraft.
%This algorithm is adapted from Page 489 of the Raymer book. 
%
%INPUTS: 
%   - W0: Takeoff weight (N)
%   - hAirport: Airport altitude above sea-level (m)
%   - S: Wing planform area (m^2)
%   - CD0: Zero-lift drag coefficient
%   - b: Wingspan (m)
%   - ev: Oswald efficiency factor
%   - etaProp: Propeller efficiency factor.
%   - CLMax: Maximum lift coefficient 
%   - throttleSetting: Throttle setting (between 0 and 1)
%   - wingDistAboveGround: Height of wing above ground (m).
%   - PmaxSL: Maximum power available at sea-level (W).
%   - numEngines: The number of engines our aircraft has. 
%   - propDiameterMeters: Diameter of propeller (m).
%
%OUTPUTS:
%   - TOFL: A  rough estimate of takeoff field length (m).

[~, rho] = standardatmosphere(hAirport);

rhoSL = 1.225; %(kg/m^3)

g = 9.81; %(m/s^2)

%We will convert our quantities into Imperial Units, do all our
%calculations using the Raymer equations, and then convert our final
%balanced takeoff field length into meters. 

bhp = etaProp * PmaxSL * (rho / rhoSL) * (1 / 745.7); 

propDiameterFeet = propDiameterMeters * (3.28084 / 1); 
%Convert prop diameter from meters to feet. 

Taverage = 5.75 * bhp * ( (rho/rhoSL) * numEngines * propDiameterFeet^2 / (bhp))^(1/3);

hObstacleFeet = 35; %Obstacle height in feet.


%Now let's compute gammaClimb and gammaMin, as defined by Raymer. 

PATakeoffOneEngineOut = (1/2) * (PmaxSL * rho / rhoSL);

groundEffectFactor = (16*wingDistAboveGround / b)^2 / (1 + (16 * wingDistAboveGround/b)^2);

AR = b^2 / S;

CD = CD0 + groundEffectFactor * CLMax^2 / (pi * ev * AR); 

factor = (CLMax^(3/2) / CD)^(-1);

PRTakeoff = factor * sqrt(2 * W0^3 / (rho * S));

Vstall = sqrt(2 * W0 / (rho * S * CLMax));

VLO = 1.2 * Vstall; 

ratio = (PATakeoffOneEngineOut - PRTakeoff) / (W0 * VLO);

gammaClimb = asin(ratio);

if numEngines == 2

    gammaMin = 0.024; 

elseif numEngines == 3

    gammaMin = 0.027; 

elseif numEngines == 4

    gammaMin = 0.030; 

else 

    gammaMin = 0.032; 

end 


GFactor = gammaClimb - gammaMin; 

UFactor = 0.01 * CLMax + 0.02; 

component1 = 0.863 / (1 + 2.3 * GFactor); 

component2 = (W0/S)/ (rho * g* CLMax) + hObstacleFeet;

component3 = 1 / (Taverage / W0 - UFactor) + 2.7;

balancedFieldLength = component1 * component2 * component3 + (655 / sqrt(rho / rhoSL));


TOFL = 1.15 * balancedFieldLength * (1/ 3.28084); 
%TOFL = 1.15 * BalancedFieldLength * (conversion factor from feet to
%meters).




