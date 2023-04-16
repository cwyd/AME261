clc; clear; close all; 

%Let's conduct some trade studies for our new aircraft. 

%% Baseline Parameters %%

W0 = 1.82 * 10^5; 
W1 = 1.38 * 10^5; 
Wfuel = 4.41 * 10^4; %To always be kept fixed.
PmaxSL = 3.58 * 10^6; 
SFCp = 5.90 * 10^(-7);
CD0 = 0.0202; 
etaProp = 0.8; 
ev = 0.8;  
b = 26; 
c = 2.22; 
S = b*c; 
tOverC = 0.18; 
wingHeightOffGround = 4; 
CLMaxNoFlaps = 1.4; 
CLMaxWithFlaps = 2.2; 
etaBattery = 0.85; 
hCruise = 8000; 
VCruise = 180; 
fricCoeff = 0.04; %Runway
numEngines = 2;
propDiamterMeters = 3.96;


[~, rhoCruise] = standardatmosphere(hCruise); 

%Let's vary S and see what happens to all notable quantities. 

STestVec = linspace(0.5 * S, 1.4 * S, 130); 

W1forTestVec = W1 * STestVec / S; %Assume constant mass density inside the wing.

W0forTestVec = W1forTestVec + Wfuel; 

TOFLforS = zeros(0, length(STestVec));

LFLforS = zeros(0, length(STestVec));

XhVforS = zeros(0, length(STestVec));

EhVforS = zeros(0, length(STestVec));

RoCMaxForS = zeros(0, length(STestVec)); %The idea is that RoC_econ will go up if RoC_max goes up.

VCarsonForS = zeros(0, length(STestVec));

hCeilForS = zeros(0, length(STestVec));

Wfuel500nmiForS = zeros(0, length(STestVec));

for index = 1:length(STestVec)

    TOFLforS(index) = computeTakeoffFieldLength(W0forTestVec(index), 0, STestVec(index), CD0, b, ev, etaProp, CLMaxWithFlaps, wingHeightOffGround, PmaxSL, numEngines, propDiamterMeters);

    LFLforS(index) = computeLandingFieldLength(W1forTestVec(index), 0, CD0, ev, b^2 / STestVec(index), STestVec(index), b, CLMaxWithFlaps, fricCoeff, wingHeightOffGround);

    [~, RoCVec] = computeRateOfClimbPROPS(0, W0forTestVec(index), PmaxSL, 1, etaProp, CD0, ev, b^2 / STestVec(index), S, 0); 

    RoCMaxForS(index) = max(RoCVec); 

    VDmin = sqrt(2 * W0forTestVec(index) / (rhoCruise * S * sqrt(pi * ev * (b^2 / STestVec(index)) * CD0)));

    VCarsonForS(index) = 1.32 * VDmin; 

    XhVforS(index) = computeRangePROPS([hCruise, VCarsonForS(index)], W0forTestVec(index), W1forTestVec(index), SFCp, etaProp, ev, STestVec(index), b^2 / STestVec(index), CD0, 'constanthV');

    EhVforS(index) = computeEndurancePROPS([hCruise, VCarsonForS(index)], W0forTestVec(index), W1forTestVec(index), SFCp, etaProp, ev, STestVec(index), b^2 / STestVec(index), CD0, 'constanthV');

    hCeilForS(index) = flightenvelopePROPS(W0forTestVec(index), STestVec(index), ev, b^2 / STestVec(index), CD0, etaProp, PmaxSL, CLMaxNoFlaps, 1, 0); 

    Wfuel500nmiForS(index) = computeBlockFuelConsumedFor500nmiJourney([hCruise, VCarsonForS(index)], W0forTestVec(index), SFCp, etaProp, ev, STestVec(index), b^2 / STestVec(index), CD0, 'constanthV');
    
end 


bTestVec = linspace(0.5 * b , 1.4 * b, length(STestVec)); 

W1forTestVec = W1 * bTestVec / b; %Assume constant mass density inside the wing.

W0forTestVec = W1forTestVec + Wfuel; 

TOFLforb = zeros(0, length(STestVec));

LFLforb = zeros(0, length(STestVec));

XhVforb = zeros(0, length(STestVec));

EhVforb = zeros(0, length(STestVec));

RoCMaxForb = zeros(0, length(STestVec));

VCarsonForb = zeros(0, length(STestVec));

hCeilForb = zeros(0, length(STestVec));

Wfuel500nmiForb = zeros(0, length(STestVec));

