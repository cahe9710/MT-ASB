clear all, close all, clc

u = [45, 45, 45, 45];
sd = sail_dym(u);
y0 = zeros(4,1);

f = 1;
for j = 1:3:12 
    y0(f) = sd(j);
    f = f+1;
end

% Extremum Seeking Control Parameters
freq = 10; % sample frequency
dt = 1/freq;
T = 50; % total period of simulation (in seconds)

% perturbation parameters
A = 2;  % amplitude
omega = 1*2*pi; % 1 Hz
phase = 0;
K = 2;   % integration gain

% high pass filter
butterorder = 1;
butterfreq = 2;  % in Hz for 'high'
[b,a] = butter(butterorder,butterfreq*dt*2,'high');
ys = zeros(4,butterorder+1)+y0;
HPF = zeros(4,butterorder+1);

uhat = u;

for i=1:T/dt
    t = (i-1)*dt;
    time(i) = t;
    disp(t)
    sd = sail_dym(u);
    f = 1;
    for j = 1:3:12 
        y_dym(f) = sd(j);
        f = f+1;
    end
    
    yvals(:,i) = y_dym;
    HPFnew = zeros(4,1);

    for n = 1:4
        for k=1:butterorder
            ys(n,k) = ys(n,k+1);
            HPF(n,k) = HPF(n,k+1);
        end

        ys(n,butterorder+1) = yvals(n,i);

        for k=1:butterorder+1
            HPFnew(n) = HPFnew(n) + b(k)*ys(n,butterorder+2-k);
        end

        for k=2:butterorder+1
            HPFnew(n) = HPFnew(n) - a(k)*HPF(n,butterorder+2-k);
        end

        HPFnew(n) = HPFnew(n)/a(1);
        HPF(n,butterorder+1) = HPFnew(n);
    end
    
    for r = 1:2
        xi = HPFnew(r)*sin(omega*t + phase);
        uhat(r) = uhat(r) + (xi.*K.*dt)';
        u(r) = uhat(r) + A*sin(omega*t + phase);
        uhats(r,i) = uhat(r);
        uvals(r,i) = u(r);
        
        xi = HPFnew(r+2)*sin(omega*t + phase);
        uhat(r+2) = uhat(r+2) + (xi.*K.*dt)';
        u(r+2) = uhat(r+2) + A*sin(omega*t + phase);
        uhats(r+2,i) = uhat(r+2);
        uvals(r+2,i) = u(r+2);   
    end
end

[sd,rigs,results,k] = sail_dym(u);

%%
figure(1)
plot(time,uvals,time,uhats,'LineWidth',1.2)
legend('u1','u2','u3','u4')
grid on
xlabel('Time(s)')
ylabel('AOA (deg)')

set(gcf,'Position',[100 100 500 350])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../../../figures/ESC_Response');

figure(2)
hold on;
grid on;
plot(time,yvals(1,:))
plot(time,yvals(2,:))
plot(time,yvals(3,:))
plot(time,yvals(4,:))
legend('Sail 1','Sail 2','Sail 3','Sail 4')
xlabel('Time(s)')
ylabel('Force in bow direction (N)')

% figure(3)
% plotPressure(rigs,results,k+100);
% figure(4)
% plotForces(rigs,results,k);