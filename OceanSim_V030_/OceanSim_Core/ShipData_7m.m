
% This Matlab function was automatically generated from the Seaman mathematical model documentation using 
% date:2020-05-28 09:31:09.312280
% version GIT hash:074305e4e5abd1d5c96ead56fd24f211ddc8c338
%The ship specific data

%Static data
lambda = 7/206.6;
Ls     = 206.6;                         % Ship length (m)
L      = Ls*lambda;                     % Model length (m)
Bs     = 39.4;                          % Beam of ship (m)
B      = Bs*lambda;                     % Beam of model (m)
Cb     = 0.4463;                        % Block coefficient
GMT    = 0.457;                         % Transverse metacentric height of model (m)
v_cg   = 0.285-0.341;                   % VCG of model (m)
l_cg   = -0.098;                        % LCG of model (m)
displ  = 30843*lambda^3;                % Model volume (m3)
t_a    = 8.5*lambda;                    % Draft aft of model (m)
t_f    = 8.5*lambda;                    % Draft fwd of model (m)
Ts     = (t_f+t_a)/2;                   % Mean draft of the full scale ship (m)
xx_rud = -99.3972*lambda;               % Rudder x-coordinate (m) (see coordinate system in doc)
zz_rud = -4.73*lambda;                  % Rudder z-coordinate (m) (see coordinate system in doc)
Kx     = 0.35*B;                        % [m] Roll radius of gyration of model (from standards)
Kz     = 0.25*L;                        % [m] Yaw radius of gyration of model (from standards)
Ix     = displ*settings.rho_water*Kx^2; % [kg.m^2] Mass moment of inertia relative to longitudinal axis
Iz     = displ*settings.rho_water*Kz^2; % [kg.m^2] Mass moment of inertia relative to vertical axis 
Area_hullAero = 1229*lambda^2;          % [m2] Area of the hull above water

%% Manouevering coefficients from captive test/captive CFD
%(See report RI40199079-06-00-C)
X_vv      = 0.3165403328508938;
X_vr      = -0.7561041975284462;
X_rr      = 0.14555022913464027;
X_up      = -(-0.11+(0.288*Cb)); % from PNA

Y_uv      = -0.48387500079351975;
Y_uuv     = -0.2473079688507695;
Y_ur      = 0.3730151035308007;
Y_uur     = -0.015591274093520128;
Y_vp      = -pi*((Ts/L)^2)*(1+((0.16*Cb)*(B/Ts))-(5.1*(B/L)^2)); % from PNA
Y_rp      = -pi*((Ts/L)^2)*((0.67*(B/L))-(0.0033*(B/Ts)^2)); % from PNA
Y_pp      = -0.0003; % by Pahansen

K_ur      = -0.015638917383583157;
K_uur     = -0.004034796117;
K_uv      = 0.0682927333180879;
K_uuv     = 0.0;
K_up      = -0.004768579945;
% K_p       = -0.001362464518; % from SSPA
K_p       = -0.03; % by Pahansen
K_vav     = -0.021341786514578416;
K_rar     = -0.03; % by Pahansen
K_pap     = -0.03; % by Pahansen
K_vp      = -0.0001; % by Pahansen
K_pp      = -0.0002; % by Pahansen

N_uv      = -0.3513350929759401;
N_uuv     = 0.7359739937284021;
N_ur      = -0.15876282539676165;
N_uur     = -0.22883612636117082;
N_vp      = -pi*((Ts/L)^2)*((1.1*(B/L))-(0.041*(B/Ts))); % from PNA
N_rp      = -pi*((Ts/L)^2)*((1/12)+((0.017*Cb)*(B/Ts))-(0.33*(B/L))); % from PNA

C_d       = 1.006913891514737; 
Cd_lever  = 0.14419024272262476; %Note that this is now nondimensional

Y_uudelta = 0.4819160912214051;
X_Yrdelta = -0.41561253422927225;
s         = -0.8;
n_rud     = 2;

Y_Tdelta  = 0.1267337851714087; %only if working propeller
k_r       = 0.5; 
k_v       = -0.5;

