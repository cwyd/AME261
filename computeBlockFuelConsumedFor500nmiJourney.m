function WfuelConsumed = computeBlockFuelConsumedFor500nmiJourney(constantVariables, W0, SFCp, eta, ev, S, AR, CD0, specifier)

%COMPUTEBLOCKFUELCONSUMEDFOR500NMIJOURNEY will estimate the amount of fuel
%a propeller-powered aircraft will consume to cruise 500 nmi. 
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
%   - W0: Initial weight (N).
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
%   - WfuelConsumed: The weight of fuel consumed to travel 500 nmi (N)


X = 500 * 1852; %Fixed range in meters.

if strcmp(specifier, 'constantCLh')
    
    CL = constantVariables(1);

    CD = CD0 + CL^2 / (pi * ev * AR);

    factor = eta * CL/CD / SFCp; 

    W1 = W0 * exp(-1 * X / factor);

    WfuelConsumed = W0 - W1;

elseif strcmp(specifier, 'constantCLV')
    
    CL = constantVariables(1);

    CD = CD0 + CL^2 / (pi * ev * AR);

    factor = eta * CL/CD / SFCp; 

    W1 = W0 * exp(-1 * X / factor);

    WfuelConsumed = W0 - W1;

elseif strcmp(specifier, 'constanthV')
    
    h = constantVariables(1);

    V = constantVariables(2);

    [~, rho] = standardatmosphere(h);

    WD = 0.5 * rho * V^2 * S * sqrt(pi * ev * AR * CD0);

    W0star = W0/WD;

    Emax = 0.5 * sqrt(pi * ev * AR / CD0); 

    factor = 2 * eta * Emax / SFCp; 

    newFactor = tan(X / factor); 

    zeta = (newFactor + W0star^2 * newFactor) / (W0star + W0star^2 * newFactor);

    WfuelConsumed = zeta * W0; 

else 
    error('Please read the help line :)')
    
end 





