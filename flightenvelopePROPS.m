function flightenvelopePROPS(W, S, ev, AR, CD0, propEfficiency, PMaxSL, CLmax, throttleSetting)

%FLIGHTENVELOPEPROPS will calculate and plot the flight envelope for a
%propeller-driven aircraft. This program assumes incompressible flow and
%steady, level flight.
%
%INPUTS:
%   - W: Weight [N], assumed to be constant
%   - S: Wing planform area [m^2]
%   - ev: Oswald efficiency factor
%   - AR: Aspect ratio
%   - CD0: Zero-lift drag coefficient 
%   - propEfficiency: Overall efficiency of props (a.k.a. η)
%   - PMaxSL: Max shaft brake power (COMBINED) at sea-level [W]
%   - CLmax: Max lift coefficient (in cruise conditions)
%   - throttleSetting: Throttle setting (a.k.a Π)
%
%OUTPUTS:
%   - A graph showing the flight envelope of the airplane of interest.


%Sice it is needed later, define the density at sea-level.

rhoSL = 1.225; %[kg/m^3]


%Begin by finding the density ratio at the ceiling: 

sigmaCeilCubed = (32*W^3 *CD0^2) /...
    (rhoSL*S*(3 * pi * ev * AR * CD0)^(3/2) * (propEfficiency * PMaxSL)^2);

sigmaCeil = (sigmaCeilCubed)^(1/3); 

rhoCeil = sigmaCeil * rhoSL; 

%Now that we know the density at the ceiling, let's find the ceiling
%altitude using our standardatmosphere function. 

altitudeTestVec = 0:10:12000;

[placeHolder, rhoTestVec] = standardatmosphere(altitudeTestVec);

errorVec = rhoTestVec - rhoCeil; 

errorVec = abs(errorVec);

minError = min(errorVec);

indexOfMinError = find(errorVec == minError); 

hCeil = altitudeTestVec(indexOfMinError); 


%Now, we are ready to begin computing our flight envelope. 

hVec = linspace(0, hCeil, 1000);

VstallVec = zeros(1, length(hVec));

VminVec = zeros(1, length(hVec));

VmaxVec = zeros(1, length(hVec)); 

%For each altitude in hVec, we must find the two velocities, Vmin and Vmax,
%at which power required = power available.

[placeHolder, rhoVec] = standardatmosphere(hVec); 

for index = 1:length(hVec)
    
    %Find the available power.
    PA = PMaxSL * propEfficiency * rhoVec(index)/rhoSL * throttleSetting; 

    %Now compute VPRmin at the current altitude. 
    
    CLPRmin = sqrt(3*pi*ev*AR*CD0);

    VPRmin = sqrt(2 * W / (rhoVec(index) * S * CLPRmin));

    slowVelVec = linspace(0, VPRmin, 1000);

    fastVelVec = linspace(VPRmin, 300, 1000); 


    %Now find Vmin using slowVelVec:

    CLslowVec = W./(1/2*rhoVec(index)*slowVelVec.^2*S);

    CDslowVec = CD0 + CLslowVec.^2 / (pi * ev * AR);

    PRslowVec = (CLslowVec.^(3/2)./CDslowVec).^(-1) .* sqrt(2*W^3 / (rhoVec(index) * S));

    errorVec = PRslowVec - PA; 

    errorVec = abs(errorVec); 

    minError = min(errorVec); 

    indexOfMinError = find(errorVec == minError);

    VminVec(index) = slowVelVec(indexOfMinError);


    %Now find Vmax from fastVelVec:

    CLfastVec = W./(1/2*rhoVec(index)*fastVelVec.^2*S);


    CDfastVec = CD0 + CLfastVec.^2 / (pi * ev * AR); 

    
    PRfastVec = (CLfastVec.^(3/2)./CDfastVec).^(-1) .* sqrt(2*W^3 / (rhoVec(index) * S));

    errorVec = PRfastVec - PA; 

    errorVec = abs(errorVec); 

    minError = min(errorVec); 

    indexOfMinError = find(errorVec == minError);

    VmaxVec(index) = fastVelVec(indexOfMinError); 


    %Finally, determine Vstall at the current altitude:

    VstallVec(index) = sqrt(2 * W / (rhoVec(index) * S * CLmax));

end 

%Generate flight envelope plot. 

figure()

plot(VminVec, hVec, 'b')

hold on

plot(VmaxVec, hVec, 'b')

plot(VstallVec, hVec, 'r')

xlim([min(VminVec) - 5, max(VmaxVec) + 5])

xlabel('V (m/s)')

ylabel('h (m)')

title('Flight Envelope for Propeller-Driven Flight')

end 






