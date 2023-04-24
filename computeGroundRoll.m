function groundRollDist = computeGroundRoll(W1, hAirport, CD0, ev, AR, S, b, CLMax, fricCoeff, wingDistFromGround, etaProp, PmaxSL, reverseThrustFraction)

%COMPUTEGROUNDROLL will calculate a rough estimate for the ground roll
%distance for a proleller-powered aircraft.
%
%INPUTS: 
%   - %INPUTS:
%   - W1: Landing weight (N)
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
%   - etaProp: Propeller efficiency factor.
%   - PmaxSL: Maximum power avaiable at sea-level (W).
%   - reverseThrustFraction: Fraction of maximum thrust available at
%     sea-level that is converted to reverse thrust. 
%OUTPUTS: 
%   - groundRollDistance: ground roll distance for aircraft (m).


[~, rho] = standardatmosphere(hAirport);

rhoSL = 1.225; %(kg/m^3)

g = 9.81; %(N/kg)

phiGroundEffect = (16*wingDistFromGround / b)^2 / (1 + (16*wingDistFromGround / b)^2);

CD = CD0 + phiGroundEffect * CLMax^2 / (pi * ev * AR);

VT = 1.3 * sqrt(2 * W1 / (rho * S * CLMax));

Vnominal = 0.7 * VT; 

DphiNominal = 0.5 * rho * Vnominal^2 * S * CD; 

fricNominal = fricCoeff * (W1 - 0.5 * rho * Vnominal^2 * S * CLMax);

groundRollDist = 1.69 * W1^2 / (rho * g * S * CLMax * (reverseThrustFraction * etaProp * PmaxSL * rho / rhoSL / Vnominal + DphiNominal + fricNominal));

end 
