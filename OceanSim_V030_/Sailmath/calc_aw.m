function [aws,awa,twa] = calc_aw(tws,twd, sog,cog)
% twd is the from direction 
% sog in m/s
% tws in m/s
% twa in radians
% leeway in radians
ux = tws*sin(twd) + sog*sin(cog);
uy = tws*cos(twd) + sog*cos(cog);

awa = unwrap_pi(atan2(ux,uy)-cog);% -heading; % Angle between heading and true wind taking sog/cog into account
aws = norm([ux,uy]);

twa =  unwrap_pi(twd-cog); % Angle between cog and true wind


%twa = rad2deg(twa)
%awa = rad2deg(awa)
%aws = aws

