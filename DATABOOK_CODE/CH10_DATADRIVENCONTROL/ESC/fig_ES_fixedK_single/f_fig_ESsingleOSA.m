clear all
clc

load ES_RTL1p5_singleC_dat.mat %  (*** BEST ***)


dt = .02;
T = 30;
% T = length(yvals)*dt;
L = T/dt;
tmin = -1;

time = dt:dt:T;

figure
subplot(5,1,1:3)
[AX,H1,H2] = plotyy(time(1:L),yvals(1:L),time(1:L),energies(1:L),'plot');
set(get(AX(2),'Ylabel'),'String','Energy','Color',[.4 .4 .4]);
set(get(AX(1),'Ylabel'),'String','Objective function','Color',[0 0 0]);
set(H1,'LineStyle','-','Color',[0 0 0],'LineWidth',1.5);
set(H2,'LineStyle','-','Color',[.4 .4 .4],'LineWidth',1.5);
axis(AX(2),[tmin T 1.5 4.5]);
axis(AX(1),[tmin T .15 .23]);
set(AX(2),'YTick',[2 3.8],'YColor',[.4 .4 .4]);
set(AX(1),'YTick',[.16 .223],'YColor',[0 0 0]);
% plot(time(1:L),yvals(1:L),'k')
% axis([tmin T 0.15 .25])
set(AX(1),'xticklabel',[])
set(AX(2),'xticklabel',[])
grid on
subplot(5,1,4:5)
plot(time(1:L),allavals(4,1:L)*180/pi,'k','LineWidth',1.5)
ylabel('\alpha_p (deg)')
axis([tmin T 83 89])
grid on
xlabel('Time (s)')
set(gcf,'Position',[100 100 325 250])