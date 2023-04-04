function range = computeRangeBATT(eta, hBat, CD0, ev, AR, CL, WBat, WPlane)

%COMPUTERANGEBATT will calculate the range (in meters) for a bettery-powered 
%electric aircraft. 
%
%INPUTS: 
%   - eta: Overall effieiency from the battery.
%   - hBat: Specific energy of battery (J/kg).
%   - CD0: Zero-lift drag coefficient.
%   - ev: Oswald efficiency factor. 
%   - AR: Aspect ratio. 
%   - CL: Lift coefficient.
%   - WBat: Weight of the battery (N). 
%   - Wplane: Weight of the whole plane, including battery (N). 

g = 9.81; %(N/kg)

CD = CD0 + CL^2 / (pi * ev * AR);

range = (1/g)*(eta * hBat)*(CL/CD) * (WBat / WPlane);

end 