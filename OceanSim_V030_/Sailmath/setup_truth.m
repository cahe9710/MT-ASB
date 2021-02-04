function truth = setup_truth(Nrigs)
truth.time          = 0;
truth.x             = 0;              % [m] X-position in global co-ordinate system
truth.y             = 0;              % [m] Y-position in global co-ordinate system
truth.Vx            = kn2ms(5);       % [m/s] Surge velocity (in local co-ordinate system)
truth.Vy            = 0;              % [m/s] Sway velocity (in local co-ordinate system)
truth.Rx            = 0;              % [rad/s] Roll velocity
truth.Rz            = 0;              % [rad/s] Yaw velocity
truth.roll          = deg2rad(0);     % [rad] Roll angle
truth.yaw           = d2r(0);         % [rad] Yaw angle
truth.sog           = 0;              % [m/s] Speed over ground
truth.cog           = 0;              % [rad] Course over ground
truth.leeway        = 0;              % [rad] Leeway angle, Positive
truth.T             = 0;              % [N]   Engine thrust
truth.Pd            = 0;              % [W]   Power delivered to propeller
truth.rudder        = 0;              % [rad] Rudder angle
truth.sheets        = zeros(Nrigs,1); % [rad] Sheet angle
truth.hoists        = ones(Nrigs,1);  % Range 0.25 - 1.00   % [1.0 0.3 0.4 0.8 0.9]'
truth.tws           = 0;              % [m/s] True wind speed
truth.twd           = 0;              % [rad] Where it is heading from = To-direction
truth.aws           = 0;              % [m/s] Apparent wind speed
truth.awa           = 0;              % [rad] Apparent wind angle
truth.twa           = 0;              % [rad] True wind angle
truth.acc           = [0;0;0;0];      % [m/s2] Accelerations [surge;sway;roll;yaw]
truth.F             = [0;0;0;0];      % [N]   Sum of all forces
truth.M             = [0;0;0;0];      % [Nm] Sum of all Moments
truth.windFile      = '';
truth.autopilotFile = '';
truth.g             = 9.81;
truth.rho_water     = 1024;           % [kg/m3]
truth.rho_air       = 1.2;            % [kg/m3]
