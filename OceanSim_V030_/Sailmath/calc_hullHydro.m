function [F,M] = calc_hullHydro(u_w,v_w,p,r_w,roll,delta,T,X_res)
% This function computes hydrodynamic forces acting on the hull
global settings data

run(settings.ShipData); % Call ship main particulars and hydrodynamic derivatives

% Surge
Fx = X_function(delta, u_w, v_w, r_w, s, T, X_res, X_vv, X_rr, X_vr,...
    X_Yrdelta, Y_Tdelta, Y_uudelta, k_r, k_v, Y_uv, Y_uuv, Y_ur, Y_uur,...
    C_d, t_a, t_f, displ, settings.rho_water, L, settings.g, xx_rud, l_cg, n_rud)+... % Hydrodynamic hull and rudder forces
    (displ*settings.rho_water*(v_w*r_w + l_cg*r_w^2)); % Adding the rigid-body part

% Sway
Fy = Y_function(delta, u_w, v_w, r_w, s, T, Y_Tdelta, Y_uudelta,...
    k_r, k_v, Y_uv, Y_uuv, Y_ur, Y_uur, C_d, t_a, t_f, displ, settings.rho_water, L,...
    settings.g, xx_rud, l_cg, n_rud)-... % Hydrodynamic hull and rudder forces
    (displ*settings.rho_water*u_w*r_w); % Adding the rigid-body part

% Heave
Fz = 0;

% Roll
Mx = K_function(delta, u_w, v_w, r_w, p, s, T, Y_Tdelta, Y_uudelta,...
    k_r, k_v, K_ur, K_uur, K_uv, K_uuv, K_up, K_p, K_vav, K_rar, K_pap,...
    zz_rud, t_a, displ, settings.rho_water, L, settings.g, xx_rud, l_cg, n_rud)+...% Hydrodynamic hull and rudder moments
    (displ*settings.rho_water*v_cg*u_w*r_w)-(displ*settings.rho_water*settings.g*GMT*roll); % [Nm]Static rightening moment

% Pitch
My = 0;

% Yaw
Mz = N_function(delta, u_w, v_w, r_w, s, T, Y_Tdelta, Y_uudelta,...
    k_r, k_v, N_uv, N_uuv, N_ur, N_uur, C_d, t_a, t_f, displ, settings.rho_water, L,...
    settings.g, xx_rud, l_cg, n_rud, Cd_lever)-... % Hydrodynamic hull and rudder moments
    (displ*settings.rho_water*l_cg*u_w*r_w); % Adding the rigid-body part

F = [Fx;Fy;Fz];
M = [Mx;My;Mz];
end

