function acc   = EOM(F,M)
% Calculate the acceleration in all DOFs based on the loads
% Get ship main particulars and hydrodynamic coefficients
global settings
run(settings.ShipData);
rho_water = settings.rho_water;
mass      = displ*rho_water;

B = [((mass)-X_up*0.5*rho_water*L^3) 0                                      0                                     0
                 0                  ((mass)-(Y_vp*0.5*rho_water*L^3))      -((mass*v_cg)-(Y_pp*0.5*rho_water*L^4)) ((mass*l_cg)-(Y_rp*0.5*rho_water*L^4))
                 0                 -((mass*v_cg)-(K_vp*0.5*rho_water*L^4))  (Ix-(K_pp*0.5*rho_water*L^5))               0
                 0                  ((mass*l_cg)-(N_vp*0.5*rho_water*L^4))  0                                     (Iz-(N_rp*0.5*rho_water*L^5))];

FM = [F(1);F(2);M(1);M(3)];

acc = B\FM; % [Vx_p,  Vy_p,  Rx_p,  Rz_p] 



