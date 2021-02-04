function [cog, sog] = calc_SogCog(yaw,leeway,ux,uv)

sog     = norm([ux,uv]);              % [m/s] 
cog     = unwrap_2pi(yaw-leeway);     % [rad] 0-2pi




