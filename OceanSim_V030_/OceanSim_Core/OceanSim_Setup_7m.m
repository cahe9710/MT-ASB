
fprintf('Christiane 7m.\n');

% Global settings
settings.ShipData         = 'ShipData_7m'; % Ship data file
settings.ResData          = 'ResistanceData_7m'; % Ship's resistance data file
settings.D                = 0.9148; % [m] Deck height over sea level
settings.Pd_installed     = 5e3;    % [W] Installed engine power
settings.Nrigs            = 4;      % [Nos] Number of rig
settings.Rig_H            = 2.5411; % [m] Height of a rig
settings.Rig_area         = 1.7220; % [m2] Area of a rig
settings.RigPos           = [-2.06351 -0.62386 0.81579 2.25544]; % [m] Positions of rigs from amidships (fwd+/aft-)
settings.seaMargin       = 0.0 ; % [-] Drag factor on resistance

% Power/Engine settings
Pd_pid                    = PID_class([3e3,5,0],0,settings.Pd_installed); % Thrus PID controller with ([Kp,Ki,Kd] min  max)
Pd_servo                  = Servo_class(0,settings.Pd_installed,settings.Pd_installed/120); % Thrust servo with (min, max, rate )

% Rudder settings
yaw_pid_X                 = PID_class([0.8,0.01,2],d2r(-40),d2r(40)); % PID controller with ([Kp,Ki,Kd] min  max)
rudderServo               = Servo_class(d2r(-40),d2r(40),d2r(5)); % Rudder servo (min, max, rate [rad/s])

% Fins settings
fins                      = struct('Nfins',2,'Cr',0.0966,'Ct',0.0966,'semispan',0.0080,'x',1.3553,'y',0.5591,'z',0.1186,'tilt',deg2rad(20),'max_aoa',deg2rad(15),'gain',0.0);

% The truth :-)
truth             = setup_truth(settings.Nrigs);  % Create the structured data container
truth.windFile    = 'OceanSim_default_Wind'; % 
truth.Vx          = kn2ms(1.5); % m/s
truth.sheets      = zeros(settings.Nrigs,1);
truth.hoists      = ones(settings.Nrigs,1);

% Control settings
ctrlSettings.course = struct('mode','cog','val',d2r(0),'err',0);   % Mode of controll: COG where the target course is d2r(x) degrees
ctrlSettings.speed  = struct('mode','sog','val',kn2ms(0),'err',0); % Mode of controll: SOG where the target speed is kn2ms(x) knots
ctrlSettings.rig    = struct('mode','aoa','val',d2r(0),'err',0);   % Mode of controll: AWA where the target course is d2r(x) degrees

% Mission settings
settings.missionFile    = 'OceanSim_default_Mission_7m'; % Specify mission

anemometer = Anemometer_class();
dvl        = DVL_class();
gnss       = GNSS_AHRS_class();

% Rig settings
clear rigs_pids rigs_TrimServos rigs
for ii = 1:settings.Nrigs
    rigs_pids(ii)           = PID_class([1,0,0],d2r(-360*4),d2r(360*4)); % PID controller with ([Kp,Ki,Kd] min  max)
    rigs_TrimServos(ii)     = Servo_class(d2r(-360*4),d2r(360*4),d2r(5)); % Rig servo (min, max, rate [rad/s])
    rigs(ii)                = Rig_class(settings.RigPos(ii),settings.Rig_H,settings.Rig_area); % Rig position, height and area
end

dt    = 0.1;    % [s] Time step
Nt    = 5000;   % [-] Number of time steps to integrate
it    = 0;      % [-] Loop counter

% Now we are ready to run :-)