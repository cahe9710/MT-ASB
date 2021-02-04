%------------------------------------------------------
fprintf('Wind generator file : "%s" \n',truth.windFile);
fprintf('Mission file        : "%s" \n',settings.missionFile);
fprintf('\n          0--------10--------20--------30--------40--------50--------60--------70--------80--------90--------100%% \n');
fprintf(  'progress:  ');
tic;
% Loop
while it<=Nt
  it    = it+1;            % Counter
  truth = update_truth(truth); % Calc wind, leeway etc
  dvl.sense(truth);            % Measure the truth using sensors
  gnss.sense(truth);           % Measure the truth using sensors
  anemometer.sense(truth);     % Measure the truth using sensors
  
  ctrlSettings = eval(strcat(settings.missionFile,'(truth.time,ctrlSettings,dvl,gnss,anemometer)'));
  ctrlSettings = update_controllers(ctrlSettings,dvl,gnss,anemometer,rudderServo,rigs_TrimServos);   % Compute the "errors" to feed the PIDs
  
  % Hoist logics
  k=1.002;
  if (anemometer.aws>25)|| ((anemometer.aws>10)&&(abs(gnss.roll)>deg2rad(5)));k=0.995;end
  if truth.tws>=25;k=0.998;end 
  truth.hoists = max(0.25,min(1,truth.hoists*k));
      
  % Thrust
  setpoint     = Pd_pid.get_pid_out(truth.time,ctrlSettings.speed.err); % Compute the setpont for the thrust servo
  Pd_servo.update(truth.time,setpoint); % Update the thrust servo setpoint
  truth.Pd     = Pd_servo.deflection;   % Update the thrust in the truth

  % Course
  %r2d(ctrlSettings.course.err)
  course_err      = ctrlSettings.course.err;
  %rate_setpoint   = course_pid.get_pid_out(truth.time,course_err); % Compute the setpont for the rudder servo
  %rate_err        = rate_setpoint-gnss.yaw_rate;
  %rudder_setpoint = yaw_rate_pid.get_pid_out(truth.time,rate_err);
  rudder_setpoint = yaw_pid_X.get_pid_out(truth.time,course_err);

  rudderServo.update(truth.time,rudder_setpoint); % Update the servo setpoint
  truth.rudder = rudderServo.deflection;   % Update the angle in the truth
  %fprintf('%7.2f %7.2f \n',r2d(rate_setpoint), r2d(rudder_setpoint));

  
  
  % Rig sheeting
  for irig = 1:length(rigs)
    setpoint     = rigs_pids(irig).get_pid_out(truth.time,ctrlSettings.rig.err); % Compute the setpont for the rudder servo
    rigs_TrimServos(irig).update(truth.time,setpoint); % Update the servo setpoint
    truth.sheets(irig)  = rigs_TrimServos(irig).deflection;   % Update the truth
  end
    %truth.sheets(3)  = d2r(90);   % Jammed mast-sheeting

  % Calculate forces and integrate
   truth      = calc_forces_to_truth(truth,rigs,fins);
   acc        = EOM(truth.F,truth.M);      % Ship accelerations
   truth      = integrate(dt,truth,acc);   % Increase the time stamp by dt in the thruth
   truth_(it) = truth;

  % Store data for post-analysis
  data.ctrlSettings = ctrlSettings;
  data.rigs_Servos  = rigs_TrimServos;
  data.rudderServo  = rudderServo;
  Data(it)          = data;
  if rem(it,round(Nt/100))==0;fprintf('.');end

end
fprintf('\nIntegration of %.0f hours performed in %.0fs at %.0f times real speed :-) \n',truth.time/3600,toc,truth.time/toc);
fprintf('done :-)\n');






