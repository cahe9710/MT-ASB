close all; clear all; clc;
%% Input data
Fx = -1.2; %force in mast based x-direction [N]
Fy = 60; %force in mast based y-direction [N]
Fz = 0; %force in mast based z-direction [N]
My = .2; %bending moment at upper baering coused by the the forces in x-direction [Nm]
Mx = -10; %bending moment at upper baering coused by the the forces in y-direction [Nm]
Mz = 10; %torsion moemnt around the mast based z-axis [Nm]
r=45*10^-3; %mast radius [m]
t=3*10^-3; %Mast wall thisckness [m]
Hb=0.85; %Distance between bearings [m]
%% Consatnts
E= 70*10^9; %Elsatic modulus for aluminium
poissons= 0.33; %Poisson's ratio for aluminium
G= E/(2*(1-poissons)); %Shear modulus for alumninium
a=r-t/2; %Mean radius of mast
Wb=pi()/4*a^2*t; %Bending resistance of mast (thin walled tube)
Wv=pi()*a^2*t; %Torsion resistance of mast (thin walled tube)
I=pi()/4*a^3*t; %Moment of inertia for mast cross section in bending direction (thin walled tube)
A=2*pi()*a*t; %Cross-sectional area of mast (thin walled tube)
Sa= 2*a^2*t; %Static moment of a halfcircle with mean radius a and thickness t
fi=[-180:180]*pi()/180; %Angle vector with onde degre seps in radians
%% Deriving of reactionary forces and moments
Frlx= My*Hb; %Reactionary force in lower bearing (x-direction)
Frly= -Mx*Hb; %Reactionary force in lower bearing (y-direction)
Frux= -(Fx+Frlx); %Reactionary force in upper bearing (x-direction)
Fruy= -(Fy+Frly); %Reactionary force in upper bearing (y-direction)
Frz=-Fz; %Reactionary force in z-direction (carried by lower baering)
Mr= -Mz; %Reactionary moment from stepper motor to keep wing angle constant (applied slightly above the lower baering)
Tx= Fx+Frux; %Internal reansverse force in mast between bearings (x-direction)
Ty= Fy+Fruy; %Internal reansverse force in mast between bearings (y-direction)
%% Stress calculation
sigmaz= -Fz/A; %Normal stress from mast axial forces
sigmabxmax= My/Wb; %Maximum normal stress at upper baering from bending in x-direction
sigmabymax= Mx/Wb; %Maximum normal stress at upper baering from bending in y-direction
sigmatotu= sigmaz + sigmabxmax*cos(fi)-sigmabymax*sin(fi); %total Normal stress at upper bearing as a function of the angle fi from the x direction oriented clockwise as seen from above
%No bending moment present in lower bareing
taut= Mz/Wv; %Shear stresses from torsion of mast
tauo= taut + (Fy*cos(fi)-Fx*sin(fi))*Sa/(I*2*t); %Tangential shear stress in mast above bearings as a function of the angle fi from the x direction oriented clockwise as seen from above
taub= taut + (Ty*cos(fi)-Tx*sin(fi))*Sa/(I*2*t); %Tangential shear stress in mast between bearings as a function of the angle fi from the x direction oriented clockwise as seen from above
%tangential loads?
%% Strains
epsilonuz= sigmatotu*1/E; %Normal strain in the z direction as a function of the angle fi from the x direction oriented clockwise as seen from above
epsilonlz=sigmaz*[1:length(fi)]; %Normal strain at the lower bearing as a function of the angle fi from the x direction oriented clockwise as seen from above
gammao=tauo*1/G; %Tangential shear strain above the bearings
gammab=taub*1/G; %Tangential shear strain betweens the bearings
%% plots
figure(1)
subplot(2,1,1)
plot(fi*180/pi(), epsilonuz)
title('Axial strain at upper bearing')
xlabel('Angle from wing front [dergrees]')
ylabel('Strain')
subplot(2,1,2)
plot(fi*180/pi(), epsilonlz)
title('Axial strain at lower bearing')
xlabel('Angle from wing front[dergrees]')
ylabel('Strain')

figure(2)
subplot(2,1,1)
plot(fi*180/pi(), gammao)
title('Tangential shear strain over bearings')
xlabel('Angle from wing front [dergrees]')
ylabel('Strain')
subplot(2,1,2)
plot(fi*180/pi(), gammab)
title('Tangential shear strain between bearings')
xlabel('Angle from wing front [dergrees]')
ylabel('Strain')
