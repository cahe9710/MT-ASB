
fprintf('Oceanbird 200m.\n');

% Global settings
settings.ShipData        = 'ShipData_200m'; % Ship data file
settings.ResData         = 'ResistanceData_200m'; % Ship's resistance data file
settings.D               = 27.0;  % [m] Deck height over sea level
settings.Pd_installed    = 8e6;   % [W] Installed engine power
settings.Nrigs           = 5;     % [Nos] Number of rigs
settings.Rig_H           = 75;    % [m] Height of a rig
settings.Rig_area        = 1500;  % [m2] Area of a rig
settings.RigPos          = [-90 -50 -10 30 70]; % [m] Positions of rigs from amidships (fwd+/aft-)
settings.seaMargin       = 0.05 ; % [-] Drag factor on resistance

% Power/Engine settings
Pd_pid          = PID_class([10e6,5000,0.5e6],0,settings.Pd_installed);       % Thrus PID controller with ([Kp,Ki,Kd] min  max)
Pd_servo        = Servo_class(0,settings.Pd_installed,settings.Pd_installed/(10*60)); % Thrust servo with (min, max, rate )

% Rudder settings
yaw_pid_X       = PID_class([0.6,0.01,20],d2r(-35),d2r(35));     % PID controller with ([Kp,Ki,Kd] min  max)
rudderServo     = Servo_class(d2r(-35),d2r(35),d2r(4.8));        % Rudder servo (min, max, rate [rad/s])

% Fins settings
fins            = struct('Nfins',2,'Cr',2.85,'Ct',2.85,'semispan',7,'x',40,'y',16.5,'z',3.5,'tilt',deg2rad(20),'max_aoa',deg2rad(15),'gain',0.0);

% The truth :-)
truth             = setup_truth(settings.Nrigs);  % Create the structured data container
truth.windFile    = 'OceanSim_default_Wind'; % 
truth.Vx          = kn2ms(2.0); % m/s
truth.sheets      = zeros(settings.Nrigs,1);
truth.hoists      = ones(settings.Nrigs,1);

ctrlSettings.course = struct('mode','cog','val',d2r(0),'err',0);   % Mode of controll: COG where the target course is d2r(x) degrees
ctrlSettings.speed  = struct('mode','sog','val',kn2ms(0),'err',0); % Mode of controll: SOG where the target speed is kn2ms(x) knots
ctrlSettings.rig    = struct('mode','aoa','val',d2r(0),'err',0);   % Mode of controll: AWA where the target course is d2r(x) degrees

% Mission settings
settings.missionFile    = 'OceanSim_default_Mission_200m'; % Specify mission

anemometer = Anemometer_class();
dvl        = DVL_class();
gnss       = GNSS_AHRS_class();

for ii = 1:settings.Nrigs
    rigs_pids(ii)       = PID_class([1,0,0],d2r(-360*4),d2r(360*4));     % PID controller with ([Kp,Ki,Kd] min  max)
    rigs_TrimServos(ii) = Servo_class(d2r(-360*4),d2r(360*4),d2r(1.25));  % Rig servo (min, max, rate [rad/s])
    rigs(ii)            = Rig_class(settings.RigPos(ii),settings.Rig_H,settings.Rig_area); % Rig position, height and area
end

dt    = 1;      % [s] Time step
Nt    = 3600;   % [-] Number of time steps to integrate
it    = 0;      % [-] Loop counter

% Now we are ready to run :-)
