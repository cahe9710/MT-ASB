function cut = cutSail(sails, Z)
%--------------------------------------------------------------------------
% cut = cutSail(sails, Z)
% 
% Function cutSail extracts the x- and y-coordinates of the intersection
% with a plane for constant z
%
% -------- INPUT --------
%   sails       - Structure containing lattices, vortices strength, etc
%   Z           - Z-coordinate of the plane
%
%-------- OUTPUT --------
% cut           - Matrix with the coordinates at the plane. Ordered as
%                 [coordinates,point,sail]:
%                    
%                                SAIL 1           ...         SAIL M
%                 point nr:   1   ...   n                   1   ...   n    
%                           [ x1  ...	xn]               [ x1  ...	 xn]
%                           [ y1  ...	yn]               [ y1  ...	 yn]
%                           [ z1  ...	zn]               [ z1  ...	 zn]
%                           
%--------------------------------------------------------------------------

for is = 1:length(sails)
    k = 0;
    for ix = 1:sails(is).Nx;
        for iz = 1:sails(is).Nz;
            if ix ~= sails(is).Nx
                [p,check] = plane_line_intersect([0,0,1]',[0,0,Z]',sails(is).lattice(ix,iz).sw,sails(is).lattice(ix,iz).nw);
            else
                [p,check] = plane_line_intersect([0,0,1]',[0,0,Z]',sails(is).lattice(ix,iz).se,sails(is).lattice(ix,iz).ne);
            end
            
            if check == 1;
                k = k + 1;
                cut(:,k,is) = p;
            end
        end
    end
end

