function lattices = generateLattice(panels,wakeType,wakeLength,environment)
%--------------------------------------------------------------------------
% lattices = generateLattice(panels,wakeType,wakeLength)
% 
% Function generateLattice creates the vortex lattice for one sail and
% defines normals, areas, control points
%
% -------- INPUT --------
%   panels      - Geometry in struct format
%   wakeType	- Type of wake, 'free' or 'fixed'
%   wakeLength	- Fixed wake: wake length from T.E
%				  Free wake:  length of first spanwise set of wake elements      
%
%-------- OUTPUT --------
%   lattices    - Lattice structure
%
%--------------------------------------------------------------------------
% Preallocate memory
Nx = length(panels(:,1));
Nz = length(panels(1,:));
lattices(Nx,Nz) = struct('sw',[],'se',[],'nw',[],'ne',[],'n',[],'a',[],'c',[],'ca',[]);

for iz = 1:Nz
    ps = zeros(3,Nx+1);
    pn = zeros(3,Nx+1);
    % Get south and north coordinates for ONE horizontal set of panels
    for ix = 1:Nx
        ps(:,ix) = panels(ix,iz).sw;
        pn(:,ix) = panels(ix,iz).nw;
    end
    ps(:,ix+1) = panels(ix,iz).se;
    pn(:,ix+1) = panels(ix,iz).ne;
    
%     for ix =1:Nx
%         ps(:,ix+1) = panels(ix,iz).se;
%         pn(:,ix+1) = panels(ix,iz).ne;
%     end
% 
%     ps(:,1)=panels(1,iz).sw;    
%     pn(:,1)=panels(1,iz).nw;    
    
    % Create south corner point in each vortex ring
        dxyz = diff(ps')'*0.25; % difference between the first two south points*0.25
        dxyz(:,end+1) = dxyz(:,end);
        ps   = ps + dxyz; % places vortices at 1/4 of the chord

        % Calculate wake points for fixed wake or first step for free wake
		ps = addWakePoint(ps,wakeType,wakeLength,environment);
		
    % Create north corner point in each vortex ring
        dxyz = diff(pn')'*0.25; % difference between the first two north points*0.25
        dxyz(:,end+1) = dxyz(:,end);
        pn   = pn + dxyz; % places vortices at 1/4 of the chord
        
        % Calculate wake points for fixed wake or first step for free wake
        pn = addWakePoint(pn,wakeType,wakeLength,environment);
        
    % Store vortex locations, panel areas and panel normal in lattice
    % format
    for jx = 1:Nx+1
        lattices(jx,iz).sw = ps(:,jx);   % store sw vortex point
        lattices(jx,iz).nw = pn(:,jx);   % store nw vortex point
        lattices(jx,iz).se = ps(:,jx+1); % store se vortex point
        lattices(jx,iz).ne = pn(:,jx+1); % store ne vortex point
        
        % Calculate control point location, centre of aerodynamic, panel areas and normals
        [lattices(jx,iz).c, lattices(jx,iz).ca, lattices(jx,iz).n, lattices(jx,iz).a] = ...
            calcLatticeSpec(lattices(jx,iz).nw, lattices(jx,iz).ne, lattices(jx,iz).se, lattices(jx,iz).sw);
    end  
end
