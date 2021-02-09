function [] = plotStreamlines(sails, mir, Rcore, figureNr)
%--------------------------------------------------------------------------
% [] = plotStreamlines(sails, mir, figureNr)
%
% Function plotStreamline calculates the streamlines according to input in
% structure inSpace and plot them together with panels on sail
%
% -------- INPUT --------
%   sails       - Structure containing lattices, vortices strength, etc
%   mir         - =1: mirror sail in z=0, =0 no mirror (theoretical. Visual
%                 mirroring of the sails are defined in sails structure)
%   Rcore       - Fictive "vortex core size"
%   figureNr    - Figure number
%
%-------- OUTPUT --------
%   A plot with the sails' panels and streamlines from defined starting
% 	points
%
%--------------------------------------------------------------------------
global twa

% Plot panels
figure(figureNr); clf
plotPanels(sails, figureNr); axis equal

% -------------------------------------------------------------------------
% Define input
while 1
    
    fprintf('\n -------------- Plot streamlines -------------- \n')
    fprintf('   1. Plot streamlines in space \n')
    fprintf('   2. Plot streamlines in a z-plane \n')
    fprintf('   3. Go back \n')
    plotChoice = input('Choose option: ');
    
    pointsChoice = 0;
    switch plotChoice
        case {1,2}
            if plotChoice == 2;
                zPlane = input('Input z-coordinate of plane: ');
                cut = cutSail(sails, zPlane); % cut matrix defines the coordinates of the cut. Format: [x,y,sail]
            end
            
            while ~any(pointsChoice == [1 2 3])
                fprintf('\nHow would you like to specify starting points of the streamlines?\n')
                fprintf('   1. From points distributed on a straight line\n')
                fprintf('   2. From manual input of points\n')
                fprintf('   3. Go back\n')
                pointsChoice = input('Choose option: ');
                
                switch pointsChoice
                    case 1
                        fprintf('\nDefine first end point on straight line:\n')
                        p1(1,1) = input('x = ');
                        p1(2,1) = input('y = ');
                        if plotChoice == 1;
                            p1(3,1) = input('z = ');
                        elseif plotChoice == 2;
                            p1(3,1) = zPlane;
                        end
                        
                        fprintf('\nDefine second end point on straight line:\n')
                        p2(1,1) = input('x = ');
                        p2(2,1) = input('y = ');
                        if plotChoice == 1;
                            p2(3,1) = input('z = ');
                        elseif plotChoice == 2;
                            p2(3,1) = zPlane;
                        end
                        np = input('\nInput number of points on the straight line (including end points): ');
                        
                        % Calculate points on the line
                        step = (p2-p1)/(np-1);
                        p0(:,1) = p1;
                        for k = 2:np
                            p0(:,k) = p0(:,k-1) + step;
                        end
                        
                    case 2
                        fprintf('\nDefine starting point of streamline:\n')
                        another = 1; k = 0;
                        while another == 1
                            k = k + 1;
                            p0(1,k) = input('x = ');
                            p0(2,k) = input('y = ');
                            if plotChoice == 1;
                                p0(3,k) = input('z = ');
                            elseif plotChoice == 2;
                                p0(3,k) = zPlane;
                            end
                            another = input('Do you wish to calculate another streamline? (0 = no, 1 = yes) ');
                        end
                        
                    case 3
                        fprintf('Going back...\n');
                    otherwise
                        fprintf('Wrong input! Try again.\n');
                end
            end
            
        case 3
            fprintf('Going back...\n'); return
        otherwise
            fprintf('Wrong input! Try again.\n');
    end
    
    switch pointsChoice
        case {1,2}
            xEnd = input('Input length of streamline (x-coordinate): ');
            step = input('Input step length of streamline: ');
            fprintf('\nCalculating streamlines, please wait...')
            
            % -------------------------------------------------------------------------
            % Calculate streamlines
            if plotChoice == 2; plane = 1; else plane = 0; end
            
            for ip0 = 1:length(p0(1,:)) % loop for all starting points
                p  = p0(:,ip0);
                if p(1) > xEnd; 
                    fprintf('\nCan not calulate streamline, starting point larger than end point\n'); 
                else                
                    [streamLine Q] = calcStreamline(p, xEnd, step, plane, sails, mir, Rcore);
                    streamLineVec{ip0} = streamLine;
                    Qvec{ip0} = Q;
                end
            end
            fprintf(' Done!')
            
            % -------------------------------------------------------------------------
            % Plot streamlines
            if plotChoice == 2; clf; end
            
            qVecAll = [];
            
            % Make colormap for all streamlines
            for iLine = 1:length(Qvec)
                qVecAll = [qVecAll Qvec{iLine}];
            end
            qVecAll = sort(qVecAll);
            lineColor = colormap(jet(length(qVecAll)));
            
            % Plot streamlines
            fprintf('\nPlotting results...')
            for iLine = 1:length(Qvec)
                qVec = Qvec{iLine};
                streamLine = streamLineVec{iLine};
                for dLine = 1:length(qVec)-1
                    if qVec(dLine) < min(qVecAll)
                        icolor = 1;
                    elseif qVec(dLine) > max(qVecAll)
                        icolor = length(qVecAll);
                    else
                        icolor = interp1([min(qVecAll) max(qVecAll)],[1 length(qVecAll)],qVec(dLine));
                        icolor = round(icolor);
                    end
                    
                    p = plot3(streamLine(1,dLine:dLine+1), streamLine(2,dLine:dLine+1), streamLine(3,dLine:dLine+1)); % plot short line
                    set(p,'color',lineColor(icolor,:)) % set color related to velocity
                    hold on
                end
            end
            axis equal
            
    end
    
    if plotChoice == 2; % plot cut
        for i = 1:length(cut(1,1,:))
            plot3(cut(1,:,i), cut(2,:,i),ones(size(cut(2,:,i)))*zPlane,'k','linewidth',2); hold on % plot cut
            axis equal; grid off; view(twa*180/pi,90)
        end
    end
    
    if plotChoice == 1 || plotChoice == 2; fprintf(' Done!\n'); return; end
    
end


