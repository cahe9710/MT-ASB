function  draw_Boat(Boat, sog, roll,awa,aws,twa,leeway,sheets,hoists,rigs,rudder);
% hoist is between 0.25 and 1
yaw = 0;
%heel = heel*2;


hold off;
plot3(0,0,0);
hold on;
F = Boat.F; 
V = Boat.V;

% Plot the hull
V_ = attitudes(V.hull,yaw,roll,0); % yaw,roll,pitch
patch('faces', F.hull, 'vertices' ,V_,'FaceColor',0.9*[1 1 1],'EdgeColor','none');

% X-axis & Leeway
line3([-150 0 0],[150 0 0],1,[0 0 0]);
p2 = [60+80*cos(leeway) 80*sin(leeway) 0];
line3([60 0 0],p2,2,[0 0 1]);
txt = sprintf('%.1fkn, %.1f°',ms2kn(sog),rad2deg(leeway));
text(p2(1),p2(2),p2(3),txt,'fontsize',12);

% Rudder
p1 = [-100,0,0];
p2 = p1 + 40*[-cos(rudder*2) sin(rudder*2) 0];
line3(p1,p2,2,[0 0 1]);
txt = sprintf('  %.1f°',rad2deg(rudder));
text(p2(1),p2(2),p2(3),txt,'fontsize',12);

% Plot the deck
V_ = attitudes(V.deck,yaw,roll,0); % yaw,roll,pitch
p = patch('faces', F.deck, 'vertices' ,V_,'FaceColor',0.7*[1 1 1],'EdgeColor','none');

% Plot the rig
section_height = 18; % [m]
for irig = 1:length(rigs)
  x_mast = rigs(irig).xCP;
    % calc hoist fractions
    hoist = hoists(irig);
    zCP   = 35 + hoist*(65/2); % Over waterline
    dz_ = (min(1,[4*hoist-0  4*hoist-1  4*hoist-2  4*hoist-3 ])-1)*section_height; % How much each section is reefed
    for isec = 1:4
      V_ = V.Rig_sections{isec} + [0 0 dz_(isec)];
      V_ = attitudes(V_,sheets(irig),0,0); % yaw,roll,pitch
      V_ = V_+[x_mast 0 0];
      V_ = attitudes(V_,yaw,roll,0); % yaw,roll,pitch
      p = patch('faces', F.Rig_sections{isec}, 'vertices' ,V_,'FaceColor',[[0.99 0.8 0.8]],'EdgeColor','none','FaceAlpha',0.8);
    end
    p = attitudes([x_mast 0 110+dz_(4)],0,roll,0); % yaw,roll,pitch
    eta  = multirig_knockDown(awa,rigs(irig).xCP);
    eta = 1.35;
    text(p(1),p(2),p(3),sprintf('%.0f%% eta=%.2f',hoist*100,eta),'fontsize',12);
    CP = [0 0 zCP];
    CP = attitudes(CP,sheets(irig),0,0); % yaw,roll,pitch
    CP = attitudes(CP,0,roll,0); % yaw,roll,pitch
    CP = CP+[x_mast 0 0];
    % Trim
    p2= CP + 30*[cos(-sheets(irig)) sin(-sheets(irig)) 0];
    line3(CP,p2,1,[0 0 0]);
    txt = sprintf('sheeet=%.0f°',rad2deg(sheets(irig)));
    text(p2(1),p2(2),p2(3),txt,'fontsize',12);

    % AWA
    p2=  CP+[60*cos(-awa) 60*sin(-awa) 0];
    txt = sprintf('  aw=%.1fm/s, %.0f°',aws,rad2deg(awa));
    line3(CP,p2,2,[0,0,1]);text(p2(1),p2(2),p2(3),txt,'fontsize',12);
end
% TWA
p2  =  CP+[60*cos(-twa) 60*sin(-twa) 0];
line3(CP,p2,2,[0.7,0.7,1]);

% Water
plotwaves(min(V.hull(:,1)),max(V.hull(:,1)),min(V.hull(:,2)),max(V.hull(:,2)),0,50);

%North
%p1 =  [0 0 0];
%p2 = 170*[cos(-yaw) 60*sin(-yaw) 0];
%line3(p1,p1,2,[0,1,1]);text(p2(1),p2(2),p2(3),'N','fontsize',12);
%------------------------------------------------
  
 light;                               % add a default light
 daspect([1 1 1]);                    % Setting the aspect ratio
 view(3);                             % Isometric view
 xlabel('X'),ylabel('Y'),zlabel('Z');
 rotate3d on;
 hold off;
 axis off;
 view(10,10);
 
 

  