for index = 1:length(STestVec)

    TOFLforb(index) = computeTakeoffFieldLength(W0forTestVec(index), 0, S, CD0, bTestVec(index), ev, etaProp, CLMaxWithFlaps, wingHeightOffGround, PmaxSL, numEngines, propDiamterMeters);

    LFLforb(index) = computeLandingFieldLength(W1forTestVec(index), 0, CD0, ev, bTestVec(index)^2 / S, S, bTestVec(index), CLMaxWithFlaps, fricCoeff, wingHeightOffGround);

    [~, RoCVec] = computeRateOfClimbPROPS(0, W0forTestVec(index), PmaxSL, 1, etaProp, CD0, ev, bTestVec(index)^2 / S, S, 0); 

    RoCMaxForb(index) = max(RoCVec); 

    VDmin = sqrt(2 * W0forTestVec(index) / (rhoCruise * S * sqrt(pi * ev * (bTestVec(index)^2 / S) * CD0)));

    VCarsonForb(index) = 1.32 * VDmin; 

    XhVforb(index) = computeRangePROPS([hCruise, VCarsonForb(index)], W0forTestVec(index), W1forTestVec(index), SFCp, etaProp, ev, S, bTestVec(index)^2 / S, CD0, 'constanthV');

    EhVforb(index) = computeEndurancePROPS([hCruise, VCarsonForb(index)], W0forTestVec(index), W1forTestVec(index), SFCp, etaProp, ev, STestVec(index), bTestVec(index)^2 / S, CD0, 'constanthV');
   
    hCeilForb(index) = flightenvelopePROPS(W0forTestVec(index), S, ev, bTestVec(index)^2 / S, CD0, etaProp, PmaxSL, CLMaxNoFlaps, 1, 0); 
    
    Wfuel500nmiForb(index) = computeBlockFuelConsumedFor500nmiJourney([hCruise, VCarsonForS(index)], W0forTestVec(index), SFCp, etaProp, ev, S, bTestVec(index)^2 / S, CD0, 'constanthV');

end 

%Finally adjust W_1 and keep the wing geometry constant. 

W1TestVec = linspace(0.5 * W1, 1.4 * W1, length(STestVec)); 

W0forTestVec = W1forTestVec + Wfuel; 

TOFLforW = zeros(0, length(STestVec));

LFLforW = zeros(0, length(STestVec));

XhVforW = zeros(0, length(STestVec));

EhVforW = zeros(0, length(STestVec));

RoCMaxForW = zeros(0, length(STestVec));

VCarsonForW = zeros(0, length(STestVec));

hCeilForW = zeros(0, length(STestVec));

Wfuel500nmiForW = zeros(0, length(STestVec));


for index = 1:length(STestVec)

    TOFLforW(index) = computeTakeoffFieldLength(W0forTestVec(index), 0, S, CD0, b, ev, etaProp, CLMaxWithFlaps, wingHeightOffGround, PmaxSL, numEngines, propDiamterMeters);

    LFLforW(index) = computeLandingFieldLength(W1TestVec(index), 0, CD0, ev, b^2 / S, S, b, CLMaxWithFlaps, fricCoeff, wingHeightOffGround);

  
    [~, RoCVec] = computeRateOfClimbPROPS(0, W0forTestVec(index), PmaxSL, 1, etaProp, CD0, ev, b^2 / S, S, 0); 

    RoCMaxForW(index) = max(RoCVec); 

    VDmin = sqrt(2 * W0forTestVec(index) / (rhoCruise * S * sqrt(pi * ev * (b^2 / S) * CD0)));

    VCarsonForW(index) = 1.32 * VDmin; 


    XhVforW(index) = computeRangePROPS([hCruise, VCarsonForW(index)], W0forTestVec(index), W1TestVec(index), SFCp, etaProp, ev, S, b^2 / S, CD0, 'constanthV');

    EhVforW(index) = computeEndurancePROPS([hCruise, VCarsonForW(index)], W0forTestVec(index), W1TestVec(index), SFCp, etaProp, ev, S, b^2 / S, CD0, 'constanthV');
    

    hCeilForW(index) = flightenvelopePROPS(W0forTestVec(index), S, ev, b^2 / S, CD0, etaProp, PmaxSL, CLMaxNoFlaps, 1, 0); 
    
    Wfuel500nmiForW(index) = computeBlockFuelConsumedFor500nmiJourney([hCruise, VCarsonForS(index)], W0forTestVec(index), SFCp, etaProp, ev, S, b^2 / STestVec(index), CD0, 'constanthV');

end 


figure(1)

plot(STestVec/S, TOFLforS, 'b')

title('TOFL vs. S, b, W_1')

xlabel('Parameter Percent Change')

ylabel('TOFL (m)')

hold on

plot(bTestVec/b, TOFLforb, 'r')


plot(W1TestVec/W1, TOFLforW, 'k')

%PLOT TOFL limit

TOFLLimit = ones(1, length(STestVec)) * 4500 * (1/3.28084);

plot(bTestVec/b, TOFLLimit, ':k', 'LineWidth', 1)

ylim([0, 2000])

legend('S (m^2)', 'b (m)', 'W_1 (N)', 'TOFL Limit')


figure(2)


