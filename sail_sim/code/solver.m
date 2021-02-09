function sails = solver(sails,mir,environment)
%--------------------------------------------------------------------------
% sails = solver(sails,mir)
% 
% Function solver sets up the linear systems of equations and solves the
% vortex strengts of each vortex ring
%
% -------- INPUT --------
%   sails       - Structure containing outline of the sail, sheet angle,
%                 twist, mirrored, discretisation, etc.
%   mir         - =1 if mirrored at z = 0 (e.g. mirrored geometry or ground
%                 effect). Else =0
%   Rcore       - Fictive "vortex core size"
%
%-------- OUTPUT --------
%   sails       - Structure containg sail geometry, lattices, etc. with
%                 updated vortex strengths
%
%--------------------------------------------------------------------------

% Preallocate matrices
Alength = 0;
for is = 1:length(sails)
    Alength = Alength + sails(is).Nx*sails(is).Nz;
end
A       = zeros(Alength); % Influence matrix preallocation
RHS     = zeros(1,Alength); % Normal velocities at control points due to freestream

% Loop through sails to generate influence matrix A and velocity vector NV
k       = 0; % counter 
for is = 1:length(sails) % sails loop
    for ix = 1:sails(is).Nx % chordwise loop, only on sails' surface
        for iz = 1:sails(is).Nz % spanwise loop
            k  = k  + 1;
            % Calculate influence matrix for half of wing
            [A(k,:), qWake] = calcA(sails(is).lattice(ix,iz),sails,mir);
            
            wind  = generateWind(sails(is).lattice(ix,iz).c(3),environment);  
            RHS(k) = -wind'*sails(is).lattice(ix,iz).n - qWake'*sails(is).lattice(ix,iz).n; % normal velocity at control points due to freestream
        end
    end
end

% Solve system of linear equations
GAMA = A\RHS';

% Sort vortex strengths into lattice format for each sail
k = 0;
for is = 1:length(sails)
    for ix = 1:(sails(is).Nx + 1) % loop through sail and first spanwise set of wake elements
        for iz = 1:sails(is).Nz    
            if ix <= sails(is).Nx;
                k = k + 1;
                sails(is).lattice(ix,iz).g = GAMA(k);
            else    
                sails(is).lattice(ix,iz).g = GAMA(k-(sails(is).Nz-iz)); 
            end
        end
    end
end