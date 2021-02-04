% Function test
rho = 1.225; % kg/m^3
v = 5; % m/s
A = 0.85*2.7; % m^2

alfa = -pi:0.01:pi; 
[cl,cd,cm] = naca0018(alfa);

figure(1); 
plot(rad2deg(alfa),cl,'g',rad2deg(alfa),cd,'r');
xlabel('Wind Angle (deg)')
ylabel('Aerodynamic Coefficients')
legend({'Lift','Drag'},'Location','Southwest')
grid on;
zoom on;

% Forces action on sail
L = 0.5*rho*v^2*A*cl;
D = 0.5*rho*v^2*A*cd;
R = sqrt(L.^2+D.^2);

figure(2); 
plot(rad2deg(alfa),L,'g',rad2deg(alfa),D,'r',rad2deg(alfa),R,'m');
xlabel('Wind Angle (deg)')
ylabel('Force (N)')
legend({'Lift','Drag','Resultant Force'},'Location','Southwest')
grid on;
zoom on;

% Load and strain on sail root
rootA = 2*pi*0.35*0.85; % m^2
l = 2.2; % m

F = R*l;
S = F*rootA;

figure(3); 
plot(rad2deg(alfa),S,'g');
xlabel('Wind Angle (deg)')
ylabel('Stress (N/m^2)')
legend({'Stress'},'Location','Southwest')
grid on;
zoom on;

