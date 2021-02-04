%Test Model on Combined Pitch and Plunge Maneuvers
clear all

load ../../../DATA/dns100/models/p00/theop00.mat
theop00 = theoss;
load ../../../DATA/dns100/models/pPL/theopPL.mat
theopPL = theoss;
load('../../../DATA/dns100/models/p00/ROM_E00_da_r7_MN1000_MIMO.mat');
sysA = sysP(2);
sysB = sysP(1);
load('../../../DATA/dns100/models/p00/ROM_E00_da_r7_MN1000.mat');
sysB1 = sysP;
load('../../../DATA/dns100/models/pPL/ROM_E00_dda_r7_MN1000.mat');
sysA1 = sysP;
load('../../../DATA/dns100/models/p00/IR_E00_Ap1_intfC.mat');
fCB = 10*intfC;
load('../../../DATA/dns100/models/pPL/IR_E00_Ap1_intfC.mat');
fCA = -10*intfC;

rP00 = 7;
rPPL = 7;
rMIMO = 7;


S=load('../../../DATA/dns100/runs/p00/negAp1745_a11_2p0_4p0_5p0_7p0_B10_b11_1p0_3p0_4p0_6p0/dt1e-2/ibpm.force');
t = S(:,2)-S(1,2);
DNS = S(:,4);

A = -.1745;
a = 11;
a1 = 2;
a2 = 4;
a3 = 5;
a4 = 7;
B = 10;
b = 11;
b1 = 1;
b2 = 3;
b3 = 4;
b4 = 6;

[uA,duA,dduA] = s_canonicalSUM(A,a,a1,a2,a3,a4,t);
[uB,duB,dduB] = s_canonical(B,b,b1,b2,b3,b4,t);

aeff = uB - atan(duA)*180/pi;


tWAG = t;
fWAGA = s_IRconvolution(fCA,dtC,dduA*180/pi,tWAG,0.);
fWAGB = s_IRconvolution(fCB,dtC,dduB,tWAG,0.);

CLA = lsim(sysA,dduA*(-180/pi),t);
CLB = lsim(sysB,dduB,t);
CLA1 = lsim(sysA1,dduA*(-180/pi),t);
CLB1 = lsim(sysB1,dduB,t);

CLtheoA = lsim(theopPL,dduA,t);
CLtheoB = lsim(theop00,dduB,t);
CLtheo = -CLtheoA + CLtheoB*pi/180;

sysAQS = sysA;
sysAQS.c(1:end-4) = 0.;

sysBQS = sysB;
sysBQS.c(1:end-4) = 0.;

CLAQS = lsim(sysAQS,dduA,t);
CLBQS = lsim(sysBQS,dduB,t);

fig1=figure
subplot(2,1,1)

plot(t,aeff,'k--')
hold on
[AX,H1,H2] = plotyy(t,uB,t,uA,'plot')
set(get(AX(2),'Ylabel'),'String','Vertical Position (chord)','Color',[.45 .45 .45])
set(get(AX(1),'Ylabel'),'String','Angle of Attack (deg)','Color',[0 0 0])
xlabel('Convective Time (\tau=tU/c)')
set(H1,'LineStyle','-','Color',[0 0 0],'LineWidth',1.2);
set(H2,'LineStyle','-','Color',[.45 .45 .45],'LineWidth',1.2);
axis(AX(2),[0 8 -.6 0.1])
axis(AX(1),[0 8 0 25])
set(AX(2),'YTick',[-.5 0.],'YColor',[.45 .45 .45])
set(AX(1),'YTick',[0 10 20],'YColor',[0 0 0])
hold on
grid on
legend('Effective Angle of Attack','Angle of Attack','Vertical Position')


subplot(2,1,2)
plot(t,DNS,'k','LineWidth',1.5)
hold on;
plot(t,CLA+CLB,'--r','LineWidth',1.5); %','Color',[.03 .03 .03])
plot(t,CLtheo,'-','Color',[.6 .6 .6],'LineWidth',.9)
axis([0 8 -.25 2]); grid on
legend('Direct Numerical Simulation','Pitch/Plunge Model, ','Theodorsen Model')
xlabel('Convective Time (\tau=tU/c)')
ylabel('Lift Coefficient (C_L)')
set(fig1,'Position',[100 100 500 400])