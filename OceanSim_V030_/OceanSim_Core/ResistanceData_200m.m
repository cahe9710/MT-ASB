% Vessel V2.5, which is Hull version H2.2, 
% WITH DIAGONAL FINS
% Based on Towing tank test and CFD

% Report RI40199079-07-00-A
% hull with shafts and brackets, 
% with friction correct, with Cp, no diagonal fin, no air.
% WITH DIAGONAL FINS

% 2020-05-07 SW


%% Resistance
% Vs(m/s)	Rts(N)

Rvec=[% Vs (knots)	Rts (N)
           0        0.0
           8	    140237.65
          10	    220963.0322
          12	    324424.7502
          14	    449529.8281
          16	    607078.2899
          18	    807456.1594
          20	    1052533.461];

Rvec(:,1)=Rvec(:,1)*1852/3600;

