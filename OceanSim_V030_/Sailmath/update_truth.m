function  truth = update_truth(truth)

truth.T      = propeller(truth.Pd,truth.Vx); % [N] Calc trust from Pd & Vx

truth.leeway                    = -atan2(truth.Vy,truth.Vx);
[truth.cog,truth.sog]           =  calc_SogCog(truth.yaw,truth.leeway,truth.Vx,truth.Vy);
[truth.tws,truth.twd]           =  eval(strcat(truth.windFile,'(truth.time,truth)'));
[truth.aws,truth.awa,truth.twa] =  calc_aw(truth.tws,truth.twd, truth.sog,truth.cog);


