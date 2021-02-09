clear all
clc
close all

%% Parametrar
v=5; %[m/s] apparant windspeed
rho=1.2; %[kg/m^3] luftdensitet
g=9.82; %[m/s^2] gravitations accerlation 
alphad=45; %[o] angle of attack

%vingdata
h1= 1333.33/1000; %[m] höjd för del 1
c1=(878.25+807.29)/2000; %[m]Korda för del 1
h2= 666.67/1000; %[m] höjd för del 2
c2=(757.11+640.50)/2000; %[m] Korda för del 2
h3= 666.67/1000; %[m] höjd för del 3
c3=(586.67+319.8)/2000; %[m] Korda för del 3
m=11.3; %[kg] vingens massa

%längder
dl=0.001; % 1mm steg till plottar
l1=854/1000; %[m] mellan lager
l2=95/1000;  %[m] övre lager till underkant vinge
l3=h1/2; % [m] underkant vinge till mitt av del 1
l4=(h1+h2)/2; % [m] mitt av del 1 till mitt av del 2
l5=(h2+h3)/2; % [m] mitt av del 2 till mitt av del 3

%vingenstyngdpunkt
lx=0; %[m] ej känd atm
lz=960/1000; %[m] används ej

%mastdata
r=45*10^-3; %mast radius [m]
t=3*10^-3; %Mast wall thisckness [m]
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

%% Ving aerodynamik
%alphad=[-180:1:180]; %attackvinklar %köra en attackvinkel istället?

alphar=alphad*pi/180; %aoa till radianer

[Cl,Cd,Cm] = naca0018(alphar); %Koefficenter

%Lift - minus för att få rätt riktning
L1=-1/2*rho*v^2*c1*h1*Cl;
L2=-1/2*rho*v^2*c2*h2*Cl;
L3=-1/2*rho*v^2*c3*h3*Cl;
L=L1+L2+L3; %minus för att få rätt riktning

%Drag - minus för att få rätt riktning
D1=-1/2*rho*v^2*c1*h1*Cd;
D2=-1/2*rho*v^2*c2*h2*Cd;
D3=-1/2*rho*v^2*c3*h3*Cd;
D=D1+D2+D3;

%Torque - minus för att få rätt riktning
M1=-1/2*rho*v^2*c1^2*h1*Cm;
M2=-1/2*rho*v^2*c2^2*h2*Cm;
M3=-1/2*rho*v^2*c3^2*h3*Cm;
M=M1+M2+M3;

%Alpha system till wingfixed system
Fx1=D1.*cos(alphar')-L1.*sin(alphar');
Fx2=D2.*cos(alphar')-L2.*sin(alphar');
Fx3=D3.*cos(alphar')-L3.*sin(alphar');

Fy1=D1.*sin(alphar')+L1.*cos(alphar');
Fy2=D2.*sin(alphar')+L2.*cos(alphar');
Fy3=D3.*sin(alphar')+L3.*cos(alphar');

Fx=D.*cos(alphar')-L.*sin(alphar');
Fy=D.*sin(alphar')+L.*cos(alphar');

%Ungefär hit det är intressant för Calle

%% Lagerlaster;
%undrelagret - lager1
Rx1=(Fx1*(l2+l3)+Fx2*(l2+l3+l4)+Fx3*(l2+l3+l4+l5))/l1; %lagerkraft i x-led
Ry1=(Fy1*(l2+l3)+Fy2*(l2+l3+l4)+Fy3*(l2+l3+l4+l5)-m*g*lx)/l1; %lagerkraft i y-led
Rz1=-m*g; %lagerkraft i z-led
Mz1=-(M1+M2+M3); %moment i motorn

%övrelagret - lager 2
Rx2=-Rx1-(Fx1+Fx2+Fx3); %lagerkraft i x-led
Ry2=-Ry1-(Fy1+Fy2+Fy3); %lagerkraft i y-led


%% Snittlaster mellan lager
lm1=0:dl:l1; %vart man studerar snittet
%x-led
Tx1=-Rx1;
MBx1=Ry1*lm1;
%y-led
Ty1=-Ry1;
MBy1=-Rx1*lm1;
%z-led
N1=Rz1;
Mv1=Mz1;

%% Snittlaster mellan övre lager och vingrot 
lm2=l1:dl:l1+l2; %vart man studerar snittet
%x-led
Tx2=Tx1-Rx2;
MBx2=Ry1*lm2+Ry2*(lm2-l1);
%y-led
Ty2=Ty1-Ry2;
MBy2=-(Rx1*lm2+Rx2*(lm2-l1));
%z-led
N2=N1;
Mv2=Mv1;


