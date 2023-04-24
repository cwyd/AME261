function deltaX = horizontalDistanceCoveredDuringClimb(PmaxSL, W0, hAirport, hCruise,...
    etaProp, SFCp, throttleSetting, ev, AR, S, CD0, plotting)

%HORIZONTALDISTANCECOVEREDDURINGCLIMB will use ode45 and a numerical
%integration procedure to determine the horizontal distance a
%propeller-powered aicraft covered during its climb as it climbs at the
%fastest/most-economical rate of climb. 
%
%INPUTS:
%   - PmaxSL: Maximum power available at sea-level (W).
%   - W0: Takeoff weight (N).
%   - hAirport: Alttitude of takeoff airport (m). 
%   - hCruise: Initial cruise altitude (m).
%   - etaProp: Propeller efficiency factor. 
%   - SFCp: Specific fuel consumption of propellers (Nfuel/W/s).
%   - throttleSetting: The throttle setting (number between 0 and 1).
%   - ev: Oswald efficiency factor 
%   - AR: Wing aspect ratio.
%   - S: Wing planform area (m^2).
%   - CD0: Zero-lift drag coefficient.
%   - plotting: Set plotting == 1 if you want to plot. Otherwise set
%     plotting == 0.
%
%OUTPUTS:
%   - deltaX: The horizontal distance the aircraft has traversed as it
%   climbs to its cruise altitude (m). 
%   - An optional output is a graphical representation of the climb profile
%     of the airplane. 


%Define the state variable z = [z(1); z(2)] = [X; W].
 
zInitial = [0; W0];  

hSpan = [hAirport, hCruise]; 

[h, z] = ode45(@derivativeFunction, hSpan, zInitial, [], PmaxSL, W0,...
    hAirport, hCruise, etaProp, SFCp, throttleSetting, ev, AR, S, CD0, plotting);

horitonzalDistanceRunningTotal = z(:,1);

deltaX = horitonzalDistanceRunningTotal(end);

if plotting == 1

    figure()

    plot(horitonzalDistanceRunningTotal, h, 'b', 'LineWidth', 1)

    title('Climb Profile')

    xlabel('x (m)')

    ylabel('h (m)')

end 

end 

function dzdt = derivativeFunction(h, z, PmaxSL, W0, hAirport,...
    hCruise, etaProp, SFCp, throttleSetting, ev, AR, S, CD0, plotting)

[~, rho] = standardatmosphere(h);

W = z(2);

rhoSL = 1.225; %kg/m^3

VPRmin = sqrt(2 * W / (rho * S * sqrt(3 * pi * ev * AR * CD0)));

Emax = 0.5 * sqrt(pi * ev * AR / CD0);

PA = throttleSetting * rho / rhoSL * PmaxSL;

rateOfClimb = PA / W - 2 * VPRmin / (sqrt(3) * Emax);

dWdh = -1 * (SFCp / etaProp) * PA / rateOfClimb;

dxdh = VPRmin / rateOfClimb; %dx/dh = dx/dt * dt/dh.

dzdt = [dxdh; dWdh];

end 





