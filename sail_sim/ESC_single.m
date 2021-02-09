clear all, close all, clc

u = [0, 0, 0, 0];
sd = sail_dym(u);
y0 = zeros(4,1);

f = 1;
for j = 1:3:12 
    y0(f) = sd(j);
    f = f+1;
end

% Extremum Seeking Control Parameters
freq = 100; % sample frequency
dt = 1/freq;
T = 10; % total period of simulation (in seconds)

% perturbation parameters
A = .2;  % amplitude
omega = 10*2*pi; % 10 Hz
phase = 0;
K = 5;   % integration gain

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
        
    xi = HPFnew.*sin(omega*t + phase);
    uhat = uhat + (xi.*K.*dt)';
    u = uhat + [A*sin(omega*t + phase), A*sin(omega*t + phase), A*sin(omega*t + phase), A*sin(omega*t + phase)];
    uhats(:,i) = uhat;
    uvals(:,i) = u;    
end

%%
figure
subplot(2,1,1)
plot(time,uvals,time,uhats,'LineWidth',1.2)
l1=legend('$u$','$\hat{u}$')
set(l1,'interpreter','latex','Location','NorthWest')
grid on
subplot(2,1,2)
plot(time,yvals,'LineWidth',1.2)
ylim([-1 26])
grid on

set(gcf,'Position',[100 100 500 350])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../../../figures/ESC_Response');