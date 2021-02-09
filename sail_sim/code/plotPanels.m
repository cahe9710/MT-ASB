function plotPanels(sails, figureNr)
%--------------------------------------------------------------------------
% [] = plotPanels(sails, figureNr)
% 
% Function plotPanels plots the panels of the discretised sails.
%
% -------- INPUT --------
%   sails     - Structure containing lattices, vortices strength, etc
%   figureNr  - Number of figure
%
%-------- OUTPUT --------
%   A plot with the panels of all sails
%
%--------------------------------------------------------------------------
transp = .7; % transparency of the panels
figure(figureNr); %clf
for is = 1:length(sails)
    for ix = 1:sails(is).Nx
        for iz = 1:sails(is).Nz
            panel = sails(is).panels(ix,iz);
            color = [.6 .6 .6];
            p = patch([panel.sw(1),panel.se(1),panel.ne(1),panel.nw(1),panel.sw(1)],... % fill panels
                      [panel.sw(2),panel.se(2),panel.ne(2),panel.nw(2),panel.sw(2)],...
                      [panel.sw(3),panel.se(3),panel.ne(3),panel.nw(3),panel.sw(3)],color);
            hold on
            alpha(p,transp); % set transparency of the panels
            
%             rotate3d on; axis image
%             view(-40,36)
%             disp("IX: "); disp(ix);
%             disp("Iz: "); disp(iz);
%             disp("IPanel: "); disp(ix+iz);
%             pause(1);
          
%             if sails(is).mir == 1;
%                 pmir =  patch([panel.sw(1),panel.se(1),panel.ne(1),panel.nw(1),panel.sw(1)],... % fill panels
%                        [panel.sw(2),panel.se(2),panel.ne(2),panel.nw(2),panel.sw(2)],...
%                        [-panel.sw(3),-panel.se(3),-panel.ne(3),-panel.nw(3),-panel.sw(3)],color);
%                 set(pmir,'LineWidth',1)
%                 alpha(pmir,transp); % set transparency of the panels
%             end
            hold on
        end
    end
end

xlabel('X')
ylabel('Y')
zlabel('Z')
rotate3d on; axis image
view(-40,36)




