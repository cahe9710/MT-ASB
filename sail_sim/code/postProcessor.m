function results = postProcessor(sails,mir,environment)
%--------------------------------------------------------------------------
% results = postProcessing(sails,mir)
% 
% Function postProcessing calculates the forces and pressures acting on the
% sails
%
% -------- INPUT --------
%   sails       - Structure containing lattices, vortices strength, etc
%   mir         - =1 if mirrored at z = 0 (e.g. mirrored geometry or ground
%                 effect). Else =0
%
%-------- OUTPUT --------
%   results     - Structure containing forces, pressures, etc.
%
%--------------------------------------------------------------------------

global rho tws

k = 0;
F = 0; FX = 0; FY = 0; FZ=0; L = 0; D = 0; A = 0;
for is = 1:length(sails)
    results(is).f = 0;
    
    for ix = 1:sails(is).Nx
        for iz = 1:sails(is).Nz
            k = k + 1;
            if ix == 1 % At leading edge
                gij = sails(is).lattice(ix,iz).g; % Katz & Plotkin eq. 12.25a
            else % The rest of the sail
                gij = sails(is).lattice(ix,iz).g-sails(is).lattice(ix-1,iz).g; % Katz & Plotkin eq. 12.25
            end
            wind     = generateWind(sails(is).lattice(ix,iz).ca(3),environment);
            
            % vec is vector of the leading bound vortex in the vortex ring
            vec     = sails(is).lattice(ix,iz).nw - sails(is).lattice(ix,iz).sw;
            vecUnit = vec/norm(vec);
            
            % Calculate force f on panel          
            qInd    = calcInduced(sails(is).lattice(ix,iz).ca,sails,mir,sails(is).Rcore); % induced velocity from vortex lattice
            q       = wind + qInd; % local velocity at center of pressure of panel (ix,iz)
            sails(is).lattice(ix,iz).q   = q; % store local velocity at center of pressure
            results(is).lattice(ix,iz).f = rho*cross(q,gij*vecUnit)*norm(vec); % Kutta-Joukowski condition
            results(is).f                = results(is).f + results(is).lattice(ix,iz).f; % add local force to total force on sail
                                       
            % Pressure and pressure coefficient on panel
            results(is).lattice(ix,iz).p  = results(is).lattice(ix,iz).f'*sails(is).lattice(ix,iz).n/sails(is).lattice(ix,iz).a; % calc panel pressure
            results(is).lattice(ix,iz).p2 = rho*(tws^2-norm(q)^2)/2;
            results(is).lattice(ix,iz).cp = results(is).lattice(ix,iz).p/(.5*rho*tws^2); % calc panel pressure coefficient            
       end
    end

    % Thrust force
    fx             = results(is).f'*[1 0 0]';       % thrust force on sail is
    results(is).fx = fx*[1 0 0]';                   % thrust force vector on sail is
    results(is).cx = fx/(0.5*rho*tws^2*sails(is).A); % thrust force coefficient of sail is
    FX             = FX + fx;                        % add to thrust force on all sails

    % Heeling force
    fy             = results(is).f'*[0 1 0]';       % heeling force on sail is
    results(is).fy = fy*[0 1 0]';                   % heeling force vector on sail is
    results(is).cy = fy/(0.5*rho*tws^2*sails(is).A); % heeling force coefficient of sail is
    FY             = FY + fy;                        % add to heeling force on all sails
    
    % Upwards force
    fz             = results(is).f'*[0 0 1]';       % heeling force on sail is
    results(is).fz = fz*[0 0 1]';                   % heeling force vector on sail is
    results(is).cz = fz/(0.5*rho*tws^2*sails(is).A); % heeling force coefficient of sail is
    FZ             = FZ + fz;                        % add to heeling force on all sails
    
    % Drag paralell to wind
    d              = results(is).f'*sails(is).dragDir; % drag force on sail is
    results(is).d  = d*sails(is).dragDir;              % drag force vector on sail is
    results(is).cd = d/(0.5*rho*tws^2*sails(is).A);    % drag coefficient of sail is
    D              = D  + d;                           % add to drag force on all sails
        
    % Lift perpendicular to wind
    l              = results(is).f'*sails(is).liftDir; % lift force on sail is
    results(is).l  = l*sails(is).liftDir;              % lift force vector on sail is
    results(is).cl = l/(0.5*rho*tws^2*sails(is).A);    % lift coefficient of sail is
    L              = L  + l;                           % add to lift force on all sails
    
    A = A + sails(is).A;   % area of all sails
    F = F + results(is).f; % total force on all sails
end

% Centre of effort
[results, CEH, CEA, CEY] = calcCE(sails,results);


% Store in sails structure
for is = 1:length(sails)
    results(is).F   = F;   % total force on all sails
    results(is).A   = A;   % Total area of the wings
    
    results(is).FX = FX;                  % thrust force on all sails
    results(is).CX = FX/(.5*rho*tws^2*A); % thrust force coefficient of all sails
    
    results(is).FY = FY;                  % heeling force on all sails
    results(is).CY = FY/(.5*rho*tws^2*A); % heeling force coefficient of all sails
    
    results(is).FZ = FZ;                  % heeling force on all sails
    results(is).CZ = FZ/(.5*rho*tws^2*A); % heeling force coefficient of all sails
    
    results(is).D  = D;                   % drag force on all sails
    results(is).CD = D/(.5*rho*tws^2*A);  % drag force coefficient of all sails
    
    results(is).L  = L;                   % lift force on all sails
    results(is).CL = L/(.5*rho*tws^2*A);  % lift force coefficient of all sails
    
    results(is).CEH = CEH; % centre of effort z-coordinate for all sails
    results(is).CEA = CEA; % centre of effort x-coordinate for all sails
    results(is).CEY = CEY;
    
    results(is).M = FY*CEA;
    results(is).CM = FY*CEA/(.5*rho*tws^2*A);
    
end