%% Snittlaster vid vingroten
%x-led
Tx3=Fx1+Fx2+Fx3;
MBx3=Fy1*l3+Fy2*(l3+l4)+Fy3*(l3+l4+l5);
%y-led
Ty3=Fy1+Fy2+Fy3;
MBy3=m*g*lx-Fx1*l3-Fx2*(l3+l4)-Fx3*(l3+l4+l5);
%z-led
N3=-m*g;
Mv3=-(M1+M2+M3);


%% Stress calculation
sigmaz= N1/A; %Normal stress from mast axial forces
sigmabxmax= MBy1(end)/Wb; %Maximum normal stress at upper baering from bending in x-direction
sigmabymax= MBx1(end)/Wb; %Maximum normal stress at upper baering from bending in y-direction
sigmatotu= sigmaz + sigmabxmax*cos(fi)-sigmabymax*sin(fi); %total Normal stress at upper bearing as a function of the angle fi from the x direction oriented clockwise as seen from above
%No bending moment present in lower bareing
taut= Mv1/Wv; %Shear stresses from torsion of mast
tauo= taut + (Ty2*cos(fi)-Tx2*sin(fi))*Sa/(I*2*t); %Tangential shear stress in mast above bearings as a function of the angle fi from the x direction oriented clockwise as seen from above
taub= taut + (Ty1*cos(fi)-Tx1*sin(fi))*Sa/(I*2*t); %Tangential shear stress in mast between bearings as a function of the angle fi from the x direction oriented clockwise as seen from above
%tangential loads?
%% Strains
epsilonuz= sigmatotu*1/E; %Normal strain in the z direction as a function of the angle fi from the x direction oriented clockwise as seen from above
epsilonlz=sigmaz/E*ones(length(fi)); %Normal strain at the lower bearing as a function of the angle fi from the x direction oriented clockwise as seen from above
gammao=tauo*1/G; %Tangential shear strain above the bearings
gammab=taub*1/G; %Tangential shear strain betweens the bearings


%% Presentation av resultat 
%yttrekrafter
%x-kraft,y-kraft,z-kraft,x-moment,y-moment,z-moment

Vinge=[Fx, Fy, m*g, 0 , 0 , M] 

Lager2=[Rx2, Ry2,0,  0 , 0 , 0]

Lager1=[Rx1, Ry1, Rz1, 0, 0 ,Mz1]

%Snittstorheter
%x-led
figure
subplot(2,1,1)
Tx1v=Tx1*ones(numel(lm1),1);
plot(lm1,Tx1v)
hold on
Tx2v=Tx2*ones(numel(lm2),1);
plot(lm2,Tx2v)
plot(l1+l2,Tx3,'x')
title('Tx')
xlabel('Avstånd från mastfot [m]')
ylabel('Tvärkraft [N]')
legend('Mellan lager', 'Mellan övre lager och underkant vinge', 'Vingrot')

subplot(2,1,2)
plot(lm1,MBx1)
hold on
plot(lm2,MBx2)
plot(l1+l2,MBx3,'x')
title('MBx')
xlabel('Avstånd från mastfot [m]')
ylabel('Böjande moment [Nm]')
legend('Mellan lager', 'Mellan övre lager och underkant vinge', 'Vingrot')

%y-led
figure
subplot(2,1,1)
Ty1v=Ty1*ones(numel(lm1),1);
plot(lm1,Ty1v)
hold on
Ty2v=Ty2*ones(numel(lm2),1);
plot(lm2,Ty2v)
plot(l1+l2,Ty3,'x')
title('Ty')
xlabel('Avstånd från mastfot [m]')
ylabel('Tvärkraft [N]')
legend('Mellan lager', 'Mellan övre lager och underkant vinge', 'Vingrot')
subplot(2,1,2)
plot(lm1,MBy1)
hold on
plot(lm2,MBy2)
plot(l1+l2,MBy3,'x')
title('MBy')
xlabel('Avstånd från mastfot [m]')
ylabel('Böjande moment [Nm]')
legend('Mellan lager', 'Mellan övre lager och underkant vinge', 'Vingrot')

%Z-led
figure
subplot(2,1,1)
N1v=N1*ones(numel(lm1),1);
plot(lm1,N1v)
hold on
N2v=N2*ones(numel(lm2),1);
plot(lm2,N2v)
plot(l1+l2,N3,'x')
title('N')
xlabel('Avstånd från mastfot [m]')
ylabel('Normalkraft [N]')
legend('Mellan lager', 'Mellan övre lager och underkant vinge', 'Vingrot')

subplot(2,1,2)
Mv1v=Mv1*ones(numel(lm1),1);
plot(lm1,Mv1v)
hold on
Mv2v=Mv2*ones(numel(lm2),1);
plot(lm2,Mv2v)
plot(l1+l2,Mv3,'x')
title('Mv')
xlabel('Avstånd från mastfot [m]')
ylabel('Vridande moment [Nm]')
legend('Mellan lager', 'Mellan övre lager och underkant vinge', 'Vingrot')


%normaltöjningar
figure
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

%skjuvtöjningar
figure
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


