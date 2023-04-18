function [staticMargin, neutralPoint] = computeStaticMargin(hCG, hAC, tailLiftSlope, wingLiftSlope, dEpsilondAlpha,...
    etaTail, tailPlanformArea, wingPlanformArea, distanceOfTailBehindCG, wingChord)

%COMPUTESTATICMARGIN will determine the static margin (normalized by wing
%chord) for a given aircraft. 
%
%INPUTS:
% - hCG: Distance of the center of gravity behind the nose, normalized by
%        wing chord length. 
% - hAC: Distance of the wing-body aerodynamic center behind the nose,
%        normalized by the wing chord length. 
% - tailLiftSlope: dCL/d(alpha) for the tail. 
% - wingLiftSlope: dCL/d(alpha) for the wing.
% - dEpsilondAlpha: The partial derivative of the downwash angle with
%                   respect to the angle of attack.
% - etaTail: Tail efficiency factor (set this equal to 1 for a t-tail
%            aircraft.)
% - tailPlanformArea: Planform area of horizontal stabilizer (m^2)
% - wingPlanformArea: Planform area of wing (m^2)
% - distanceOfTailBehindCG: the distance of the tail (in meters!) behind
%                           the center of gravity.
% - wingChord: The chord of the wing (m).
%
%OUTPUTS:
% - staticMargin: The static margin (as a fraction of the wing chord
%                 length).
% - neutralPoint: The position of the neutral point behind the wing (as a
%                 fraction of the wing chord length)


Vt = tailPlanformArea * distanceOfTailBehindCG / (wingPlanformArea * wingChord);

neutralPoint = hAC + (tailLiftSlope / wingLiftSlope) * Vt * etaTail * (1 - dEpsilondAlpha);

staticMargin = neutralPoint - hCG; 


end 


