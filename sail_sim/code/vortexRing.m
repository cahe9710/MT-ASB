function q = vortexRing(p,nw,ne,se,sw,g,mir,Rcore)
%--------------------------------------------------------------------------
% q = vortexRing(p,nw,ne,se,sw,g,mir,Rcore)
% 
% Function vortexRing calculates the induced velocity from a vortex ring in
% point p
%
% -------- INPUT --------
%   p           - Control point position [x,y,z]'
%   nw,ne,sw,se - Corners of vortex ring [x,y,z]'
%   g           - Vortex strenght, equal for all line vortices in a vortex
%                 ring
%   mir         - =1 if mirrored at z = 0 (e.g. mirrored geometry or ground
%                 effect). Else =0
%   Rcore       - Fictive "vortex core size"
%
% -------- OUTPUT --------
%   q           - velocity induced at point p due to vortex ring [u,v,w]'
%
% ------------------------
%   Definition of vortex ring:
%                       nw      2     ne
%                         o----------o
%                         |          |
%                       1 |          | 3
%                         |          |
%                         o----------o
%                       sw      4     se
%--------------------------------------------------------------------------

% Calculates induced veclocity from each vortex line
q1 = vortexLine(p,sw,nw,g,mir,Rcore);
q2 = vortexLine(p,nw,ne,g,mir,Rcore);
q3 = vortexLine(p,ne,se,g,mir,Rcore);
q4 = vortexLine(p,se,sw,g,mir,Rcore);

% Sum induced velocity from each vortex line
q = q1 + q2 + q3 + q4;