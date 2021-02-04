%-----------------------------------------------------------------------
% 
% 
%
%-----------------------------------------------------------------------
clear;format compact;
[~, username] = system('id -F');username=username(1:end-1);
fprintf('\n\n-------------------------------------- \n');
fprintf('Oceanbird Maneuver Simulation.\n%s, %s.\n',username,datestr(now));

%addpath(genpath('/Users/jakob/Desktop/OceanSim_V029')); % Every user needs to edit this path

addpath(genpath('..')); % Every user needs to edit this path

global settings data
settings.g               = 9.81;  % [m/s2]
settings.rho_air         = 1.225; % [kg/m3]
settings.rho_water       = 1024 ; % [kg/m3]

%OceanSim_Setup_200m; % Oceanbird default setup
OceanSim_Setup_7m;  % 7m Christiane default setup

%-----------------------------------------------------------------------
% Override the standard settings here if you like
% Nt = 3600;
%-----------------------------------------------------------------------

OceanSim_Integrate;          % Do the actual integration
OceanSim_Plots;              % Standard plotting
% runme_OceanVis(truth_,rigs); % The 3D visualization
