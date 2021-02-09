function[panels]= meshRig(airfoil,xPanelDistrib)
% Input argument: airfoil struct ==> either geometry.wing or geometry.flap

Nx = airfoil.Nx;
Nz = airfoil.Nz;

NW = airfoil.TE(end,:);
NE = airfoil.LE(end,:);
SW = airfoil.TE(1,:);
SE = airfoil.LE(1,:);


ipanel=0; %Panel counter


for iz = 1:Nz
    % Calc upper and lower z-coords of this row
    z_upper  = SW(3)+(iz-0)*(NW(3)-SW(3))/Nz;   % Upper z of panel row
    z_lower  = SW(3)+(iz-1)*(NW(3)-SW(3))/Nz;   % Lower z of panel row
    
    % Define the corners of the current row of panels
    Nw = [fitToGeom(z_upper,airfoil.LE) ,0,z_upper];
    Ne = [fitToGeom(z_upper,airfoil.TE) ,0,z_upper];
    Sw = [fitToGeom(z_lower,airfoil.LE) ,0,z_lower];
    Se = [fitToGeom(z_lower,airfoil.TE) ,0,z_lower];
    
    if strcmp(xPanelDistrib,'linear')==1
        xDistUp = linspace(Nw(1), Ne(1),Nx+1);
        xDistLow = linspace(Sw(1), Se(1),Nx+1);
    elseif strcmp(xPanelDistrib,'cosine')==1
        xDistUp = ((0.5*(1-cos(linspace(0,pi,Nx+1))))*(Ne(1)-Nw(1)))+Nw(1);
        xDistLow = ((0.5*(1-cos(linspace(0,pi,Nx+1))))*(Se(1)-Sw(1)))+Sw(1);
    elseif strcmp(xPanelDistrib,'cosine2LE')==1
        xDistUp = ((cos(linspace(0,pi/2,Nx+1)))*(Ne(1)-Nw(1)))+Nw(1);
        xDistLow = ((cos(linspace(0,pi/2,Nx+1)))*(Se(1)-Sw(1)))+Sw(1);
    elseif strcmp(xPanelDistrib,'cosine2TE')==1
        xDistUp = ((1+cos(linspace(pi,3*pi/2,Nx+1)))*(Ne(1)-Nw(1)))+Nw(1);
        xDistLow = ((1+cos(linspace(pi,3*pi/2,Nx+1)))*(Se(1)-Sw(1)))+Sw(1);
%         xDistUp = ((0.5*(1-cos(linspace(0,pi/2,Nx+1))))*(Ne(1)-Nw(1)))+Nw(1);
%         xDistLow = ((0.5*(1-cos(linspace(0,pi/2,Nx+1))))*(Se(1)-Sw(1)))+Sw(1);
    else
        disp('Warning ! X distriution unknown, using linear');
        xDistUp = linspace(Nw(1), Ne(1),Nx+1);
        xDistLow = linspace(Sw(1), Se(1),Nx+1);
    end

    for ix=Nx:-1:1 %1:Nx %
    % Define panel corners
    nw = [xDistUp(ix); 0; z_upper];
    ne = [xDistUp(ix+1); 0; z_upper];
    sw = [xDistLow(ix); 0; z_lower];
    se = [xDistLow(ix+1); 0; z_lower];

    if strcmp(airfoil.Type, 'flap')
        nw = rotateFlap(nw,airfoil.flapAngle,airfoil.flapAxis);
        ne = rotateFlap(ne,airfoil.flapAngle,airfoil.flapAxis);
        sw = rotateFlap(sw,airfoil.flapAngle,airfoil.flapAxis);
        se = rotateFlap(se,airfoil.flapAngle,airfoil.flapAxis);
    end  
    
    % Rotate panels according to sheet angle
    nw=rotatePoint(nw,airfoil.sheetAngle);
    ne=rotatePoint(ne,airfoil.sheetAngle);
    sw=rotatePoint(sw,airfoil.sheetAngle);
    se=rotatePoint(se,airfoil.sheetAngle); 
    
    % Add heel angle
    nw=heel(nw,airfoil.heelAngle);
    ne=heel(ne,airfoil.heelAngle);
    sw=heel(sw,airfoil.heelAngle);
    se=heel(se,airfoil.heelAngle);
    
    % Move rig at its mast position
    nw= nw+airfoil.wingOrigin;
    ne= ne+airfoil.wingOrigin;
    sw= sw+airfoil.wingOrigin;
    se= se+airfoil.wingOrigin;
    

    % Add panel coordinates to the panel array
    ipanel = ipanel+1;
    panels(ix,iz).nw=nw;
    panels(ix,iz).ne=ne;
    panels(ix,iz).sw=sw;
    panels(ix,iz).se=se;

    end
    
end
    
function xi = fitToGeom(zi,edge)
% Takes into account the curvature on the rig geometry
%
xi = interp1(edge(:,3),edge(:,1),zi,'spline');

function p = rotatePoint(xyz, sheetAngle)
p = [cos(sheetAngle) sin(sheetAngle) 0;
    -sin(sheetAngle) cos(sheetAngle) 0;
    0 0 1]*xyz;

function p = rotateFlap(xyz, sheetAngle, axisPosition)
p = [cos(sheetAngle) sin(sheetAngle) 0;
    -sin(sheetAngle) cos(sheetAngle) 0;
    0 0 1]*(xyz-axisPosition)+ axisPosition;

function p = heel(xyz,heelAngle)
% Heel the boat around the global x-axis
p = [  1         0              0        ;
       0  cos(heelAngle)   -sin(heelAngle);
       0 sin(heelAngle)   cos(heelAngle)]*xyz;