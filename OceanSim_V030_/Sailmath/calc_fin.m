function [F,M,L,D,CL,CD] = calc_fin(sog,leeway,fins)
global data  settings
% Ship heel is neglected
% Z-coord is dist from waterline to fin root
%run(settings.shipDataFile);

% TEST:  fins.x=10;[F,M,L,D,CL,CD] = calc_fin(5,deg2rad(150),fins);[F,M]

if sog<0; STOP_negative_sog;end

if sog>0.01 && fins.Nfins>0
    chord     = (fins.Cr+fins.Ct)/2;        % [m]     mean chord
    Aref      = chord*fins.semispan;        % [m2]
    AR        = (fins.semispan*2)^2/Aref;   % [-]     Effective Aspect ratio
    q         = 0.5*settings.rho_water*sog.^2;             % [Pa]    Dynamic pressure
    q         = q*1.7; % CORRECTION FOR LOCAL INCREASE OF INFLOW !!!!!!!!!!!!!!
    k_fouling = 2; % Arbitrary penalty factor on drag
    
    % 2D Lift
    deflection  = min(fins.max_aoa,abs(leeway)*fins.gain) * sign(leeway); % fin deflection
    aoa         = leeway + deflection;
    local_alfa  = aoa * abs(cos(fins.tilt));  % Adjusted for fin tilt
    [cl,cd,cm]  = naca0015(local_alfa);  % 2D lift and drag
    local_alfa  = local_alfa;
    CL          = cl/(1+2/AR);                % Three dimensional lift coeff
    L           = q*Aref*CL*fins.Nfins;       % Lift
    Do          = q*Aref*cd;
    
    %def = r2d(deflection)
    %local_alf = r2d(local_alfa)
    
    % Induced drag
    e      = 0.85;                    % Span efficiency factor
    CDi    = CL^2/(pi*AR*e);          % [-] Induced drag coeff
    Di     = q*Aref*CDi*fins.Nfins;        % [N] Induced drag
    
    D      = Di+Do;                   % Drag, parallell to flow (Vs)
    CD     = D/q/Aref;
    
    Fx     =   L*abs(sin(leeway))              - D*cos(leeway); % [N] In ship fixed ref-syst
    Fy     =  +L*abs(cos(leeway))*sign(leeway) + D*sin(leeway); % [N] In ship fixed ref-syst
    
    F      =  [Fx ; Fy ;  0];
    Mx     =   -(fins.y+fins.semispan/2*sin(fins.tilt)) * Fy*sin(fins.tilt)-...
        (fins.z+fins.semispan/2*cos(fins.tilt)) * Fy*cos(fins.tilt);
    M      = [Mx ; 0 ; fins.x*F(2)];
else
    F   = [0;0;0];
    M   = [0;0;0];
    L   = 0;
    D   = 0;
    CL  = 0;
    CD  = 0;
    aoa = 0;
    Fx  = 0;
    Fy  = 0;
    deflection = 0;
    local_alfa = leeway;
end
%data.Fx_fins = Fx;
%data.Fy_fins = Fy;
%data.Mz_fins = M(3);
%data.fin_aoa = aoa;
data.fin_deflection = deflection;
data.fin_aoa        = local_alfa;
