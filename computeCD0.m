function CD0 = computeCD0(lFus, dFus, cHS, SHS, cVS, SVS, cWing, SWing, lProtuberance, SProtuberance, VCruise, hCruise, cdmin)

%COMPUTECD0 will numerically estimate CD0 based on the geometry of an
%entire aircraft. This computation will assume turbulent flow!!
%
%INPUTS: 
%   - lFus: Fuselage length (m)
%   - dFus: Fuselage diameter (m)
%   - cHS: Mean chord of horizontal stabilizer (m)
%   - SHS: Planform area (top-sided, but includes left and right sections) 
%          of horizontal atabilizer (m^2)
%   - cVS: Mean chord of vertical stabilizer (m)
%   - SVS: Area of one side of the vertical stabilizer (m^2)
%   - cWing: Mean chord of the wing (m)
%   - SWing: Wing planform area (m^2)
%   - lProtuberance: A characteristic streamwise length scale for the
%                    protuberances (m).
%   - SProtuberance: Estimate area of any other protuberances (eg. fuel
%                    tankes) in units of (m^2)
%   - VCruise = Cruise velocity (m/s)
%   - hCruise = Cruise altitude (m)
%   - cdmin: Zero-lift profile drag coefficient for the wing airfoil. 
%           (This is a 2D effect!)


%Let's first determine our cruise conditions. 

[~, rho, mu] = standardatmosphere(hCruise);


%Now compute the equivalent parasite drag area of the fuselage. 


SwetFus = pi * dFus / 2 * (dFus + lFus);

ReFus = rho * VCruise * lFus / mu; 

CfFus = 0.074 / (ReFus)^(0.2); 

AFus = (1 + 1.5 *  (lFus/dFus)^(-1.5) + 7 * (lFus/dFus)^(-3)) * CfFus * SwetFus; 


%Find the equivalent parasite drag area of the wing. 

ReWing = rho * VCruise * cWing / mu; 

CfWing = 0.074 / (ReWing)^(0.2); 

AWing = 2 * CfWing * SWing; 

%Find the equivalent parasite drag area of the horizontal stabilizer.

ReHS = rho * VCruise * cHS / mu; 

CfHS = 0.074 / (ReHS)^(0.2); 

AHS = 2 * CfHS * SHS; 

%Find the equivalent parasite drag area of the vertical stabilizer. 

ReVS = rho * VCruise * cVS / mu; 

CfVS = 0.074 / (ReVS)^(0.2); 

AVS = 2 * CfVS * SVS; 

%Account for the skin friction drag due to extra protuberanes. 

ReProtuberance = rho * VCruise * lProtuberance / mu; 

CfProtuberance = 0.074 / (ReProtuberance)^(0.2); 

AAux = CfProtuberance * SProtuberance; 

%Now assemble the final CD0 estimate. 

CD0 = cdmin + (AFus + AWing + AHS + AVS + AAux) / SWing; 

end 


