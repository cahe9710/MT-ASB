function [A, qWake] = calcA(panel,sails,mir)
%--------------------------------------------------------------------------
% A = calcA(panel,sails,mir)
% 
% Function calcA set up one row in the influence matrix A.
%
% -------- INPUT --------
%   panel       - Panel for wich influence coefficients are calculated
%   sails       - Structure containing outline of the sail, sheet angle,
%                 twist, mirrored, discretisation, etc.
%   mir         - =1 if mirrored at z = 0 (e.g. mirrored geometry or ground
%                 effect). Else =0
%
%-------- OUTPUT --------
%   A           - One row in the influence matrix A
%   qWake       - Induced velocity by wake elements. Used only with wake
%                 relaxation routine.
%
%--------------------------------------------------------------------------

% Preallocating memory
Alength = 0;
for is = 1:length(sails)
    Alength = Alength + sails(is).Nx*sails(is).Nz;
end
A     = zeros(1,Alength);
qWake = zeros(3,1);
k     = 0;

% Loop through and calculate influence from each vortex ring in panel.c
for is = 1:length(sails) % sails loop
    for ix = 1:(sails(is).Nx + sails(is).Nxw)% chordwise loop
        for iz = 1:sails(is).Nz % spanwise loop
            
            % Assign vortex strengths
            if ix <= sails(is).Nx + 1
                g = 1; % assign vortex strength = 1 on surface and first wake element
            else
                g = sails(is).lattice(ix,iz).g;
            end % keep vortex strengths in wake

            % Calculate influencing velocity from vortex ring (is,ix,iz)    
            q0 = vortexRing(panel.c,sails(is).lattice(ix,iz).nw,sails(is).lattice(ix,iz).ne,sails(is).lattice(ix,iz).se,sails(is).lattice(ix,iz).sw,g,0,sails(is).Rcore);

            % Add influence of mirror-image in the span(z) direction.
            if mir == 1;
                q0mir = vortexRing(panel.c,sails(is).lattice(ix,iz).nw,sails(is).lattice(ix,iz).ne,sails(is).lattice(ix,iz).se,sails(is).lattice(ix,iz).sw,g,mir,sails(is).Rcore);
                q0    = [q0(1)+q0mir(1) q0(2)+q0mir(2) q0(3)-q0mir(3)]';
            end
            
            % Calculate influence coefficient a(ix,iz)
            A1 = q0'*panel.n; % velocity in normal direction due to vortices at current control point
            
            if ix <= sails(is).Nx % on sail surface
                k    = k + 1;
                A(k) = A1;
            elseif ix == sails(is).Nx + 1 % add influence from first wake panel to panel at trailing edge
                A(k-(sails(is).Nz-iz)) = A(k-(sails(is).Nz-iz)) + A1;
            else % sum induced velocity from wake
                qWake = qWake + q0;
            end         
        end
    end
end