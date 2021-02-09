function [c ca n a] = calcLatticeSpec(nw, ne, se, sw)
%--------------------------------------------------------------------------
% [c ca n a] = calcLatticeSpec(nw, ne, se, sw)
% 
% Function calcLatticeSpec calculates control point, center of pressure,
% normal and area of vortex ring defined by nw, ne, se and sw
%
% -------- INPUT --------
%   nw,ne,se,sw - corners of vortex ring
%
%   Definition of vortex ring:
%                       nw            ne
%                         o----------o
%                         |          |
%                         |          | 
%                         |          |
%                         o----------o
%                       sw            se
%
% -------- OUTPUT --------
%   c           - control point coordinates
%   ca          - center of aerodynamics (center of pressure) coordinates
%   n           - normal of vortex ring
%   a           - area of vortex ring
%
%--------------------------------------------------------------------------
% Calculate control point location, centre of aerodynamic, panel areas and normals
c  = (sw + nw + se + ne)./4; % control point in middle of ring vortex
ca = (nw + sw)/2; % center of aerodynamics (centre of pressure)
n  = cross(ne-sw, se-nw)./norm(cross(ne-sw, se-nw)); % normal of ring vortex
a  = norm(cross(ne-sw, se-nw))/2; % area of vortex ring   