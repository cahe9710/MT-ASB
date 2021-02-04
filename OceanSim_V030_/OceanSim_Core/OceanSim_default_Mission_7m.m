function ctrlSettings = My_Mission(time,ctrlSettings,dvl,gnss,anemometer)

if time==0 % First time step
    ctrlSettings.course.mode = 'cog';
    ctrlSettings.course.val  = deg2rad(0);
    ctrlSettings.speed.val   = kn2ms(10*sqrt(7/206.6)); % [m/s] Speed of 7m model corresponds to full scale ship
    ctrlSettings.rig.mode    = 'aoa';
    ctrlSettings.rig.val     = d2r(12);
end

if anemometer.aws<25
    ctrlSettings.rig.val     = deg2rad(12);
else
    ctrlSettings.rig.val     = deg2rad(0);
end

if time>250
    ctrlSettings.course.val  = deg2rad(45);
end
