function [T, rho, mu] = standardatmosphere(h)

%%STANDARDATMOSPHERE is a function that produces values of temperature (T),
%%density (rho), and dynamic viscosity (mu) at a vector of altitudes (h) 
% between 0 and 25,000 m above sea-level.
%
%   INPUTS
%   - h: An (n x 1) or (1 x n) vector of altitude values measured in meters
%        (m). Note that h could also be a scalar if temperature, density, 
%        and visosity at just one altitude needs to be calculated. 
%
%   OUTPUTS
%   - T: An (n x 1) vector containing the temperature (measured in K) at 
%        each of the given altitudes. If h is just a scalar, then T is a 
%        scalar representing the temperature at just that single height h. 
%
%   - rho: An (n x 1) vector containing the density of air (measured in 
%          kg m^-3) at each of the given altitudes. If h is just a scalar, 
%          then rho is a scalar representing the density of air at just 
%          that single height h. 
%
%   - mu: An (n x 1) vector containing the dynamic viscosity of air 
%         (measured in kg m^-1 s^-1) at each of the given altitudes. If h
%         is just a scalar, then mu is a scalar representing the density of
%         air at just that single height h. 


%We will begin by conducting some input checks. 
while nargin < 1
    error('Not enough inputs!')
end 

while ~isnumeric(h) || ~isvector(h)
    error(['Please make sure that h is either a scalar or a vector with' ...
        ' numerical values. '])
end 

while max(h) > 25000
    error(['Please make sure that the input altitudes are between 0 m and' ...
        ' 25,000 m.'])
end 


%Before we can proceed any further, we must set some constants and
%parameters. The variable, a, will be the lapse rate for the temperature
%in the troposphere. 

a = -6.5 * 10^-3; %Measured in K m^-1.


%Also take note of the acceleration of due to gravity at sea-level, g0, 
%and the ideal gas constant for air, R. 

g0 = 9.81; %Measured in m s^-2.
R = 287; %Measured in J kg^-1 K^-1.

%We will now record the reference values of temperature and density at
%sea-level (ie. h = 0 m). 

T0 = 288; %Measured in K.
rho0 = 1.225; %Measured in kg m^-3.

%In case they will be useful, we will also store reference values of
%temperature, density, and viscosity at altitude h = 11,000 m. 

T11 = 288 + a * (11000 - 0); %Measured in K.
rho11 = rho0 * (T11 / T0)^(-g0 / (a * R) - 1); %Measured in kg m^-3. 
mu11 = 1.54 * (1 + 0.0039 * (T11 - 250)) * 10^(-5);%Measured in kgm^-1s^-1.

%Now, let us initialize our T, rho, and mu vectors. 
T = zeros(length(h), 1);
rho = zeros(length(h), 1);
mu = zeros(length(h), 1);


%At long last, we are ready to generate temperature, density, and viscosity
%data for all of the altitudes given in h. 

for index = 1:length(h)
    if h(index) <= 11000
        T(index) = T0 + a * (h(index) - 0);

        rho(index) = rho0 * (T(index) / T0)^(-g0 / (a * R) - 1);

        mu(index) = 1.54 * (1 + 0.0039 * (T(index) - 250)) * 10^(-5);

    elseif h(index) > 11000
        T(index) = T11; %Temperature is constant in the isothermal region.

        rho(index) = rho11 * exp(-g0 / (R*T11) * (h(index) - 11000));

        mu(index) = mu11; %Since temperature is constant, so is viscosity.
    end 
end 

end 
