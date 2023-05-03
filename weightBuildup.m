%   =======================================================================
% 	weightBuildup.m
%   =======================================================================
%   PARENT SCRIPT
%
%   PROGRAM INFORMATION
%   Author:     Gabriel Calub
%   Date:       04/10/2023
%   Version:    1.0
%   References: 1.
%               2.
%
%   Weight study

% https://learn-us-east-1-prod-fleet02-xythos.content.blackboardcdn.com/5fd94affdac6c/3929848?X-Blackboard-S3-Bucket=learn-us-east-1-prod-fleet01-xythos&X-Blackboard-Expiration=1681203600000&X-Blackboard-Signature=GkQfHzOTSaAlN4goqOFfPpRB%2BtqZNb50Uqc%2BKaKHpu4%3D&X-Blackboard-Client-Id=100775&X-Blackboard-S3-Region=us-east-1&response-cache-control=private%2C%20max-age%3D21600&response-content-disposition=inline%3B%20filename%2A%3DUTF-8%27%27Raymer%2520-%2520Aircraft%2520Design%2520-%2520A%2520Conceptual%2520Approach.pdf&response-content-type=application%2Fpdf&X-Amz-Security-Token=IQoJb3JpZ2luX2VjELT%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJHMEUCIQDofnj7%2BXTth1muhVIo9K1gpI2NHxOAjOvRh5jDUIU%2FFwIgELwlRrQL5NA46I5OIEvP08VsIw0rSgYZGGkwIdBnBEAqvQUInf%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARADGgw2MzU1Njc5MjQxODMiDKk7zwqG5hWpKl7j0iqRBdDJr%2F04gx8iA9ExVo0mqK%2BO6hh6Ws1adqMQJ4yRBHKfGxYOWVp9FM%2FjrzxLpThQ6v1xqjZASicEwVqka9sEkZ75dsuM92SwVBX6bOjb5lbxwCWTFg7IbuqookVZbK%2FtWi8d5%2FqgHooUpFY9hZE2twihc3O1xA9n2OqgkYzg5gXmDFG5Wod2ZmWU%2BDfCer3A8o5gZTH3uzkY0jySvxFoX%2FHqzJtToFaanbY5VdATwI3qHn%2FYamFJYiydRbSq2dQ%2FkqNQIzvlGf9%2Bn3dK97PUUbGMH2V5q7qibI4d0EaeTeUBZXwN8IUfs8iw55U9KnIUEMAU4rcTjkYQPzJf%2FcEDx0KDoQqrgVdlqiVZBV6AbsrUMhJwuHHaowREWN1wUNOY3WSuzZm2H18m16UhzpRewwVoHr25wWFVdIdWkzcIs5Rz0gTyZqZKXDMZ02BA1k2vtHGpCPxwJ0%2BYQ9Lq0mDC0ODJxDbe0Q3n7ZLgwdW9JX0JwAuDopiZ5271AEIbPGCPjLm9m1%2BRFe%2BrQ1vEiVdzMu9KYf7N%2FgLmFXekZJVnC7lk17lEWQv4kImHHuYl7m4d1V4Z0XtJnxzFf0VVBd0x1ggg1TH0gonaDHW0S0oFFMcLo%2Ff2Y9ziHjMQI%2Bbu20uGuJI68MkhvCroTYQ0C3XTBBYv5O73WE5u6NfKgbRxxnCH4gW8DPFaxBkKlp5EvNaOj8o8VDI8siurYOXpHWmcoG17ai63AF3C2BMZryhQWn8vEx8C8XFNJoY7t9ukDR0%2FM1Sx8dlTSrAUwond1H%2B6Bg0xz%2BARQr8%2FD9o3cSi10JtpYDcoDuzepzbWf2Muurm%2BS4qT08PLNgEKf0n6rGbAHX5vZup8zonrgAF4HMDkbqvjtzDytdOhBjqxAQwd%2Br0e2grEJ1%2FEXNi13C4wJIS0g0tRGwN2m%2BC0c4PxVOXv2Y14gpRj3cwkcrSba1YJr0GVaneeeZWDv995hNh2%2BmMZpjR4%2Bv%2F9z%2FoIbFRjlRXXXyA203R%2BgvS%2FWxojoR1EemXNCxrZTHPOeAtKfXbUw01lhgyr9TzUKER8pAWCTVI8MmhRJYN2Hxzhz9LxEcfvbply7TIEGMQtQ3cx00cL5Lfa77EuLP1Agp0kdVI3Ow%3D%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230411T030000Z&X-Amz-SignedHeaders=host&X-Amz-Expires=21600&X-Amz-Credential=ASIAZH6WM4PLQKY5IZ75%2F20230411%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=6e899886eefdfb5fb2a49b698a60c8893736d482dfa33a67a191871f14d157f2
% Page 405, General-Aviation Weights
clc; clear; close all

