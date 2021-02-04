function truth  = calc_forces_to_truth(truth,rigs,fins)
% Calculate all force components and sum up
global settings data

% Get data from the truth
aws    = truth.aws;
awa    = truth.awa;
twa    = truth.twa;
tws    = truth.tws;
Vx     = truth.Vx;
Vy     = truth.Vy;
p      = truth.Rx;
r_w    = truth.Rz;
roll   = truth.roll;
Pd     = truth.Pd;
T      = truth.T;
delta  = truth.rudder;
leeway = truth.leeway;

% Some sanity checks
if aws>40;  truth,TOO_LARGE_AWS;end
if Vx>50;   truth,TOO_LARGE_Vx;end
if Vx< 0;   truth,TOO_NEGATIVE_Vx;end
if Vy>5;    truth,TOO_LARGE_LEEWAY;end
if abs(roll)>d2r(30);truth,TOO_LARGE_HEEL;end
            
% Get ship main particulars and hydrodynamic coefficients
run(settings.ShipData);

% Get resistance data
run(settings.ResData) % Calling ship resistance data
X_res = -interp1(Rvec(:,1),Rvec(:,2),Vx,'linear','extrap');    % interpolate resistance

% Hull aerodynamics
[truth.F_aero_hull,truth.M_aero_hull]  = calc_hullAero(aws,awa);

% Hull hydrodynamics
[truth.F_hydro_hull,truth.M_hydro_hull]  = calc_hullHydro(Vx,Vy,p,r_w,roll,delta,T,X_res);

% Fins
[truth.F_fins,truth.M_fins ] = calc_fin(Vx,leeway,fins);

% Wave resistance
[F_wave,M_wave] = calc_waveResistance(Vx,tws,twa);

% Sea margin
[F_seaMargin,  M_seaMargin]   = calc_seaMargin(truth.F_hydro_hull); 

% Rig 
%[truth.F_rig,truth.M_rig] = rig.calcFM(aws,awa,truth.sheet,truth.hoist);
truth.F_rig = [0;0;0];
truth.M_rig = [0;0;0];
M_mastfoot  = [0;0;0];
aoa         = [0;0;0];
for irig=1:length(rigs)
  [Fi,Mi,M_mastfoot(irig),aoa(irig)] = rigs(irig).calcFM(aws,awa,truth.sheets(irig),truth.hoists(irig));
  truth.F_rig = truth.F_rig + Fi;
  truth.M_rig = truth.M_rig + Mi;
end

% Sum of Forces and moments
truth.F = truth.F_hydro_hull + truth.F_aero_hull + truth.F_rig + truth.F_fins + F_wave + F_seaMargin; 
truth.M = truth.M_hydro_hull + truth.M_aero_hull + truth.M_rig + truth.M_fins + M_wave + M_seaMargin; % 

if sum(size(truth.F)==[3,1])<2;STOP_Something_wrong_with_row_column;end

data.M_mastfoot = M_mastfoot;
data.rig_aoa    = aoa;
data.F_aero     = truth.F_rig + 0*truth.F_aero_hull;
data.Mz_aero    = truth.M_rig + 0*truth.M_aero_hull;