plot(STestVec/S, LFLforS, 'b')

title('d_{G} vs. S, b, W_1')

xlabel('Parameter % Change')

ylabel('Landing Field Length (m)')

hold on

plot(bTestVec/b, LFLforb, 'r')

plot(W1TestVec/W1, LFLforW, 'k')

%Plot Landing Field Length limitation 

LFLLimit = ones(1, length(STestVec)) * 4500 * (1/3.28084);

plot(bTestVec/b, LFLLimit, ':k', 'LineWidth', 1)

legend('S (m^2)', 'b (m)', 'W_1 (N)', 'Landing Field length Limit')


figure(3)

plot(STestVec/S, XhVforS, 'b')

title('X_{h,V} vs. S, b, W_1')

xlabel('Parameter % Change')

ylabel('X_{h,V} (m)')

hold on 

plot(bTestVec/b, XhVforb, 'r')


plot(W1TestVec/W1, XhVforW, 'k')

%Plot X_hV limitation 

XhVLimit = 1000 * (1852) * ones(1, length(STestVec));

plot(bTestVec/b, XhVLimit, ':k', 'LineWidth', 1)

legend('S (m^2)', 'b (m)', 'W_1 (N)', 'Minimum Range Limit')


figure(4)

plot(STestVec/S, EhVforS, 'b')

title('E_{h,V} vs. S, b, W_1')

xlabel('Parameter % Change')

ylabel('E_{h,V} (s)')

hold on 

plot(bTestVec/b, EhVforb, 'r')

plot(W1TestVec/W1, EhVforW, 'k')

legend('S (m^2)', 'b (m)', 'W_1 (N)')


figure(5)

plot(STestVec/S, RoCMaxForS, 'b')

title('RoC_{max, SL} vs. S, b, W_1')

xlabel('Parameter % Change')

ylabel('RoC_{max, SL} (m/s)')

hold on  

plot(bTestVec/b, RoCMaxForb, 'r')


plot(W1TestVec/W1, RoCMaxForW, 'k')

%Plot RoC limitation (We need to climb to cruising altitude of 8530 m
%over a distance of 200 nmi.

thetaDesired = atan(8530 / (200 * 1852));

VcruiseDesired = 142; %m/s

RoCDesired = VcruiseDesired * sin(thetaDesired) * ones(1, length(STestVec)); 

plot(bTestVec/b, RoCDesired, ':k', 'LineWidth', 1)

legend('S (m^2)', 'b (m)', 'W_1 (N)', 'RoC Limit')


figure(6)

plot(STestVec/S, VCarsonForS, 'b')

title('V_{Carson} vs. S, b, W_1')

xlabel('Parameter % Change')

ylabel('V_{Carson} (m/s)')

hold on 

plot(bTestVec/b, VCarsonForb, 'r')


plot(W1TestVec/W1, VCarsonForW, 'k')

%Set cruise velocity limitation

VcruiseDesired = VcruiseDesired * ones(1, length(STestVec)); 

plot(bTestVec/b, VcruiseDesired, ':k', 'LineWidth', 1);

legend('S (m^2)', 'b (m)', 'W_1 (N)', 'V_{cruise} Limit')




figure(7)

plot(STestVec/S, hCeilForS, 'b')


title('h_{ceil} vs. S, b, W_1')

xlabel('Parameter % Change')

ylabel('h_{ceil} (m)')

hold on

plot(bTestVec/b, hCeilForb, 'r')

plot(W1TestVec/W1, hCeilForW, 'k')

%Set hCeil limitation

hCeilDesired = ones(1, length(STestVec)) * 9000; 

plot(bTestVec/b, hCeilDesired, ':k', 'LineWidth', 1)


legend('S (m^2)', 'b (m)', 'W_1 (N)', 'Ceiling Limit')


figure(8)

plot(STestVec/S, Wfuel500nmiForS, 'b')

hold on 

title('W_{fuel} Consumed Over 500 nmi vs. S, b, W_1')

xlabel('Parameter % Change')

ylabel('W_{fuel} Consumed Over 500 nmi (N)')

plot(bTestVec/b, Wfuel500nmiForb, 'r')

plot(W1TestVec/W1, Wfuel500nmiForW, 'k')

%Determine the desired value for W_fuel consumed over 500 nmi. 

Wfuel500nmiDesired = 0.8 * computeBlockFuelConsumedFor500nmiJourney([hCruise, VcruiseDesired], W0, SFCp, etaProp, ev, S, b^2 / STestVec(index), CD0, 'constanthV');

Wfuel500nmiDesired = Wfuel500nmiDesired * ones(1, length(STestVec));

plot(bTestVec/b, Wfuel500nmiDesired, ':k', 'LineWidth', 1)

legend('S (m^2)', 'b (m)', 'W_1 (N)', 'W_{fuel} for 500 nmi Desired Limit')



