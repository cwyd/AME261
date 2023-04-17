%   =======================================================================
%   roughWeights.m
%   =======================================================================
%   PARENT SCRIPT
%
%   PROGRAM INFORMATION
%   Author:     Gabriel Calub
%   Date:       03/26/2023
%   Version:    4.4
%   References: 1.
%               2.
%
%   Roughly approximates the weight of the aircraft before fully calculated
%   by VSPAero
%
%   Documentation: https://docs.google.com/document/d/1s04e2THURuhZ66hpbRJmpVLHB_bnvNXdhlUeKBF3msU/edit
%
clc; clear; close all;

%% USER INPUTS

wing_density = 1500;    % Wing weight/centroid calculation
wing_volume = 1;
wing_x = 1;

h_stab_density = 1500;  % Horizontal Stabilizer weight/centroid
h_stab_volume = 1;
h_stab_x = 1;

v_stab_density = 1500;  % Vertical Stabilizer weight/centroid
v_stab_volume = 1;
v_stab_x = 1;

fuse_density = 1500;    % Fuselage weight/centroid
fuse_volume = 22*(pi*1.385^2-pi*1.285^2);
fuse_x = 1;

fuel_weight = 1;
fuel_x = 1;

battery_weight = 1;
battery_x = 1;

pass_weight = 80*9.81;     % Passenger weight/centroid
pass_x      = 1;

engine_weight = 1;   % Engine weight/centroid
engine_x      = 1;

cargo_weight = 1; % Cargo weight/centroid
cargo_x      = 1;

%% CALCULATIONS
w_wing = wing_density*wing_volume;
w_htail = h_stab_density*h_stab_volume;
w_vtail = v_stab_density*v_stab_volume;
w_fuse = fuse_density*fuse_volume;
w_pass = pass_weight*50;

w_total = w_wing + w_htail + w_vtail + w_fuse + w_pass + engine_weight + fuel_weight + battery_weight;

centroid = 1;

%% OUTPUTS
fprintf("======== WEIGHT BUILDUP ======== \n")
fprintf("Wing:                  %0.2f lbs \n", w_wing)
fprintf("Horizontal Tail:       %0.2f lbs \n", w_htail)
fprintf("Vertical Tail:         %0.2f lbs \n", w_vtail)
fprintf("Fuselage:              %0.2f lbs \n", w_fuse)
fprintf("Installed Engines:     %0.2f lbs \n", engine_weight)
fprintf("Fuel Systems:          %0.2f lbs \n", fuel_weight)
fprintf("Battery:               %0.2f lbs \n", battery_weight)
fprintf("Passengers:            %0.2f lbs \n", w_pass)
fprintf("=================================== \n")
fprintf("TOTAL WEIGHT:          %0.2f lbs \n", w_total)
fprintf("CENTROID:              %0.2f m   \n", centroid)