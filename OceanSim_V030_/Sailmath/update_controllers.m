function   ctrlSettings = update_controllers(ctrlSettings,dvl,gnss,anemometer,rudderServo,rigs_TrimServos)   % Calc the errors


% Speed
switch ctrlSettings.speed.mode
    case 'sog'
        ctrlSettings.speed.err = ctrlSettings.speed.val-gnss.sog;
    case 'xxx'
        xxx
    otherwise
        XXXXXXX
end

% Course
switch ctrlSettings.course.mode
    case 'cog'
        ctrlSettings.course.err = unwrap_pi(gnss.cog-ctrlSettings.course.val);
    case 'yaw'
        ctrlSettings.course.err = unwrap_pi(gnss.yaw-ctrlSettings.course.val);
    case 'awa'
        ctrlSettings.course.err = -unwrap_pi(gnss.awa-ctrlSettings.course.val);
    case 'rudder'
        ctrlSettings.course.err = unwrap_pi(filters.rudder-ctrlSettings.course.val);
    otherwise
        XXXXXXX
end

 % Rig
switch ctrlSettings.rig.mode
    case 'aoa'
        err = anemometer.awa - ctrlSettings.rig.val*sign(anemometer.awa);
        if abs(anemometer.awa)<deg2rad(20)
            err = anemometer.awa; % Set rig sheet =awa (anemometer measures wind relative to Vx)
        end
        if (err-rigs_TrimServos(1).deflection)>pi   
            err=err-2*pi;
        elseif (err-rigs_TrimServos(1).deflection)<-pi
            err=err+2*pi;
        end
        ctrlSettings.rig.err = err;
    otherwise
        XXXXXXX
        
 % Reef/Hoist
 
end
