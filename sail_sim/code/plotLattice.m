function plotLattice(sails, figureNr)
%--------------------------------------------------------------------------
% [] = plotLattice(sails, figureNr)
% 
% Function plotLattice plots the lattices of the discretised sails.
%
% -------- INPUT --------
%   sails     - Structure containing lattices, vortices strength, etc
%   figureNr  - Number of figure
%
%-------- OUTPUT --------
%   A plot with the lattices of all sails and the wakes
%
%--------------------------------------------------------------------------

% plot lattice and panel normals
figure(figureNr); hold on
k = 0;
transp = 0.7;
colorMap = colormap(hsv(length(sails)));

for is = 1:length(sails)
    for ix = 1:(sails(is).Nx+sails(is).Nxw)
        for iz = 1:sails(is).Nz
            k = k + 1;
            lattice = sails(is).lattice(ix,iz);
            color = colorMap(is,:);
            if ix > sails(is).Nx; color = color*.5; end
            p = patch([lattice.sw(1),lattice.se(1),lattice.ne(1),lattice.nw(1),lattice.sw(1)],... % fill circle vortices
                      [lattice.sw(2),lattice.se(2),lattice.ne(2),lattice.nw(2),lattice.sw(2)],...
                      [lattice.sw(3),lattice.se(3),lattice.ne(3),lattice.nw(3),lattice.sw(3)],color);
            alpha(p,transp); % set transparancy of filled surfaces
            hold on
%             plot3([lattice.sw(1),lattice.se(1),lattice.ne(1),lattice.nw(1),lattice.sw(1)],... % fill circle vortices
%                       [lattice.sw(2),lattice.se(2),lattice.ne(2),lattice.nw(2),lattice.sw(2)],...
%                       [lattice.sw(3),lattice.se(3),lattice.ne(3),lattice.nw(3),lattice.sw(3)], 'ob');
%             plot3(lattice.ca(1),lattice.ca(2),lattice.ca(3), 'or');
            if sails(is).mir == 1;
                p = patch([lattice.sw(1),lattice.se(1),lattice.ne(1),lattice.nw(1),lattice.sw(1)],... % fill circle vortices
                          [lattice.sw(2),lattice.se(2),lattice.ne(2),lattice.nw(2),lattice.sw(2)],...
                          -[lattice.sw(3),lattice.se(3),lattice.ne(3),lattice.nw(3),lattice.sw(3)],color);
                alpha(p,0.5*transp); % set transparancy of filled surfaces
                hold on
            end
        end
    end
end

% axis equal; 
rotate3d on; view(-40,36)