function wind = generateWind(z,environment)
global tws twa

if(strcmp(environment.inflow,'BL')||strcmp(environment.inflow,'twisted'))
    uz=tws*((z+environment.windOffset)/environment.zRef)^(1/7);
else
    uz = tws;
end
% uz=tws;
wind = [1 0 0]*[-cos(twa) sin(twa) 0;
                -sin(twa)  cos(twa) 0;
                0         0        1]*uz;
if(strcmp(environment.inflow, 'twisted'))
    wind = wind - [environment.BoatSpeed 0 0];
end
wind = wind';