clear all
close all
clc
load testSys

%% Obtain impulse response of full system
[yFull,t] = impulse(sysFull,0:1:(r*5)+1);  
YY = permute(yFull,[2 3 1])

%% compute random input simulation for OKID
uRandom = randn(numInputs,200);  % random forcing input
yRandom = lsim(sysFull,uRandom,1:L)';  % output of random forcing
yRandom = yRandom+0.*rand(size(yRandom));  % (optional) add noise

%% Compute ERA from impulse response
mco = floor((length(yFull)-1)/2);  % m_c = m_o
[Ar,Br,Cr,Dr,HSVs] = ERA(YY,mco,mco,numInputs,numOutputs,r);
sysERA = ss(Ar,Br,Cr,Dr,-1);

%% Compute OKID and then ERA
[H,M] = OKID(yRandom,uRandom,r);
mco = floor((length(H)-1)/2);  % m_c = m_o
[Ar,Br,Cr,Dr,HSVs] = ERA(H,mco,mco,numInputs,numOutputs,r);
sysERAOKID = ss(Ar,Br,Cr,Dr,-1);



%% Plot impulse responses for all methods
figure
[y1,t1] = impulse(sysFull,0:1:200);
% h = findobj(gcf,'type','line');
% set(h,'linewidth',2);
% [y2,t2] = impulse(sysBT,0:1:100,'r')
[y3,t3] = impulse(sysERA,0:1:100);
[y4,t4] = impulse(sysERAOKID,0:1:100);
% [y5,t5] = impulse(sysBPOD,0:1:100,'m--')
subplot(2,2,1)
stairs(y1(:,1,1),'LineWidth',2);
hold on
% stairs(y2(:,1,1),'r','LineWidth',1.2);
stairs(y3(:,1,1),'LineWidth',1.2);
stairs(y4(:,1,1),'LineWidth',1.);
% stairs(y5(:,1,1),'m--','LineWidth',1.);
set(gca,'XLim',[0 60]);
grid on
subplot(2,2,2)
stairs(y1(:,1,2),'LineWidth',2);
hold on
% stairs(y2(:,1,2),'r','LineWidth',1.2);
stairs(y3(:,1,2),'LineWidth',1.2);
stairs(y4(:,1,2),'LineWidth',1.);
% stairs(y5(:,1,2),'m--','LineWidth',1.);
set(gca,'XLim',[0 60]);
grid on
subplot(2,2,3)
stairs(y1(:,2,1),'LineWidth',2);
hold on
% stairs(y2(:,2,1),'r','LineWidth',1.2);
stairs(y3(:,2,1),'LineWidth',1.2);
stairs(y4(:,2,1),'LineWidth',1.);
% stairs(y5(:,2,1),'m--','LineWidth',1.);
set(gca,'XLim',[0 60]);
grid on
subplot(2,2,4)
stairs(y1(:,2,2),'LineWidth',2);
hold on
% stairs(y2(:,2,2),'r','LineWidth',1.2);
stairs(y3(:,2,2),'LineWidth',1.2);
stairs(y4(:,2,2),'LineWidth',1.);
% stairs(y5(:,2,2),'m--','LineWidth',1.);
set(gca,'XLim',[0 60]);
grid on
legend('Full model, n=100',['ERA, r=',num2str(r)],['ERA/OKID, r=',num2str(r)])
set(gcf,'Position',[100 100 550 350])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/FIG_ERA_IMPULSE');

% %%
% %% plot input/output pair for OKID
% figure
% subplot(1,2,1)
% title('Inputs')
% stairs(uRandom(1,:),'k')
% hold on
% stairs(uRandom(2,:),'r')
% legend('In(1)','In(2)')
% % xlabel('Time')
% % ylabel('Amplitude')
% subplot(1,2,2)
% title('Outputs')
% stairs(yRandom(1,:),'k')
% hold on
% stairs(yRandom(2,:),'r')
% legend('Out(1)','Out(2)')
% % xlabel('Time')
% % ylabel('Amplitude')
% set(gcf,'Position',[100 100 650 200])