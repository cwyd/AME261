function [velocityVec, RoCVec] = computeRateOfClimbPROPS(h, W, PmaxSL, throttleSetting, eta, CD0, ev, AR, S, plotOn)

%COMPUTERATEOFCLIMBPROPS will calculate and plot RoC vs. V for a
%propeller-driven aircraft at a particular altitude for all velocities 
%between Vmin and Vmax. As always, this program assumes incompressible flow. 
%
%INPUTS: 
%   - h: The altitude at which we are flying (m). 
%   - W: Nominal weight value (N).
%   - PmaxSL: Maximum shaft brake power available at sea-level (W). 
%   - throttleSetting: throttle setting (between 0 and 1). 
%   - eta: Propeller overall efficiency. 
%   - CD0: Zero-lift drag coefficient. 
%   - ev: Oswald efficiency factor. 
%   - AR: Aspect ratio 
%   - S: Wing planform area (m^2).
%   - plotOn: Boolean that dictates whether or not to plot
%
%OUPUTS: 
%   - velocityVec: A vector of velocities between Vmin and Vmax (just for
%     reference)
%   - RoCVec: A vector containing RoC values (in m/s) for all velocities in
%     velocityVec. 


[~, rho] = standardatmosphere(h);

rhoSL = 1.225; %(kg/m^3)


%The first step is to find Vmin and Vmax. 

CLPRmin = sqrt(3 * pi * ev * AR);

VPRmin = sqrt(2 * W / (rho * S * CLPRmin));

lowVelVec = linspace(0, VPRmin, 10000); 

lowQVec = 0.5 * rho * lowVelVec.^2; 

lowCLVec = W./(lowQVec * S);

lowCDVec = CD0 + lowCLVec.^2 / (pi * ev * AR);

PA = eta * PmaxSL * rho / rhoSL * throttleSetting; 

PRVec1 = 1 ./ (lowCLVec.^(3/2) ./ lowCDVec) .* sqrt(2 * W^3 / (rho * S));

errorVec1 = PA - PRVec1; 

errorVec1 = abs(errorVec1); 

minError1 = min(errorVec1); 

indexOfMinError = find(errorVec1 == minError1); 

Vmin = lowVelVec(indexOfMinError); 

%Now for Vmax...

highVelVec = linspace(VPRmin, 350, 10000); 

highQVec = 0.5 * rho * highVelVec.^2; 

highCLVec = W./(highQVec * S);

highCDVec = CD0 + highCLVec.^2 / (pi * ev * AR); 

PRVec = 1 ./ (highCLVec.^(3/2) ./ highCDVec) .* sqrt(2 * W^3 / (rho * S));

errorVec = PA - PRVec; 

errorVec = abs(errorVec); 

minError = min(errorVec); 

indexOfMinError = find(errorVec == minError); 

Vmax = highVelVec(indexOfMinError);

%Now let's compute and plot RoC vs. V. 

velocityVec = linspace(Vmin, Vmax, 10000); 

newCLVec = W ./ (1/2 * rho * velocityVec.^2 * S); 

newCDVec = CD0 + newCLVec.^2 / (pi * ev * AR); 

PRVec = 1 ./ (newCLVec.^(3/2) ./ newCDVec) .* sqrt(2 * W^3 / (rho * S));

RoCVec = (PA - PRVec) / W; 

if plotOn == true
    
    plot(velocityVec, RoCVec, 'b')
    
    title('RoC vs. V')
    
    xlabel('V (m/s)')
    
    ylabel('RoC (m/s)')
    
    ylim([0, 1.10*max(RoCVec)])
end

end 
