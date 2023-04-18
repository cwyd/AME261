function plotPitchMomentCurve(hCG, hAC, tailLiftSlope, wingLiftSlope, epsilon0,...
    dEpsilondAlpha, etaTail, wingIncidentAngle, tailIncidentAngle, tailPlanformArea,...
    wingPlanformArea, distanceOfTailBehindCG, wingChord, tau, deltaElevator, CMAC)

%PLOTPITCHMOMENT will plot the CM vs. alpha curve for a given aircraft.
%
%INPUTS:
%- hCG: Distance of the center of gravity behind the nose, normalized by
%        wing chord length. 
% - hAC: Distance of the wing-body aerodynamic center behind the nose,
%        normalized by the wing chord length. 
% - tailLiftSlope: dCL/d(alpha) for the tail. 
% - wingLiftSlope: dCL/d(alpha) for the wing.
% - epsilon0: Downwash angle at zero absolute angle of attack.
% - dEpsilondAlpha: The partial derivative of the downwash angle with
%                   respect to the angle of attack.
% - etaTail: Tail efficiency factor (set this equal to 1 for a t-tail
%            aircraft.)
% - wingIncidentAngle: Wing incident angle (degrees)
% - tailIncidentAngle: Tail incident angle (degrees)
% - tailPlanformArea: Planform area of horizontal stabilizer (m^2)
% - wingPlanformArea: Planform area of wing (m^2)
% - distanceOfTailBehindCG: the distance of the tail (in meters!) behind
%                           the center of gravity.
% - wingChord: The chord of the wing (m).
% - tau: The necessary factor (as defined by Prof. Saakar) to help us
%        include the effects of elevator deflection.
% - deltaElevator: Elevator deflection angle (degrees)
% - CMAC: Moment coefficient about the aerodynamic center of the wing-body
%         combination. This can be roughly zero if the wing airfoil is symmetric
%         enough. 

Vt = tailPlanformArea * distanceOfTailBehindCG / (wingPlanformArea * wingChord);

CM0 = CMAC + tailLiftSlope * (epsilon0 + wingIncidentAngle - tailIncidentAngle) * Vt * etaTail;

staticMargin = computeStaticMargin(hCG, hAC, tailLiftSlope, wingLiftSlope, dEpsilondAlpha,...
    etaTail, tailPlanformArea, wingPlanformArea, distanceOfTailBehindCG, wingChord);

partialCMpartialAlpha = -1 * wingLiftSlope * staticMargin;

deltaCM = -1 * Vt * etaTail * tailLiftSlope * tau * deltaElevator;

%Generate vector of alpha values with which to plot

alphaVec = linspace(-4, 10, 1000);

CMVec = CM0 + partialCMpartialAlpha * alphaVec + deltaCM; 

figure()

plot(alphaVec, CMVec, 'b', 'LineWidth', 0.5)

hold on

y = ones(1, length(alphaVec)) * 0;

plot(alphaVec, y, ':k'); %Plot the horizontal axis.

title('C_{M,cg} vs. α_a')

xlabel('α_a (Degrees)')

ylabel('C_{M,cg}')


