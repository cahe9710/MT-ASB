function ctrlSettings = OceanSim_Mission(time,ctrlSettings,dvl,gnss,anemometer)

if time==0; % First time step
    ctrlSettings.course.mode ='cog';
    ctrlSettings.course.val  = deg2rad(0);
    ctrlSettings.speed.val   = kn2ms(8);
    ctrlSettings.rig.mode    = 'aoa';
end

if anemometer.aws<25
    ctrlSettings.rig.val     = deg2rad(12);
else
        ctrlSettings.rig.val     = deg2rad(0);
end


if time==1800;
        ctrlSettings.course.val  = deg2rad(45);
end
  


