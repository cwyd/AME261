function endurance = computeEndurancePROPS(constantVariables, W0, W1, SFCp, eta, ev, S, AR, CD0, specifier)


%COMPUTEENDURANCEPROPS will determine the endurance of a propeller-driven aircraft
%in cruise at constant (CL, h), constant (CL, V), or constant (h,V). This program
%assumes incompressible flow and assumes a constant specific fuel
%consumptiuon SFCp. 
%
%INPUTS:
%   - constantVariables: A [2 x 1] numerical vector that contains the
%     actual values of the variables we are holding constant. For example,
%     if we are having a constant Cl and h, then constantVariables = [CL,
%     h], where "CL" and "h" are the numerical values of "CL" and "h,"
%     respectively. The variables in this array must also appear in the
%     following order: 
%           - [CL, h] or 
%           - [CL, V] or
%           - [h, V]. 
%          In other words, CL must always come before h or V, and h must
%          always come before V.
%
%   - W0: Initial cruise weight (N).
%   - W1: Weight at the end of cruise (N). 
%   - SFCp: Specific fuel consumption for props (Nfuel/W/s).
%   - eta: Propeller overall efficiency. 
%   - ev: Oswald efficiency factor. 
%   - S: Wing planform area (m^2).
%   - AR: Aspect Ratio.
%   - CD0: Zero-lift drag coefficient.
%   - specifier: A character array that can take one one of the following
%     exact forms: 
%           - 'constantCLh'
%           - 'constantCLV'
%           - 'constanthV'
%
%OUTPUTS:
%   - endurance: A numerical value of endurance (in seconds!!).

if strcmp(specifier, 'constantCLh')
    
    CL = constantVariables(1);

    CD = CD0 + CL^2 / (pi * ev * AR);

    h = constantVariables(2);

    [T, rho] = standardatmosphere(h);

    endurance = (eta / SFCp) * (CL^(3/2) / CD) * sqrt(2 * rho * S) * ...
        (W1^(-1/2) - W0^(-1/2));

elseif strcmp(specifier, 'constantCLV')
    
    CL = constantVariables(1);

    CD = CD0 + CL^2 / (pi * ev * AR);

    V = constantVariables(2);
    
    endurance = (eta / SFCp) * (1/V) * (CL / CD) * log(W0 / W1);

elseif strcmp(specifier, 'constanthV')
    
    h = constantVariables(1);

    V = constantVariables(2);

    [T, rho] = standardatmosphere(h);

    WD = 0.5 * rho * V^2 * S * sqrt(pi * ev * AR * CD0);

    W0star = W0/WD;

    zeta = (W0 - W1) / W0; %fuel fraction

    Emax = 0.5 * sqrt(pi * ev * AR / CD0); 

    endurance = (2 * eta / SFCp) * (Emax / V) * atan(W0star * zeta /...
        (1 + W0star^2 * (1 - zeta)));

else 
    error('Please read the help line :)')
    
end 





