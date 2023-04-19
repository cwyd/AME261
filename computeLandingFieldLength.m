function landingFieldLength = computeLandingFieldLength(W1, hAirport, CD0, ev, AR, S, b, CLMax, fricCoeff, wingDistFromGround, spoilers)

%COMPUTELANDINGFIELDLENGTH will determine an FAR estimate for the landing
%field length of a propeller-driven aircraft. (Assumes no reverse thrust!)
%
%INPUTS:
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
%   - spoilers: 1 if there are spoilers, 0 if there are no spoilers.
%
%OUTPUTS
%   - FAR landing field length estimate. 


[~, rho] = standardatmosphere(hAirport);

rhoSL = 1.225; %(kg/m^3)

g = 9.81; %(N/kg)

phiGroundEffect = (16*wingDistFromGround / b)^2 / (1 + (16*wingDistFromGround / b)^2);

CD = CD0 + phiGroundEffect * CLMax^2 / (pi * ev * AR);

Vstall = sqrt(2 * W1 / (rho * S * CLMax));

VT = 1.3 * Vstall;

Vnominal = 0.7 * VT; 

DphiNominal = 0.5 * rho * Vnominal^2 * S * CD; 

if spoilers == 0

    fricNominal = fricCoeff * (W1 - 0.5 * rho * Vnominal^2 * S * CLMax);

elseif spoilers == 1

    fricNominal = fricCoeff * W1 ;

else 

    error('Please review the help line.')

end 

groundRollDist = 1.69 * W1^2 / (rho * g * S * CLMax * (DphiNominal + fricNominal));


%Now find d_Air, the sum of the glide distance and the decceleration
%distance.

dAir = (CLMax / CD) * (15 + 0.133 * Vstall^2 / (2 * g));

landingFieldLength = (1/0.6) * (dAir + groundRollDist); 




