function [tws,twd] = calc_trueWind_2(yaw,sog,cog,aws,awa)

% https://www.bwsailing.com/cc/2017/05/calculating-the-true-wind-and-why-it-matters/

awd = yaw + awa;
u = sog * sin(cog) - aws * sin(awd);
v = sog * cos(cog) - aws * cos(awd);

tws = sqrt( u^2 + v^2 );
twd = atan2 (u,v)+pi;  % or u,v

twd = unwrap_2pi(twd);

            