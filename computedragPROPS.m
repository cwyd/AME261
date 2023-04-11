function [velocityVec, DincVec, DcompVec] = computedragPROPS(h, W, S, b, CD0,...
    ev, tOverC, Lambda, plotOn)

%COMPUTEDRAG will calculate and plot the incompressible drag and compressible...
%drag for a subsonic aircraft in steady, level flight.
%
%   INPUTS:
%   - h: The altitude (in meters) that the airplane is flying at. 
%
%   - W: The weight (in kg) of the aircraft. Weight is assumed to remain
%     constant in the computations that follow. 
%
%   - S: The planform area (in m^2) of the aircraft's wing. 
%
%   - b: Wingspan (in meters).
%
%   - CD0: The zero-lift drag coefficient.
%
%   - throttleSetting: The throttle setting (between 0 and 1) of the 
%     aircraft. We often assume that throttleSetting = 1.
%
%   - ev: Oswald efficiency factor (usually between 0.7 and 1). 
%
%   - tOverC: Maximum wing thickness-to-chord length ratio. This quantity 
%     is used when computing the compressible drag.
% 
%   - Lambda: The wing sweep angle (in degrees). 
%
%   - plotOn: A boolean that dictates whether or not to plot
%
%   OUTPUTS:
%   - velocityVec: A row vector containing velocities (spaced in 5 m/s
%     increments) between Vmin and Vmax (inclusive).
%
%   - DincVec: A row vector containing the incompressible drag values (in N) 
%     for all velocities in velocityVec
%
%   - DcompVec: A row vector containing the compressible drag values (in N) 
%     for all velocities in velocityVec



%Let's begin by computing some important parameters we will need later. 

AR = b^2/S; %Aspect ratio

k = 1/(pi*ev*AR); %The "magic" k factor!

[T, rho] = standardatmosphere(h); %Temperature (K), air density...
%(kg/m^3), and dynamic viscosity (kg m^-1 s^-1) at altitude h. 

velocityVecStart = 10;
velocityVecEnd = 250; 

velocityVec = velocityVecStart:0.05:velocityVecEnd; %Consturct velocityVec so
%that all of the values are nice, integer multiples of 5 m/s. 


%From here, we can construct DincVec. 

qVec = (1/2).*rho.*velocityVec.^2; 

CLVec = W ./ (S*qVec);

CDVec = CD0 + k.*CLVec.^2; 

liftToDragVec = CLVec ./ CDVec; 

DincVec = W ./ liftToDragVec; 


%Now, let's calculate the compressible drag at each velocity in velocityVec
%and store the values in DcompVec. 

%First find the free-stream Mach number.

specificHeatRatio = 1.4; %Specific heat ratio of air.

R = 287; %Ideal gas constant for air (in J kg^-1 K^-1).

MinfinityVec = velocityVec ./ sqrt(specificHeatRatio*R*T); 


%Then, find the critical Mach number associated to Lambda = 0. 
MccNoSweepVec = 0.87 - 0.175 .* CLVec - 0.83 * tOverC; 

%Next, compute the magic m factor that will later help us find the critical
%Mach number at sweep angle Lambda. 
mVec = real(0.83 - 0.583 * CLVec + 0.111 * CLVec.^2);


MccLambdaVec = MccNoSweepVec ./ ((cosd(Lambda)).^mVec); 

%Divide the free-stream Mach number by the critical Mach number for each 
%of the flight speeds in velocityVec. 

xVec = MinfinityVec ./ MccLambdaVec; 

yVec = real((3.97*10^(-9)) * exp(12.7 * xVec) + (1*10^(-40)) * exp(81 * xVec));

%Now we can form the vector of "∆CDc" values for each flight speed in
%velocityVec. 
deltaCDcVec = yVec * (cosd(Lambda))^3; 

%For all velocities in velocityVec that correspond to a lift coefficient
%greater than 1.4, we must set ∆CDc = 0 because the methods above are only
%valid for CL < 1.4. 

for index = 1:length(velocityVec)
    if CLVec(index) >= 1.4
        deltaCDcVec(index) = 0; 
    end 
end 

%Let's form the total drag coefficient by summing up CD0, CDi, and ∆CDc. 
CDtotCompVec = CD0 * ones(1, length(velocityVec)) + k * CLVec.^2 + deltaCDcVec; 

%Determine compressible lift-to-drag ratios. 
compLiftToDragVec = CLVec./CDtotCompVec; 

%Divide W by compLiftToDragVec to find the total compressible drag.

DcompVec = W ./ compLiftToDragVec; 


%Lastly, we can create our plot. 
if plotOn == true
    
    figure()
    
    plot(velocityVec, DincVec); 
    hold on 
    plot(velocityVec, DcompVec); 
    
    title('D_{inc}, D_{comp} vs. V_{∞}')
    xlabel('V_{∞} (m/s)')
    ylabel('D (N)')
    
    ylim([0, 2*10^5])
end

end 