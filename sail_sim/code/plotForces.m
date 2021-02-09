function plotForces(sails, results, figureNr)
%--------------------------------------------------------------------------
% [] = plotForces(sails, results)
% 
% Function plotForces plots the panels of the sails and the lift and drag
% force on each panel
%
% -------- INPUT --------
% sails     - Structure containing lattices, vortices strength, etc
% results   - Structure containing forces, pressures, etc.
% figureNr  - Number of figure
%
%-------- OUTPUT --------
% A plot of the sails with lift and drag vectors plotted on each
% panel
%
%--------------------------------------------------------------------------

% ............. Plot panels .............
plotPanels(sails,figureNr);

% ............. Plot lift vectors .............

for is = 1:length(sails)        % sail loop
    x  = zeros(1,sails(is).Nx*sails(is).Nz);
    y  = zeros(1,sails(is).Nx*sails(is).Nz);
    z  = zeros(1,sails(is).Nx*sails(is).Nz);
    fx = zeros(1,sails(is).Nx*sails(is).Nz);
    fy = zeros(1,sails(is).Nx*sails(is).Nz);
    fz = zeros(1,sails(is).Nx*sails(is).Nz);
    k = 0;
    for ix = 1:sails(is).Nx     % chordwise loop
        for iz = 1:sails(is).Nz % spanwise loop
            k = k + 1;     
            
            % Store coordinates
            x(k) = sails(is).lattice(ix,iz).ca(1);
            y(k) = sails(is).lattice(ix,iz).ca(2);
            z(k) = sails(is).lattice(ix,iz).ca(3);
                       
            % Store total force
            fx(k) = results(is).lattice(ix,iz).f(1); 
            fy(k) = results(is).lattice(ix,iz).f(2); 
            fz(k) = results(is).lattice(ix,iz).f(3);
        end
    end
    
    % Plot force on each panel
    quiver3(x,y,z, fx,fy,fz,'b'); hold on
    
%     plot CE
    plot3((results(is).CEA),(results(is).CEY),(results(is).CEH),'or','markersize',12,'markerfacecolor','r');
%     quiver3((results(is).CEA),(results(is).CEY),(results(is).CEH), results(is).FX/1e4,results(1).FY/1e4,0, 'k', 'linewidth', 3);
%     quiver3((results(is).CEA),(results(is).CEY),(results(is).CEH), results(is).FX/1e4,0,0, 'r', 'linewidth', 3);
%     quiver3((results(is).CEA),(results(is).CEY),(results(is).CEH), 0,results(is).FY/1e4,0, 'b', 'linewidth', 3);
    
%     quiver3(abs(results(1).CEA),0,abs(results(1).CEH), (results(1).D*sails(1).dragDir(1))/1e3,(results(1).D*sails(1).dragDir(2))/1e3,0, 'g', 'linewidth', 5);

     plot3(results(is).cea,results(is).cey,results(is).ceh, 'sm', 'markersize', 8, 'MarkerFaceColor', 'm');
%      quiver3(results(is).cea,results(is).cey,results(is).ceh,10*results(is).l(1)/norm(results(is).L),10*results(is).l(2)/norm(results(is).L),10*results(is).l(3)/norm(results(is).L), 'm', 'LineWidth', 3);
%      quiver3(results(is).cea,results(is).cey,results(is).ceh,10*results(is).d(1)/norm(results(is).D),10*results(is).d(2)/norm(results(is).D),10*results(is).d(3)/norm(results(is).D), 'b', 'LineWidth', 3);
    
    quiver3(results(is).cea,results(is).cey,results(is).ceh, (norm(results(is).d)*sails(is).dragDir(1))/5e2,(norm(results(is).d)*sails(is).dragDir(2))/5e2,0, 'g', 'linewidth', 3);
    quiver3(results(is).cea,results(is).cey,results(is).ceh, (norm(results(is).l)*sails(is).liftDir(1))/5e2,(norm(results(is).l)*sails(is).liftDir(2))/5e2,0, 'm', 'linewidth', 3);
     
     plot3(sails(is).wing.wingOrigin(1),sails(is).wing.wingOrigin(2),sails(is).wing.wingOrigin(3), 'hk', 'MarkerFaceColor', 'k', 'MarkerSize', 10);
    
%     if sails(is).mir == 1; % Plot mirrored sailplan
%         quiver3(x,y,-z, fx,fy,-fz,'b'); hold on
%     end
end
% quiver3(results(1).CEA,results(1).CEY,results(1).CEH, (results(1).D*sails(1).dragDir(1))/5e2,(results(1).D*sails(1).dragDir(2))/5e2,0, 'b', 'linewidth', 3);
% quiver3(results(1).CEA,results(1).CEY,results(1).CEH, (results(1).L*sails(1).liftDir(1))/5e2,(results(1).L*sails(1).liftDir(2))/5e2,0, 'r', 'linewidth', 3);

quiver3(results(1).CEA,results(1).CEY,results(1).CEH, 0,results(1).FY/5e2,0, 'b', 'linewidth', 3);
quiver3(results(1).CEA,results(1).CEY,results(1).CEH, results(1).FX/5e2,0,0, 'r', 'linewidth', 3);

axis equal
% view(0,90);