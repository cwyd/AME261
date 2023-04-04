function liftoffDist = computeDLO(W0, hAirport, CD0, ev, AR, S, b, CLMax, fricCoeff, wingDistFromGround, PmaxSL, eta)

%COMPUTEDLO will calculate the lift-off distance (in meters) for an
%aircraft. 
%
%INPUTS:
%   - W0: Takeoff weight (N)
%   - hAirport: Airport altitude (m)
%   - CD0: Zero-lift drag coefficient
%   - ev: Oswald efficiency factor
%   - AR: Aspect ratio
%   - S: Wing planform area (m^2)
%   - b: Wingspan (m)
%   - CLMax: Max lift coefficient 
%   - fricCoeff: Coefficient of rolling friction 
%   - wingDistFromGround: Distance of wings above ground (m) for ground
%     effect calculations 
%   - PmaxSL: Maxmimum shaft brake power available at sea-level (W)
%   - eta: Propeller efficiency, overall 
%OUTPUTS: 
%   - liftoffDist: Liftoff distance for aircraft (m).


[~, rho] = standardatmosphere(hAirport);

rhoSL = 1.225; %(kg/m^3)

g = 9.81; %(N/kg)

phiGroundEffect = (16*wingDistFromGround / b)^2 / (1 + (16*wingDistFromGround / b)^2);

CD = CD0 + phiGroundEffect * CLMax^2 / (pi * ev * AR);

VLO = 1.2 * sqrt(2*W0 / (rho * S * CLMax));

Vnominal = 0.7 * VLO;

Tnominal = eta * rho / rhoSL * PmaxSL / Vnominal; 

DphiNominal = 0.5 * rho * Vnominal^2 * S * CD; 

fricNominal = fricCoeff * (W0 - 0.5 * rho * Vnominal^2 * S * CLMax);

liftoffDist = 1.44 * W0^2 / (rho * g * S * CLMax * (Tnominal - DphiNominal - fricNominal));

end 




