
function  q = vortexLine(c,p1,p2,g,mir,Rcore)
%--------------------------------------------------------------------------
% q = vortexLine(c,p1,p2,g,mir,Rcore)
% 
% Function vortexLine calculates the induced velocity from a vortex line in
% point p
%
% -------- INPUT --------
%   c           - Control point position
%   p1, p2      - Position of vortex line ends
%   g           - Vortex strenght
%   mir         - =1 if mirrored at z = 0 (e.g. mirrored geometry or ground
%                 effect). Else =0
%   Rcore       - Fictive "vortex core size"
%
% -------- OUTPUT --------
%   q           - velocity induced at control point c due to vortex 
%                 element p2-p1
% ------------------------
%   Definition of vortex line:
%               p1               p2
%               o--------------->o
%
%--------------------------------------------------------------------------

if mir == 1
    c(3)  = -c(3);
end
R0 = p2 - p1;
R1 = c - p1; 
R2 = c - p2;

if norm(R1) < Rcore || norm(R2) < Rcore || norm(cross(R1,R2))^2 < Rcore
    q = [0 0 0]';
else    
 	q = g/(4*pi)*cross(R1,R2)/(norm(cross(R1,R2))^2)*(R0'*(R1/norm(R1)-R2/norm(R2)));
end
