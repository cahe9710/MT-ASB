function sails = preProcessor(sails,environment)
%--------------------------------------------------------------------------
% sails = preProcessor(sails,environment)
% 
% Function mainVLM is coordinating the running of the VLM problem
%
% -------- INPUT --------
%   sails       - Structure containing outline of the sail, sheet angle,
%                 twist, mirrored, discretisation, etc.
%
%-------- OUTPUT --------
%   sails       - Updated structure containg sail geometry, lattices, etc.
%   results     - Structure containing forces, pressures, etc.
%
%--------------------------------------------------------------------------

% Generate mesh and lattices
for is = 1:length(sails)
% 	%if isfield(sails(is),'panels') == 0; % generate panels if not already done
% 		[sails(is).panels]  = makeWing(sails(is));
%     %end
    
  	sails(is).lattice = generateLattice(sails(is).panels,sails(is).wakeType,sails(is).wakeLength,environment); % generate lattice
    
% 	sails(is).Nxw     = 1; % assign one spanwise set of wake panels
    
    sails(is).liftDir = (generateWind(environment.zRef,environment)'*[cos(-pi/2),sin(-pi/2),0;-sin(-pi/2),cos(-pi/2),0;0,0,1])'; % direction in wich lift is calculated
    sails(is).dragDir = generateWind(environment.zRef,environment); % direction in wich drag is calculated
    
    % Normalise lift and drag directions
    sails(is).liftDir = sails(is).liftDir/norm(sails(is).liftDir);
    sails(is).dragDir = sails(is).dragDir/norm(sails(is).dragDir);
    
    % Calculate sail area
    sails(is).A = 0;
    for iz = 1:sails(is).Nz
        for ix = 1:sails(is).Nx
            sails(is).A = sails(is).A + sails(is).lattice(ix,iz).a;
        end
    end
end
