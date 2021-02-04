clear;format compact;
addpath(genpath(pwd));

global settings 

settings.rho_air   = 1.225; % [kg/m3]
settings.D         = 27.0;  % Deck height over sea level (m)

xCPs= [-85 -30 0 30 85]-10;
Nrigs = 5;
for irig=1:Nrigs
  rigs(irig)   = Rig_class(xCPs(irig));
end

aws   = 10; % [m/s]
hoist = 1.0;
awa_  = deg2rad(0:180);


iawa=0;
F_ = zeros(3,length(awa_));
M_ = zeros(3,length(awa_));
for awa = awa_;
  iawa=iawa+1;
  if awa<deg2rad(0.0030);
      trim_(iawa)  = 0; % [m/s]
  else
      trim_(iawa)  = unwrap_pi(awa-deg2rad(12)); % [m/s]
  end
  for irig=1:Nrigs
    trim = trim_(iawa);
   % if irig==5;trim=deg2rad(90);end % Lazyrig
    [f_,m_] = rigs(irig).calcFM(aws,awa,trim,hoist);    
    F_(:,iawa)= F_(:,iawa) + f_;
    M_(:,iawa)= M_(:,iawa) + m_;
  end
end

figure(2345);
plot(rad2deg(awa_),F_(1,:)/1000,'r.-',...
     rad2deg(awa_),F_(2,:)/1000,'b.-',...
     rad2deg(awa_),M_(1,:)/1000/100,'k.-',...
     rad2deg(awa_),M_(3,:)/1000/100,'m.-')
legend({'Fx','Fy','Mx/100','Mz/100'});
grid on, zoom on;
xlabel('awa [deg]')
hold on








