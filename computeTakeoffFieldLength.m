function TOFL = computeTakeoffFieldLength(W0, hAirport, S, CLMax,...
    throttleSetting, PmaxSLOneEngine)

%COMPUTETAKEOFFFIELDLENGTH will estimate the takeoff field length for a
%two-engine aircraft. Technically this method was originally developed for
%jets, but we will cautiously apply it to our propeller-driven aircraft. 
%
%INPUTS: 
%   - W0: Takeoff weight (N)
%   - hAirport: Airport altitude above sea-level (m)
%   - S: Wing planform area (m^2)
%   - CLMax: Maximum lift coefficient 
%   - throttleSetting: Throttle setting (between 0 and 1)
%   - PmaxSLOneEngine: Maximum power available at sea-level from one
%     engine.
%
%OUTPUTS:
%   - TOFL: A (very) rough estimate of takeoff field length (m).

[~, rho] = standardatmosphere(hAirport);

rhoSL = 1.225; %(kg/m^3)

Vstall = sqrt(2 * W0 / (rho * S * CLMax));

VLO = 1.2 * Vstall; 
 
%Estimate a nominal value for thrust (N).
Tnominal = 0.9 * throttleSetting * PmaxSLOneEngine / (0.7 * VLO); 

densityRatio = rho / rhoSL; 

chi = W0^2 / (densityRatio^2 * S * CLMax * Tnominal);

TOFL = 0.217 * chi + 183; %In meters!

end 

