
% This Matlab function was automatically generated from the Seaman mathematical model documentation using 
% Python package Sympy.
% date:2020-05-28 09:31:12.031878
% version GIT hash:074305e4e5abd1d5c96ead56fd24f211ddc8c338

function result = X_function(delta, u_w, v_w, r_w, s, T, X_res, X_vv, X_rr, X_vr, X_Yrdelta, Y_Tdelta, Y_uudelta, k_r, k_v, Y_uv, Y_uuv, Y_ur, Y_uur, C_d, t_a, t_f, displ, rho, L, g, xx_rud, l_cg, n_rud)
result = (7.28.*T.*delta.^2.*u_w.*X_Yrdelta.*Y_Tdelta.*n_rud./sqrt(L.*g) + T.*delta.^2.*X_Yrdelta.*Y_Tdelta.*n_rud + T + X_res + delta.^2.*u_w.^2.*X_Yrdelta.*Y_uudelta.*n_rud.*displ.*rho./L + delta.*l_cg.*r_w.*u_w.*X_Yrdelta.*Y_uudelta.*k_r.*n_rud.*displ.*rho.*sqrt(g./L)./sqrt(L.*g) - delta.*r_w.*u_w.*xx_rud.*X_Yrdelta.*Y_uudelta.*k_r.*n_rud.*displ.*rho.*sqrt(g./L)./sqrt(L.*g) + delta.*u_w.*v_w.*X_Yrdelta.*Y_uudelta.*k_v.*n_rud.*displ.*rho./L + r_w.^2.*X_rr.*L.*displ.*rho + r_w.*v_w.*X_vr.*L.*displ.*rho.*sqrt(g./L)./sqrt(L.*g) + v_w.^2.*X_vv.*displ.*rho./L);