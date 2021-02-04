%

figure(823);clf

t_=[truth_.time];


ax1 = subplot(3,3,1);
plot(t_, [truth_.tws],'.-',...
     t_, [truth_.aws],'.-',...
     t_, r2d([truth_.twd]),'.-',...
     t_, ([truth_.hoists]),'.-');
legend({'tws [m/s]','aws [m/s]','twd [°]','hoist [-]'});     
zoom on;grid on
set(gca,'fontsize',12);
xlabel('time [s]')

ax2 = subplot(3,3,2);
plot(t_, ms2kn([truth_.Vx]),'.-',...
     t_, ms2kn([truth_.Vy]),'.-',...
     t_, ms2kn([truth_.sog]),'.-',...
     t_, [truth_.Pd]/1e6,'.-');
legend({'Vx [kn]','Vy [kn]','sog [kn]','Pd [MW]'});     
zoom on;grid on
set(gca,'fontsize',12);
xlabel('time [s]')

ax3 = subplot(3,3,3);
aoa_ = [Data.rig_aoa];
aoa=aoa_(1,:);
plot( t_, r2d([truth_.rudder]),'.-',...
      t_, r2d([truth_.roll]), '.-',...
      t_, r2d([truth_.leeway]), '.-',...
      t_, r2d(aoa_),'g.-');
legend({'rudder [°]','roll [°]','Leeway [°]','rig aoa [°]'});     
zoom on;grid on
set(gca,'fontsize',12);
xlabel('time [s]');

ax4 = subplot(3,3,4);
sheets=[truth_.sheets];
plot( t_, r2d([truth_.yaw]),   '.-',...
      t_, r2d([truth_.cog]),   '.-',...
      t_, r2d([truth_.awa]),   '.-',...
      t_, r2d(sheets(1,:)), '.-',...
      t_, r2d([truth_.twa]), '.-');
legend({'yaw [°]','cog [°]','awa [°]','rig sheet [°]','twa [°]'});     
zoom on;grid on
set(gca,'fontsize',12);
xlabel('time [s]');

ax5 = subplot(3,3,5);
F_rig = [truth_.F_rig];
plot( t_, [truth_.T]/1e6,'.-',...
      t_, (F_rig(1,:))/1e6,'.-',...
      t_, (F_rig(2,:))/1e6,'.-');
legend({'T        [MN]','Fx rig [MN]','Fy rig [MN]'});     
zoom on;grid on
set(gca,'fontsize',12);
xlabel('time [s]');


ax6 = subplot(3,3,6);
plot([truth_.y],[truth_.x],'.-');
hold on;
plot_Boat([truth_.x],[truth_.y],[truth_.yaw]);
axis equal;
grid on;zoom on;set(gca,'fontsize',12);
xlabel('pos [m]');ylabel('pos [m]');

ax7 = subplot(3,3,7);
sheetRate = [0 diff(sheets(1,:))];
rudderRate = [0 diff([[truth_.rudder]])];
aoa_ = unwrap_pi(sheets(1,:)-[truth_.awa]);
plot( t_, r2d(rudderRate),'.-',...
      t_, r2d([truth_.Rx]),'.-',...
      t_, r2d(sheetRate),'.-',...
      t_, r2d([truth_.Rz]),'.-');
legend({'Rudder rate [°/s]','Roll rate [°/s]','Sheet rate [°/s]','Yaw rate [°/s]'});     
zoom on;grid on
set(gca,'fontsize',12);
xlabel('time [s]');

ax8 = subplot(3,3,8);
linkaxes([ax1,ax2,ax3,ax4,ax5,ax7,ax8],'x');
plot(t_,r2d([truth_.leeway]),t_,r2d([truth_.rudder]),t_,r2d([Data.fin_deflection]),t_,r2d([Data.fin_aoa]),'linewidth',2); 
legend({'leeway','rudder','fin deflection','fin aoa'});
grid on;zoom on

ax8 = subplot(3,3,9);
linkaxes([ax1,ax2,ax3,ax4,ax5,ax7,ax8],'x');
M = [Data.Mz_aero];
F = [Data.F_aero];xcp = M(3,:)./F(2,:); 
aoa_ = [Data.rig_aoa];
aoa  = aoa_(1,:);
plot(t_,r2d(aoa),'.-',t_,xcp,'.-');grid on;zoom on;legend({'Rig aoa','xCP rigs'})





