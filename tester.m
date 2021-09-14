%% Test 1
clear all; close all;
T = 500;
wind = 0;
r = 1:T;
rand = randsample(r,1);
for time = 1:T
    if time == rand
        wind_change = -10:10;
        wind = randsample(wind_change,1);
    end
    awa = 130 + wind;
    awa_plot(time) = awa; 
end
sigmas = 0.001 * awa_plot;
randomNoise = randn(length(awa_plot), 1)' .* sigmas;
output = awa_plot + randomNoise;
plot(output)
%%
clear all
for AWA = -180:180
    for SA = -90:90
        Fx = sail(SA,AWA);
        Fx_plot(SA+91,AWA+181) = Fx;
    end
end

for idx = -180:180
    [val, index] = max(Fx_plot(:,idx+181));
    F_opt(idx+181) = val;
    F_sa(idx+181) = index-90;
end
F_awa = -180:180;
[X,Y] = meshgrid(-180:180,-90:90);
save('optimal_val.mat','F_opt','F_sa','F_awa')
%%
load('rew_data_ppo.mat')
load('sa_data_ppo.mat')
load('awa_data_ppo.mat')
s = surf(X,Y,Fx_plot)
s.EdgeColor = 'none';
hold on;
scatter3(awa_plot,sa_plot,reward_history,'filled','k')
scatter3(F_awa,F_sa,F_opt,'filled','r')
xlabel('Apparent wind angle (o)')
ylabel('Sheeting Angle (o)')
zlabel('Force in bow direction (N)')
colorbar

%%
clear all
AWA = 150;
for SA = 0:90
    Fx_plot(SA+1) = sail(SA,AWA);
end
x = 0:90;
[m_sing,i_sing] = max(Fx_plot);
figure(1)
hold on; grid on;
plot(x,Fx_plot,'k')
scatter(i_sing,m_sing,'filled','k')
txt = num2str(i_sing);
text(i_sing-1,m_sing-2,cellstr(txt));
xlabel('Sheeting Angle (o)')
ylabel('Force in bow direction (N)')
tit = sprintf('Optimal sheeting angle for %d deg AWA',AWA);
title(tit)
%%
clear all; close all;
awa = 140;
u1 = 0;
u2 = 0;
u3 = 0;
u4 = 0;
for n = 1:4
    for u = 0:90
        if n == 1
            u1 = u;
            y = sail_dym(u1,u2,u3,u4,awa);
            y_plot(1,u+1) = y(1);
        elseif n == 2
            u2 = u;
            y = sail_dym(u1,u2,u3,u4,awa);
            y_plot(2,u+1) = y(2);
        elseif n == 3
            u3 = u;
            y = sail_dym(u1,u2,u3,u4,awa);
            y_plot(3,u+1) = y(3);
        elseif n == 4
            u4 = u;
            y = sail_dym(u1,u2,u3,u4,awa);
            y_plot(4,u+1) = y(4);
        end
    end
end
%%
[m1,i1] = max(y_plot(1,:));
[m2,i2] = max(y_plot(2,:));
[m3,i3] = max(y_plot(3,:));
[m4,i4] = max(y_plot(4,:));
figure(1)
x = 0:90;
hold on;
grid on;
plot(x,y_plot(1,:),'k');
plot(x,y_plot(2,:),'y');
plot(x,y_plot(3,:),'g');
plot(x,y_plot(4,:),'r');
scatter(i1,m1,'filled','k');
scatter(i2,m2,'filled','y');
scatter(i3,m3,'filled','g');
scatter(i4,m4,'filled','r');
txt1 = num2str(i1);
txt2 = num2str(i2);
txt3 = num2str(i3);
txt4 = num2str(i4);
text(i1+4,double(m1+20),cellstr(txt1));
text(i2+4,double(m2+20),cellstr(txt2));
text(i3+4,double(m3+20),cellstr(txt3));
text(i4+4,double(m4),cellstr(txt4));
xlabel('Sheeting Angle (o)')
ylabel('Force in bow direction (N)')
tit = sprintf('Optimal sheeting angle for %d deg AWA',awa);
title(tit)
legend('Wing 1','Wing 2','Wing 3','Wing 4','Location','southeast')

% figure(2)
% hold on;
% grid on;
% plot(F_plot)
% xlabel('AOA (o)')
% ylabel('Force in bow direction (N)')
% title('Force Spectrum for Combined Sails With 70 deg AWA')

%%
for AWA = -180:180
    for SA = -90:90
        Fx = sail(SA+10,AWA);
        Fx_plot(SA+91,AWA+181) = Fx;
    end
end
[X,Y] = meshgrid(-180:180,-90:90);
%%
% load('sa_plot_ppo.mat')
% load('awa_plot_ppo.mat')
% load('reward_history_ppo.mat')
load('sa_data_ppo.mat')
load('awa_data_ppo.mat')
load('rew_data_ppo.mat')
figure(4)
s = surf(X,Y,Fx_plot)
s.EdgeColor = 'none';
hold on;
%scatter3(sin_awa(10:10:end),uhats(10:10:end),yvals(10:10:end),'.','k')
%scatter3(F_awa,F_sa,F_opt,'filled','r')
%scatter3(awa_plot,sa_plot,reward_history,'.','k')
xlabel('Apparent wind angle (o)')
ylabel('Sheeting Angle (o)')
zlabel('Force in bow direction (N)')
colorbar

%%
u = 15;

[sd, rigs, results, k] = sail_plot(u,u,u,u,60);

figure(1)
plotForces(rigs,results,k);

figure(2)
plotPressure(rigs,results,k+100);
