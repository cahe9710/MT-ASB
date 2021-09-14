%% Real wind data
clear all; close all; clc;
filename = 'a1_filt_awa_v2.csv';
S = fileread(filename);
NLpos = find(S == sprintf('\n'));
S(1:NLpos(10)) = [];    %delete first 10 lines
S(S==',') = '.';
fmt = repmat('%f', 1, 8);
raw_data = cell2mat( textscan(S, fmt, 'Delimiter', ';'));
filt_data = medfilt1(raw_data(:,2),600);
test_data = rad2deg(filt_data(5000:8600)');
plot(test_data)
title('Anemometer data')
xlabel('Time (s)')
ylabel('Apparent wind angle (o)')
x_data = 0:3600;
x_points = 0:0.01:3600;
test_data = interp1(x_data',test_data,x_points,'pchip');

%% Sine wave awa
clear all; close all; clc;
%%Time specifications:
Fs = 100;                    % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 3600;             % seconds
t = (0:dt:StopTime-dt)';     % seconds
%%Sine wave:
Fc = 0.00028;                     % hertz
sin_awa = 90+30*sin(2*pi*Fc*t);
% Plot the signal versus time:
figure(1);
hold on;
grid on;
plot(t,sin_awa);
xlabel('Time (s)');
ylabel('Apparent wind angle (o)');
title('Sinus wave wind test');
zoom xon;


%%
dt = 1/100;
butterorder=1;
butterfreq=1;  % in Hz for 'high'
[b,a] = butter(butterorder,butterfreq*dt*2,'high');
freqz(b,a)

%% ESC
%clear all, close all, clc

%awa = 60;
u = -80;
%y0 = sail(u,awa);
%y0 = sail(u+10,sin_awa(1)); % Sin test
y0 = sail(u,test_data(1)); % Data test

% Extremum Seeking Control Parameters
freq = 100; % sample frequency
dt = 1/freq;
T = 3600; % total period of simulation (in seconds)

% perturbation parameters
A = 2;  % amplitude
omega = 0.1*2*pi; % 0.10 Hz
phase = 0;
K = 7;   % integration gain

% high pass filter
butterorder=1;
butterfreq=1;  % in Hz for 'high'
[b,a] = butter(butterorder,butterfreq*dt*2,'high');
ys = zeros(1,butterorder+1)+y0;
HPF = zeros(1,butterorder+1);

uhat = u;
for i=1:T/dt
    t = (i-1)*dt;
    time(i) = t;
    %yvals(i) = sail(u,awa);
    %yvals(i) = sail(u+10,sin_awa(i));
    yvals(i) = sail(u,test_data(i));
    
    for k=1:butterorder
        ys(k) = ys(k+1);
        HPF(k) = HPF(k+1);
    end
    ys(butterorder+1) = yvals(i);
    
    HPFnew = 0;
    for k=1:butterorder+1
        HPFnew = HPFnew + b(k)*ys(butterorder+2-k);
    end
    for k=2:butterorder+1
        HPFnew = HPFnew - a(k)*HPF(butterorder+2-k);
    end
    HPFnew = HPFnew/a(1);
    HPF(butterorder+1) = HPFnew;
    
    xi = HPFnew*sin(omega*t + phase);
    %uhat = max(-90,min(uhat + xi*K*dt,90));
    %u = max(-90,min(uhat + A*sin(omega*t + phase),90));
    uhat = uhat + xi*K*dt;
    u = uhat + A*sin(omega*t + phase);
    uhats(i) = uhat;
    uvals(i) = u;    
end

%%

figure(2)
hold on;
plot(time,uvals,'k','LineWidth',1.2)
%uvals = bsxfun(@plus, uvals, 10);
%plot(time,uvals)
grid on
xlabel('Time (s)')
ylabel('Sheeting Angle (o)')
%yline(45, 'r--', 'LineWidth', 2);
l1=legend('$u$','$u^*$');
set(l1,'interpreter','latex','Location','SouthEast')
tit = sprintf('Control signal');
%tit = sprintf('Control signal (%d awa)',awa);
title(tit)

set(gcf,'Position',[100 100 500 350])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../../../figures/ESC_Response');

figure(3)
hold on;
grid on;
plot(time,yvals)
xlabel('Time (s)')
ylabel('Force in bow direction (N)')
%yline(32, 'r--', 'LineWidth', 2);
l1=legend('$y$','$y^*$');
set(l1,'interpreter','latex','Location','SouthEast')
%tit = sprintf('Force measurement (%d awa)',awa);
tit = sprintf('Force measurement');
title(tit)

sum_res = yvals(1:1000:end);
disp(sum(sum_res))
%%
%clear all
for AWA = -180:180
    for SA = -90:90
        Fx = sail(SA,AWA);
        Fx_plot(SA+91,AWA+181) = Fx;
    end
end
[X,Y] = meshgrid(-180:180,-90:90);
%%
load('optimal_val.mat')
figure(4)
s = surf(X,Y,Fx_plot)
s.EdgeColor = 'none';
hold on;
scatter3(sin_awa(10:10:end),uhats(10:10:end),yvals(10:10:end),'.','k')
scatter3(F_awa,F_sa,F_opt,'filled','r')
%scatter3(test_data(10:10:end),uhats(10:10:end),yvals(10:10:end),'.','k')
xlabel('Apparent wind angle (o)')
ylabel('Sheeting Angle (o)')
zlabel('Force in bow direction (N)')
colorbar