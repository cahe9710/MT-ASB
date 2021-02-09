function [geometry] = getGeometry(filePath, dxW, flapAxis, dxF)
% Import rig geometry
% From a rig file defined with the origin on the linit between flap and
% wing
% X = 0 corresponds to the 

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

wingLE = tmp{idMax};
wingTE = tmp{idMid};
flapLE = tmp{idMid};
flapTE = tmp{idMin};

wingChord = wingLE(1,1)-wingTE(1,1);
flapChord = flapLE(1,1)-flapTE(1,1);

moveEdges = wingLE(1,1)-dxW;

wingLE(:,1) = wingLE(:,1)-moveEdges;
wingTE(:,1) = wingTE(:,1)-moveEdges;
flapLE(:,1) = flapLE(:,1)-moveEdges;
flapTE(:,1) = flapTE(:,1)-moveEdges;

moveFlapX = flapLE(1,1) - (flapAxis(1)+dxF);
moveFlapY = flapLE(1,2) - flapAxis(2);

flapLE(:,1) = flapLE(:,1)-moveFlapX;
flapLE(:,2) = flapLE(:,2)-moveFlapY;

flapTE(:,1) = flapTE(:,1)-moveFlapX;
flapTE(:,2) = flapTE(:,2)-moveFlapY;

% wingLE(:,1) = -wingLE(:,1);
% wingTE(:,1) = -wingTE(:,1);
% flapLE(:,1) = -flapLE(:,1);
% flapTE(:,1) = -flapTE(:,1);
% 
% wingLE(:,2) = -wingLE(:,2);
% wingTE(:,2) = -wingTE(:,2);
% flapLE(:,2) = -flapLE(:,2);
% flapTE(:,2) = -flapTE(:,2);

geometry.wing.LE = wingLE;
geometry.wing.TE = wingTE;

geometry.flap.LE = flapLE;
geometry.flap.TE = flapTE;

% geometry.wing.LE = tmp{idMax};
% geometry.wing.TE = tmp{idMid};
% geometry.flap.LE = tmp{idMid};
% geometry.flap.TE = tmp{idMin};
% 
geometry.wing.NW = geometry.wing.TE(end,:);
geometry.wing.NE = geometry.wing.LE(end,:);
geometry.wing.SW = geometry.wing.TE(1,:);
geometry.wing.SE = geometry.wing.LE(1,:);

geometry.flap.NW = geometry.flap.TE(end,:);
geometry.flap.NE = geometry.flap.LE(end,:);
geometry.flap.SW = geometry.flap.TE(1,:);
geometry.flap.SE = geometry.flap.LE(1,:);
% 
