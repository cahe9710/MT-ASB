function [streamLine Q] = calcStreamline(p, xEnd, step, plane, sails, mir, Rcore)
% -------------------------------------------------------------------------
% [streamLine Q] = calcStreamline(p, xEnd, step, sails ,mir, Rcore)
% 
% Function calcStreamline calculates coordinates and local velocities for 
% a streamline
%
% -------- INPUT --------
%   p           - Starting point of streamline [x,y,z]'
%   xEnd        - x-coordinate at end of streamline
%   step        - Steplength in streamline
%   plane       - =1 for streamlines in xy-plane, =0 in space
%   sails       - structure with sails
%   mir         - =1 if mirror image at z = 0 (theoretical)
%   Rcore       - Fictive "vortex core size"
%
%-------- OUTPUT --------
%   streamLine  - Matrix contating coordinates of the streamline. Each
%                 column represents one point
%   Q           - Column vector containing the local velocity at each point
%                 on the streamline
%
% -------------------------------------------------------------------------
ip = 0;
while p(1) < xEnd; % caclulate streamline from p0 to Xend
    ip       = ip + 1;                  % counter
    qv = calcInduced(p,sails,mir,Rcore);% calculate induced velocity at p due to all vortices
    q        = qv + generateWind(p(3)); % total veclocity at p
    if plane == 1;
        q(3) = 0;
    end
    
    % Save point coordinates and velocites
    streamLine(:,ip) = p;       % save coordinates
    Q(ip)            = norm(q); % save velocity
    
    qUnit = q/norm(q);      % normal in velocity direction
    p     = p + qUnit*step % take step in velocity direction         

end  