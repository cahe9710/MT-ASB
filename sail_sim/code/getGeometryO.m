function [geometry] = getGeometry(filePath, dxW, flapAxis, dxF)
% Import rig geometry
% From a rig file defined by a wing and a flap, with increasing x values
% starting from the wing LE.
% From the raw points, the wing is moved so that the mast is the origin.
% The mast position is dxW in % of the wing chord, i.e. dxW = 0.5 means
% that the mast is centered on the wing
% The flap LE is moved with flapAxis and dxF. Flap axis is the rotation
% axis in the rig coordinate system, and dxF the distance between this axis
% and the flap LE, i.e. dxF = 0 means that the flap rotation axis is on the
% flap LE. 
%
% ----------+----------0--------------------
% |<--dxW-->|
%           |<-flapAx->|

% ----------+----------      ------0--------------
% |<--dxW-->|                |<dxF>|
%           |<-------flapAx------->|


rawPts = importdata(fullfile(filePath));

tmp1 = rawPts(1:length(rawPts)/3,:);
tmp2 = rawPts((length(rawPts)/3)+1:(2*length(rawPts)/3),:);
tmp3 = rawPts((2*length(rawPts)/3)+1:length(rawPts),:);
    
tmp{1} = sortrows(tmp1,3);
tmp{2} = sortrows(tmp2,3);
tmp{3} = sortrows(tmp3,3);

[~,idMin] = min([min(tmp{1}(:,1)),min(tmp{2}(:,1)),min(tmp{3}(:,1))]);
[~,idMax] = max([max(tmp{1}(:,1)),max(tmp{2}(:,1)),max(tmp{3}(:,1))]);

idMid = 6-idMax - idMin;

wingLE = tmp{idMin};
wingTE = tmp{idMid};
flapLE = tmp{idMid};
flapTE = tmp{idMax};

% Move the points from the rig file so that the origin (0,0) is the SW corner of the rig
moveEdges = wingLE(1,1); 
wingLE(:,1) = wingLE(:,1)-moveEdges;
wingTE(:,1) = wingTE(:,1)-moveEdges;
flapLE(:,1) = flapLE(:,1)-moveEdges;
flapTE(:,1) = flapTE(:,1)-moveEdges;

wingChord=abs(wingTE(1,1)-wingLE(1,1));
dxMast = dxW*wingChord;

% Move flap
moveFlapX = abs(flapAxis(1))-(1-dxW)*wingChord-dxF;
moveFlapY = flapLE(1,2) - flapAxis(2);

flapLE(:,1) = flapLE(:,1)+moveFlapX;
flapLE(:,2) = flapLE(:,2)-moveFlapY;

flapTE(:,1) = flapTE(:,1)+moveFlapX;
flapTE(:,2) = flapTE(:,2)-moveFlapY;

% Move the rig so the mast is the origin
wingLE(:,1) = wingLE(:,1)-dxMast;
wingTE(:,1) = wingTE(:,1)-dxMast;
flapLE(:,1) = flapLE(:,1)-dxMast;
flapTE(:,1) = flapTE(:,1)-dxMast;


geometry.wing.LE = wingLE;
geometry.wing.TE = wingTE;

geometry.flap.LE = flapLE;
geometry.flap.TE = flapTE;

geometry.wing.NW = geometry.wing.TE(end,:);
geometry.wing.NE = geometry.wing.LE(end,:);
geometry.wing.SW = geometry.wing.TE(1,:);
geometry.wing.SE = geometry.wing.LE(1,:);

geometry.flap.NW = geometry.flap.TE(end,:);
geometry.flap.NE = geometry.flap.LE(end,:);
geometry.flap.SW = geometry.flap.TE(1,:);
geometry.flap.SE = geometry.flap.LE(1,:);
% 
