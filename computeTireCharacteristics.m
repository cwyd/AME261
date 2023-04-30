function [dNose, dMain, widthNose, widthMain, PNose, PMain] = computeTireCharacteristics(W)

%COMPUTETIRECHARACTERISTICS is a function that will determine the outer
%diageter, width, and tire pressures needed for tires on the nose gear and
%main gear of an aircraft with a tricycle landing gear setup. 
%
%INPUTS:
%  - W: Expected maximum weight of aircraft (N). 
%
%OUTPUTS:
%   - dNose: Nose gear tire diameter (m).
%   - dMain: Main gear tire diameter (m). 
%   - WNose: Nose gear tire width (m).
%   - wMain: Main gear tire width (m). 
%   - PNose: Pressure in nose gear tire (N/m^2). 
%   - PMain: Pressure in main gear tire (N/m^2).

factorSafety = 1.2;

Weff = 1.3 * W;

Wnose = 0.1 * Weff / 4.448; %Convert N to lb.

Wmain = 0.9 * Weff / 4.448; 

dNose = 1.51 * Wnose^0.349 * (1/39.37); %Convert "in" to "m."

dMain = 1.51 * Wmain^0.349 * (1/39.37);

widthNose = 0.715 * Wnose^0.312 * (1/39.37);

widthMain = 0.715 * Wmain^0.312 * (1/39.37);

Wnose = 0.1 * Weff; %Back to SI units...

Wmain = 0.9 * Weff;

PNose = Wnose / (2.3 * sqrt(dNose * widthNose) * (dNose/2 - 0.8 * dNose/2));

PMain = Wmain / (2.3 * sqrt(dMain * widthMain) * (dMain/2 - 0.8 * dMain/2));



