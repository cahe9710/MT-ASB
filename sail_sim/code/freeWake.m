function sails = freeWake(sails,mir,environment)
%--------------------------------------------------------------------------
% sails = freeWake(sails,mir)
% 
% Function freeWake calculates the lattice for a force free wake by a
% time-stepping method.
%
% -------- INPUT --------
%   sails       - Structure containing lattices, vortices strength, etc
%   mir         - =1 if mirrored at z=0 (e.g. mirrored geometry or ground
%                 effect). Else =0
%
%-------- OUTPUT --------
%   sails     - sail structure with updated lattice
%
%--------------------------------------------------------------------------

tic;
iter = 0;
gVec = 0;
residual = 1;

% Wake relaxation loop
while iter < 30 && residual > 5e-4; % loop until convergence
    sailsPrev = sails;
    % Align wake with local velocities
	for is = 1:length(sails)
        wakeStep = sails(is).wakeStep;
        if strcmp(sails(is).wakeType,'free');
            % Loop through wake
            for ix = sails(is).Nx:(sails(is).Nx+sails(is).Nxw) 
                if ix > sails(is).Nx+1; wakeStep = wakeStep*1.1; end % increase wakeStep by 10% each step downstream
                
                for iz = 1:sails(is).Nz                         
                    RcoreWake = max([norm(sails(is).lattice(ix,iz).ne - sails(is).lattice(ix,iz).se),...
                                     norm(sails(is).lattice(ix,iz).sw - sails(is).lattice(ix,iz).se),...
                                     norm(sails(is).lattice(ix,iz).nw - sails(is).lattice(ix,iz).sw),...
                                     norm(sails(is).lattice(ix,iz).nw - sails(is).lattice(ix,iz).ne)])*sails(is).kr;

                    p = sails(is).lattice(ix,iz).se; % start at sw point
                    q = generateWind(p(3),environment) + calcInduced(p,sailsPrev,mir,RcoreWake); % velocity at sw point
                    
                    % Assign new corners in lattice
                    sails(is).lattice(ix+1,iz).se = p + q*wakeStep; % step in direction of q
                    sails(is).lattice(ix+1,iz).sw = sails(is).lattice(ix,iz).se;
                    if iz ~= 1; 
                        sails(is).lattice(ix+1,iz-1).nw = sails(is).lattice(ix+1,iz).sw; % set next set of wake panels
                        sails(is).lattice(ix+1,iz-1).ne = sails(is).lattice(ix+1,iz).se; % set next set of wake panels
                    end
                    if iz == sails(is).Nz
                        p = sails(is).lattice(ix,iz).ne; % start at ne point
                        q = generateWind(p(3),environment) + calcInduced(p,sailsPrev,mir,RcoreWake); % velocity at ne point
                        sails(is).lattice(ix+1,iz).ne = p + q*wakeStep;% step in direction of q
                        sails(is).lattice(ix+1,iz).nw = sails(is).lattice(ix,iz).ne;
                    end
                end
            end
        end
	end
	% Define properties for the lattice
	for isw = 1:length(sails);
        if strcmp(sails(isw).wakeType,'free');
            sails(isw).Nxw = sails(isw).Nxw + 1;
            for ixw = (sails(isw).Nx+sails(isw).Nxw):-1:(sails(isw).Nx+1)                 
                for izw = 1:sails(isw).Nz
                    % Arrange vortex strengths                        
                    sails(isw).lattice(ixw,izw).g = sails(isw).lattice(ixw-1,izw).g;
                    
                    % Calculate control point, centre of aerodynamics, normal and area of lattice
                    [sails(isw).lattice(ixw,izw).c, sails(isw).lattice(ixw,izw).ca, sails(isw).lattice(ixw,izw).n, sails(isw).lattice(ixw,izw).a] = ...
                            calcLatticeSpec(sails(isw).lattice(ixw,izw).nw, sails(isw).lattice(ixw,izw).ne, sails(isw).lattice(ixw,izw).se, sails(isw).lattice(ixw,izw).sw);
                end
            end
        end
	end
    sails = solver(sails,mir,environment);   % solve for vortex strengths on sail
    gVecPrev = gVec;
    gVec = gamaVec(sails); % generate the vortex strengths in a vector
    iter = iter + 1
	residual = norm(gVec-gVecPrev)/norm(gVecPrev);
    residualVec(iter) = residual; % save residuals in vector
end

if iter >= 30;
    disp('Wake relaxation did not converge!')
end

figure(43); plot(1:iter,residualVec); grid on    
time = toc;
fprintf('Time to solve wake realxation routine: %2.2f min\n',time/60)