function [F  M]   = calc_seaMargin(FH_hull);                 % Add fouling drag
global settings ship

F = [settings.seaMargin*FH_hull(1); 0; 0];
M = [0;0;0];

