function turningEnvelope(h, phi, W, S, ev, AR, CD0, Tmax, CLmax)
% TURNINGENVELOPE calculates and then plots an r-q and V-n graph
% with used inputs
% %INPUTS:
%   - h: Height/altitude [m]
%   - phi: Bank angle
%   - W: Weight [N], assumed to be constant
%   - S: Wing area [m^2]
%   - ev: Oswald efficiency factor
%   - AR: Aspect Ratio
%   - CD0: Zero lift drag coefficient
%   - Tmax: Max thrust at sea level
%   - CLmax: Max lift coefficient 

%constants
[~, rho] = standardatmosphere(h);
rhoSL = 1.225;      %kg/m^3
g = 9.81;    %m/s^2


%Inital calculations, constant values
k = 1/(pi*ev*AR);
Em = 1/sqrt(4*k*CD0);
thrustA = ((Tmax*rho)/rhoSL); %thrust available, combined, N

%not sure which n is right to use. its one of these. For sure. 
n = Em * Tmax/W;
%n = 1/cosd(phi);


%Calculate qmin and qmax values, which creates vmin and vmax values
qmax = (thrustA/(2*CD0*S))*(1 + sqrt(1-((4*k*CD0)/(thrustA/W)^2))); %max q
Vmax = sqrt((2*qmax)/rho);                                           %max velocity from max q, [m/s]
qmin = (thrustA/(2*CD0*S))*(1 - sqrt(1-((4*k*CD0)/(thrustA/W)^2))); %min q
Vmin = sqrt((2*qmin)/rho);                                           %min velocity from min q, [m/s]

%create buffer variable for later just ignore this
buffer = qmin/10;

%create velocity and q arrays from earlier min and max values for future calcs
vel = linspace(Vmin, Vmax, 100);
q = linspace(qmin, qmax, 100);

%Solving for n_struct line for r vs q graph
rN = 2.*q./(rho*g*sqrt((n^2)-1));

%Solving for CLMax curve for r vs q graph
rCL = 2.*q./(rho*g*sqrt((CLmax.*q.*S./W).^2 - 1)); 

%Solving for Tmax curve for r vs q graph
nTmax = sqrt((thrustA - CD0.*q.*S).*q.*S./(k*W^2));
rTmax = 2.*q./(rho*g*sqrt((nTmax.^2)-1));


figure(1)

hold on

plot(q, rN)
plot(q, rCL)
plot(q, rTmax)

title('r vs q')
xlabel('q [kg/(m*s^2)]')
ylabel('r')
xlim([qmin - buffer, qmax + buffer])
legend('n__struct', 'CLMax', 'Tmax')

hold off 


end
