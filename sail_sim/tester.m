for u = 1:1:360 
    [y,rigs,results,k] = sail_dym([u,u,u,u]);
    y_plot(:,u) = y;
    F_plot(u) = results(1).FX;
    disp(u)
end
%%
figure(1)
hold on;
grid on;
plot(y_plot(1,:));
plot(y_plot(4,:));
plot(y_plot(7,:));
plot(y_plot(10,:));
xlabel('AOA (o)')
ylabel('Force in bow direction (N)')
title('Force Spectrum for Individual Sails With 70 deg AWA')
legend('Wing 1','Wing 2','Wing 3','Wing 4','Location','southeast')

figure(2)
hold on;
grid on;
plot(F_plot)
xlabel('AOA (o)')
ylabel('Force in bow direction (N)')
title('Force Spectrum for Combined Sails With 70 deg AWA')