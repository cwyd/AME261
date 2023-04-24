function [VPRminVec, CLVec, rhoVec] = computeVPRminAtAltitudes(hVec, W, S, CD0, ev, AR)

%COMPUTEVPRMINATALTITUDES will determine VPRmin for a specific aircraft at
%specified altitudes (in meters). 
%
%INPUTS:
% - hVec: A vector of altitude values (m)
% - W: Aircraft weight (N)
% - S: Wing planform area (m^2)
% - CD0: Zero-lift drag coefficient
% - ev: Oswald efficiency factor 
% - AR: Wing aspect ratio

VPRminVec = zeros(1, length(hVec));
CLVec = zeros(1, length(hVec));
rhoVec = zeros(1, length(hVec));

for index = 1:length(hVec)

    CLVec(index) = sqrt(3 * pi * ev * AR * CD0);

    [~, rhoVec(index)] = standardatmosphere(hVec(index));

    VPRminVec(index) = sqrt(2 * W / (rhoVec(index) * S * CLVec(index)));

end 


end 