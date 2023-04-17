function serviceCeilingAltitude = computeServiceCeiling(W, PmaxSL, throttleSetting, eta, CD0, ev, AR, S)

%COMPUTESERVICECEILING will determine the service ceiling for a
%propeller-powered aircraft in accordance with common regulations. The
%service ceiling is defined to be the altitude where RoC_max = 100 ft/min =
%0.508 m/s. 
%   
%INPUTS:
%   - W: Nominal weight value (N).
%   - PmaxSL: Maximum shaft brake power available at sea-level (W). 
%   - throttleSetting: throttle setting (between 0 and 1). 
%   - eta: Propeller overall efficiency. 
%   - CD0: Zero-lift drag coefficient. 
%   - ev: Oswald efficiency factor. 
%   - AR: Aspect ratio 
%   - S: Wing planform area (m^2).
%
%OUTPUTS:
%   - serviceCeilingAltitude (m).

hVec = linspace(0, 14000, 1000);

maxRoCVec = zeros(1, length(hVec));

for index = 1:length(hVec)
    
    rateOfClimbVec = computeRateOfClimbPROPS(hVec(index), W, PmaxSL, throttleSetting, eta, CD0, ev, AR, S, 0);

    maxRoCVec(index) = max(rateOfClimbVec); 

end 

RoCmaxAllowable = 0.508; %m/s, equivalent to 100 feet/min 

errorVec = maxRoCVec - RoCmaxAllowable; 

errorVec = abs(errorVec);

minError = min(errorVec);

indexOfMinError = find(errorVec == minError); 

serviceCeilingAltitude = hVec(indexOfMinError); 
