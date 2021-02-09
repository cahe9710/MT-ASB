function plotPressure(sails, results, figureNr)
%--------------------------------------------------------------------------
% [] = plotPressure(sails, results, figureNr)
% 
% Function plotPressure plot the pressure distribution over the sails
%
% -------- INPUT --------
%   sails       - Structure containing lattices, vortices strength, etc
%   results     - Structure containing forces, pressures, etc.
%
% -------- OUTPUT --------
%   A plot with the sails' panels and streamlines starting 
%
%--------------------------------------------------------------------------

figure(figureNr); clf

% Get colors in right order
k = 0;
for is = 1:length(sails)
    for ix = 1:sails(is).Nx
        for iz = 1:sails(is).Nz
            k = k + 1;
            cp(k) = results(is).lattice(ix,iz).cp;
        end
    end
end

if sum(cp) < 0
    ifNeg = -1;
else ifNeg = 1;
end
colormap jet

% Plot panels
k = 0;
for is = 1:length(sails)
    for ix = 1:sails(is).Nx
        for iz = 1:sails(is).Nz
            k = k + 1;
            panel = sails(is).panels(ix,iz);
            p = patch([panel.sw(1),panel.se(1),panel.ne(1),panel.nw(1),panel.sw(1)],... % fill panels
                      [panel.sw(2),panel.se(2),panel.ne(2),panel.nw(2),panel.sw(2)],...
                      [panel.sw(3),panel.se(3),panel.ne(3),panel.nw(3),panel.sw(3)],ones(1,5)*ifNeg*results(is).lattice(ix,iz).cp);
%             if sails(is).mir == 1;
%                 pmir =  patch([panel.sw(1),panel.se(1),panel.ne(1),panel.nw(1),panel.sw(1)],... % fill panels
%                        [panel.sw(2),panel.se(2),panel.ne(2),panel.nw(2),panel.sw(2)],...
%                        [-panel.sw(3),-panel.se(3),-panel.ne(3),-panel.nw(3),-panel.sw(3)],ones(1,5)*ifNeg*results(is).lattice(ix,iz).cp);
%             end
            hold on
        end
    end
end

colorbar
title('Pressure coefficient distribution on sails')
xlabel('X'); ylabel('Y'); zlabel('Z')
rotate3d on; axis image; view(0,0);




