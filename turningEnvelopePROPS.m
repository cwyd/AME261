function [qVec, qCLVec, qPmaxVec, rNStructVec, rCLMaxVec, rPMaxVec, vVec, vPMaxVec, nStructVec, nCLMaxVec, nPMaxVec] =...
    turningEnvelopePROPS(W, CD0, b, S, ev, nStruct, CLMax, PmaxSL, etaProp, h)

%TURNINGENVELOPEPROPS will calculate the arrays necessary to plot an r-q 
%and a V-n diagram for a given propeller-powered aircraft. Please note that 
%this program assumes incompressible flow. 
%
%INPUTS:
%   - W: Aircraft weight (N)
%   - CD0: Zero-lift drag coefficient
%   - b: Wingspan (m)
%   - S: Wing planform area (m^2)
%   - ev: Oswald efficiency factor 
%   - nStruct: Maximum value of load factor before structural failure
%   - CLMax: Maximum lift coefficient 
%   - PmaxSL: Maximum power available from all engines at sea-level (N)
%   - etaProp: Propeller efficiency factor. (between 0 and 1).
%   - h: The altitude at which the aircraft is flying (m)
%
%OUTPUTS: 
%   - qVec: A vector of dyanmic pressure values (in N/m^2) at which to plot 
%           r_{Tmax} vs. q. This vector also will determine the horizontal 
%           axis limits for the r-q plot. 
%   - qCLVec: A vector of dyanmic pressure values at which to plot
%             r_{CLmax} vs. q. These q values avoid the asymptote in this
%             graph. 
%   - qPMaxVec: A vector of dyanmic pressure values (in N/m^2) at which to 
%               plot r_{Tmax} vs. q. These q values avoid the potential 
%               asymptote that can arise in this curve. 
%   - rNStructVec: A vector of turning radius values (in meters) subject to
%                  the n_{struct} constraint. 
%   - rCLMaxVec: A vector of turning radius values (in meters) subject to
%                the C_{L,max} constraint. 
%   - rPMaxVec: A vector of turning radius values (in meters) subject to
%               the P_{max} constraint. 
%   - vVec: A vector of velocity values at which to create our V-n diagram.
%           (The n_{struct} and C_{L,max} curves can be plotted with this
%           vector of velocities.)
%   - vPMaxVec: Vector of velocity values at which to create the T_{max}
%               curve on the V-n diagram. 
%   - nStructVec: A vector of repeated n_{sturct} values (which are all 
%                 identical!), to be used in n_{sturct} plot.
%   - nCLMaxVec: A vector of load factor values subject to the C_{L,max}
%                constraint. 
%   - nPMaxVec: A vector of load factor values subject to the P_{max}
%               constraint. 

[~, rho] = standardatmosphere(h);

rhoSL = 1.225; %(kg/m^3)

g = 9.81; %(N/kg), acceleration due to gravity.


%We will construct the r-q diagram first. 

qVec = linspace(0, 20000, 100000);

rNStructVec = 2*qVec / (rho * g * sqrt(nStruct^2 - 1));


%Create new vector of q  values for CLMax calculation to avoid the vertical
%asymptote. 

qCLVec = linspace(W / (S * CLMax)+0.001, 20000, 10000);

rCLMaxVec = 2*qCLVec * (W/S) ./ (rho * g .* sqrt((CLMax * qCLVec).^2 - (W/S)^2));

AR = b^2 / S;

k = 1/(pi * ev * AR);

PA = PmaxSL * rho / rhoSL * etaProp; %Assume throttle setting = 1.

%If n = 1, then r_{Pmax} blows up, so there we must keep q above the 
%value of q that causes this blow-up. Therefore, we set a lower limit for
%the q's we will use to plot the P_{max} curve. 

CLPRmin = sqrt(3 * pi * ev * AR * CD0);

VPRmin = sqrt(2 * W / (rho * S * CLPRmin));

slowVelVec = linspace(0, VPRmin, 10000);


CLslowVec = W./(1/2*rho *slowVelVec.^2*S);

CDslowVec = CD0 + CLslowVec.^2 / (pi * ev * AR);

PRslowVec = (CLslowVec.^(3/2)./CDslowVec).^(-1) .* sqrt(2*W^3 / (rho * S));

errorVec = PRslowVec - PA; 

errorVec = abs(errorVec); 

minError = min(errorVec); 

indexOfMinError = find(errorVec == minError);

Vmin = slowVelVec(indexOfMinError);

lowerLimit = 1/2 * rho * Vmin^2; 


%Now find the upper limit.

fastVelVec = linspace(VPRmin, 300, 10000);

CLfastVec = W./(1/2*rho*fastVelVec.^2*S);

CDfastVec = CD0 + CLfastVec.^2 / (pi * ev * AR); 

    
PRfastVec = (CLfastVec.^(3/2)./CDfastVec).^(-1) .* sqrt(2*W^3 / (rho * S));

errorVec = PRfastVec - PA; 

errorVec = abs(errorVec); 

minError = min(errorVec); 

indexOfMinError = find(errorVec == minError);

Vmax = fastVelVec(indexOfMinError); 


upperLimit = 1/2 * rho * Vmax^2;

qPmaxVec = linspace(lowerLimit, upperLimit, 5000);

nPMaxVec = zeros(1, length(qPmaxVec));

rPMaxVec = zeros(1, length(qPmaxVec)); 



for index = 1:length(qPmaxVec)

    nTestVec = linspace(0, 20, 5000); 

    CDVec = CD0 + (nTestVec).^2 * W^2 / (qPmaxVec(index).^2 * S^2 * pi * ev * AR);

    CLVec = nTestVec * W / (qPmaxVec(index) * S); 

    PR = real(CDVec ./ (CLVec.^(3/2)).* sqrt(2 * nTestVec.^3 * W^3 / (rho * S)));

    errorVec = PR - PA; 

    errorVec = abs(errorVec); 

    minError = min(errorVec); 

    indexOfMinError = find(errorVec == minError); 

    nPMaxVec(index) = nTestVec(indexOfMinError); 

    rPMaxVec(index) = real(2 * qPmaxVec(index) / (rho * g * sqrt(nPMaxVec(index)^2 - 1)));
end 



%Now let's make the standard V-n diagram. 

vVec = linspace(0, 200, 10000);

nStructVec = zeros(1, length(vVec));

for index = 1:length(nStructVec)
    
    nStructVec(index) = nStruct; 

end 

newQVec = 1/2 * rho * vVec.^2;

nCLMaxVec = newQVec * S * CLMax / W;


%Now on to the Pmax limitation. 

vPMaxVec = sqrt(2 * qPmaxVec / rho);


%Now plot!
figure(1)

plot(qVec, rNStructVec, 'b', 'LineWidth', 1)

hold on 

plot(qCLVec, rCLMaxVec, 'r', 'LineWidth', 1)

plot(qPmaxVec, rPMaxVec, 'k', 'LineWidth', 1)

title('r vs. q Diagram')

xlabel('q (N/m^2')

ylabel('r (m)')

legend('n_{struct}', 'C_{L,max}', 'P_{max}', 'FontSize', 12)

ylim([0, 1000])

figure(2)

plot(vVec, nStructVec, 'b', 'LineWidth', 1)

hold on 

plot(vVec, nCLMaxVec, 'r', 'LineWidth', 1)

plot(vPMaxVec, nPMaxVec, 'k', 'LineWidth', 1)

legend('n_{struct}', 'C_{L,max}', 'P_{max}', 'FontSize', 12)


title('Standard V-n Diagram')

xlabel('V (m/s)')

ylabel('n')

xlim([Vmin, Vmax])




