function q = calcInduced(p,sails,mir,Rcore)
%--------------------------------------------------------------------------
% q = calcInduced(p,sails,mir,Rcore)
% 
% Function calcInduced calculates induced velocity due to other vortices 
% in point p
%
% -------- INPUT --------
%   p         - Point where induced velocity is calculated
%   sails     - Structure containing lattices, vortices strength, etc
%   mir       - =1 if mirror image at z = 0 (in calculations)
%   Rcore     - Fictive "vortex core size"
%
%-------- OUTPUT --------
%   q         - Induced velocity at point p
%
%--------------------------------------------------------------------------

% Preallocating memory
q   = zeros(3,1);
% --------------------
k   = 0;
for is = 1:length(sails) % sails loop
    for ix = 1:(sails(is).Nx+sails(is).Nxw) % chordwise loop, both surface and wake
        for iz = 1:sails(is).Nz % spanwise loop
            k = k + 1; % counter

            % Caclulate induced velocity from vortex ring of panel (ix,iz)
            q0 = vortexRing(p,sails(is).lattice(ix,iz).nw,sails(is).lattice(ix,iz).ne,sails(is).lattice(ix,iz).se,sails(is).lattice(ix,iz).sw,sails(is).lattice(ix,iz).g,0,Rcore);

            % Add influence of other side of wing, i.e. mirror in the span in z-direction.
            if mir == 1;
                q0mir = vortexRing(p,sails(is).lattice(ix,iz).nw,sails(is).lattice(ix,iz).ne,sails(is).lattice(ix,iz).se,sails(is).lattice(ix,iz).sw,sails(is).lattice(ix,iz).g,mir,Rcore);
                q0 = [q0(1)+q0mir(1) q0(2)+q0mir(2) q0(3)-q0mir(3)]';
            end
            
            q = q + q0; % sum all induced velocities
        end
    end
end