%% USER INPUTS
A = 13.5;          % Aspect Ratio
B_w = 98.42;        % Wing span [ft]
H_t = 14.17;        % Horizontal tail height above fuselage [ft]
H_v = 14.17;        % Vertical tail height above fuselage [ft]
L = 73.8;          % Fuselage structural length [ft]
L_D = 10;        % Duct length [ft]
L_m = 1;        % Length of main landing gear [ft]
L_n = 1;        % Nose gear length [in]
L_t = 1;        % Tail length [ft]
Lambda = 0;     % Main wing sweep at 25% MAC
Lambda_ht = 0;  % Horizontal tail sweep
Lambda_vt = 0;  % Vertical tail sweep
lambda_vt = 0;  % ?
M = 0.4;          % Mach Number
N_en = 8;       % Number of engines
N_l = 1.8;        % Ultimate landing load factor
N_p = 50;        % Number of personnel onboard (crew and passengers)
N_t = 2;        % Number of fuel tanks
N_z = 1;        % Ultimate load factor; = 1.5*limit load factor
S_f = 100;        % Fuselage wetted area [ft^2]
S_ht = 20;       % Horizontal tail area [ft^2]
S_vt = 20;       % Vertical tail area [ft^2]
S_w = 50;        % Trapezoidal wing area [ft^2]
t_c = 1;
V_i = 25;        % Integral tanks volume [gal]
V_pr = 20;       % Volume of pressurized section [gal]
V_t = 100;        % Total fuel volume [gal]
W_dg = 10000;       % Design gross weight [lb]
W_en = 100;       % Engine weight, each, [lb]
W_fw = 100;       % Weight of fuel in wing [lb]
W_l = 2000;        % Landing design gross weight [lb]
W_uav = 100;      % Uninstalled avionics weight [lb]
lambda = 1;     
lambda_h = 1;
P_delta = 8;    % Cabin pressure differential [psi]
q = 50;          % Dynamic pressure at cruise


%% CALCULATIONS
W_press = (11.9 + V_pr*P_delta)^0.271;    % Weight penalty due to pressurization, P_delta is cabin pressure, V_pr is volume of pressurized section
W_wing = 0.036*S_w^0.758*W_fw^0.0035*(A/cosd(Lambda)^2)^0.6*q^0.006*lambda^0.04*(100*t_c/cosd(Lambda))^(-0.3)*(N_z*W_dg)^0.49;
W_htail = 0.016*(N_z*W_dg)^0.414*q^0.168*S_ht*0.896*(100*t_c/cosd(Lambda))^(-0.12)*(A/cosd(Lambda_ht)^2)^0.043*lambda_h^(-0.02);
W_vtail = 0.073*(1+0.2*H_t/H_v)*(N_z*W_dg)^0.376*q^0.122*S_vt^0.873*(100*t_c/cosd(Lambda_vt))^(-0.49)*(A/cos(Lambda_vt)^2)^0.357*lambda_vt^0.039;
W_fuselage = 0.052*S_f^1.086*(N_z*W_dg)^0.177*L_t^(-0.051)*L_D^(-0.072)*q^0.241+W_press;
W_mlg = 0.095*(N_l*W_l)^0.768*(L_m/12)^0.409;
W_nlg = 0.125*(N_l*W_l)^0.566*(L_n/12)^0.845;
W_ieT = 2.575*W_en^0.922*N_en;
W_fuelsystem = 2.49*V_t^0.726*(1/(1+V_i/V_t))^0.363*N_t^0.242*N_en^0.157;
W_flightcontrols = 0.053*L^1.53*B_w^0.371*(N_z*W_dg*10^(-4))^0.8;
W_hydraulics = 0.001*W_dg;
W_avionics = 2.117*W_uav^0.933;
W_electrical = 12.57*(W_fuelsystem + W_avionics)^0.51;
W_ac = 0.265*W_dg^0.52*N_p^0.68*W_avionics^0.17*M^0.08;
W_furnishings = 0.0582*W_dg-65;
W_total = W_wing + W_htail + W_vtail + W_fuselage + W_mlg + W_nlg + W_ieT + W_fuelsystem + W_flightcontrols + W_hydraulics + W_avionics + W_electrical + W_ac + W_furnishings;

%% OUTPUTS

fprintf("======== WEIGHT BUILDUP ======== \n")
fprintf("Wing:                  %0.2f lbs \n", W_wing)
fprintf("Horizontal Tail:       %0.2f lbs \n", W_htail)
fprintf("Vertical Tail:         %0.2f lbs \n", W_vtail)
fprintf("Fuselage:              %0.2f lbs \n", W_fuselage)
fprintf("Main Landing Gear:     %0.2f lbs \n", W_mlg)
fprintf("Nose Landing Gear:     %0.2f lbs \n", W_nlg)
fprintf("Installed Engine:      %0.2f lbs \n", W_ieT)
fprintf("Fuel Systems:          %0.2f lbs \n", W_fuelsystem)
fprintf("Flight Controls:       %0.2f lbs \n", W_flightcontrols)
fprintf("Hydraulics:            %0.2f lbs \n", W_hydraulics)
fprintf("Avionics:              %0.2f lbs \n", W_avionics)
fprintf("Electrical:            %0.2f lbs \n", W_electrical)
fprintf("Air Conditioning:      %0.2f lbs \n", W_ac)
fprintf("Furnishings:           %0.2f lbs \n", W_furnishings)
fprintf("=================================== \n")
fprintf("TOTAL WEIGHT:          %0.2f lbs \n", W_total)