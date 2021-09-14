clear all, close all, clc

awa = 90;
u = [60, 60, 60, 60];
sd = sail_dym(u(1),u(2),u(3),u(4),awa);

% Extremum Seeking Control Parameters
freq = 10; % sample frequency
dt = 1/freq;
T = 50; % total period of simulation (in seconds)

% perturbation parameters
A = 2;  % amplitude
omega = 0.1*2*pi; % 0.10 Hz
phase = 0;
K = 1;   % integration gain

% high pass filter
butterorder = 1;
butterfreq = 1;  % in Hz for 'high'
[b,a] = butter(butterorder,butterfreq*dt,'high');
ys = zeros(4,butterorder+1)+sd;
HPF = zeros(4,butterorder+1);

uhat = u;
f = waitbar(0, 'Starting');

for n = 1:2
    print = sprintf('Sail %d',n);
    disp(print)
    for i=1:T/dt
        
        waitbar(i/(T/dt), f, sprintf('Progress: %d %%', floor(i/(T/dt)*100)));
        
        t = (i-1)*dt;
        time(i) = t;
        sd = sail_dym(u(1),u(2),u(3),u(4),awa);

        yvals(n,i) = sd(n);
        yvals(n+2,i) = sd(n+2);
        HPFnew = zeros(4,1);

        for k=1:butterorder
            ys(n,k) = ys(n,k+1);
            ys(n+2,k) = ys(n+2,k+1);
            HPF(n,k) = HPF(n,k+1);
            HPF(n+2,k) = HPF(n+2,k+1);
        end

        ys(n,butterorder+1) = yvals(n,i);
        ys(n+2,butterorder+1) = yvals(n+2,i);

        for k=1:butterorder+1
            HPFnew(n) = HPFnew(n) + b(k)*ys(n,butterorder+2-k);
            HPFnew(n+2) = HPFnew(n+2) + b(k)*ys(n+2,butterorder+2-k);
        end

        for k=2:butterorder+1
            HPFnew(n) = HPFnew(n) - a(k)*HPF(n,butterorder+2-k);
            HPFnew(n+2) = HPFnew(n+2) - a(k)*HPF(n+2,butterorder+2-k);
        end

        HPFnew(n) = HPFnew(n)/a(1);
        HPF(n,butterorder+1) = HPFnew(n);
        HPFnew(n+2) = HPFnew(n+2)/a(1);
        HPF(n+2,butterorder+1) = HPFnew(n+2);

        xi1 = HPFnew(n)*sin(omega*t + phase);
        xi2 = HPFnew(n+2)*sin(omega*t + phase);
        uhat(n) = uhat(n) + (xi1.*K.*dt)';
        uhat(n+2) = uhat(n+2) + (xi2.*K.*dt)';
        u(n) = uhat(n) + A*sin(omega*t + phase);
        u(n+2) = uhat(n+2) + A*sin(omega*t + phase);
        uhats(n,i) = uhat(n);
        uhats(n+2,i) = uhat(n+2);
        uvals(n,i) = u(n);
        uvals(n+2,i) = u(n+2);
    end
end


%%
[sd, rigs, results, k] = sail_plot(u(1),u(2),u(3),u(4),awa);
figure(1)
plotPressure(rigs,results,k+100);
figure(2)
plotForces(rigs,results,k);

figure(3)
plot(time,uvals,'LineWidth',1.2)
legend('u1','u2','u3','u4')
grid on
xlabel('Time(s)')
ylabel('AOA (deg)')
title('Control signal')

set(gcf,'Position',[100 100 500 350])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../../../figures/ESC_Response');

figure(4)
hold on;
grid on;
plot(time,yvals(1,:))
plot(time,yvals(2,:))
plot(time,yvals(3,:))
plot(time,yvals(4,:))
legend('Sail 1','Sail 2','Sail 3','Sail 4')
xlabel('Time(s)')
ylabel('Force in bow direction (N)')
title('Force measurement')