function filtered = do_filter(sensors)

filtered.awa    = sensors.awa;   % Smart filtering needed
filtered.aws    = sensors.aws;
filtered.yaw    = sensors.yaw;   % Smart filtering needed
filtered.sog    = sensors.sog;
filtered.cog    = sensors.cog;   % Smart filtering needed
filtered.Vx     = sensors.Vx;
filtered.Vy     = sensors.Vy;
filtered.rudder = sensors.rudder;
filtered.sheets = sensors.sheets;
filtered.roll   = sensors.roll;

[filtered.tws,filtered.twd] = calc_trueWind_2(filtered.yaw,filtered.sog,filtered.cog,filtered.aws,filtered.awa);
