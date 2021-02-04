function [F,M] = calc_waveResistance(Vs,TWS,TWA)
%--------------------------------------------------------------------------
% Returns added wave resistance in waves based on SPA model reference???
% Assumption is that wave direction is = wind direction
% Valid between TWA [0 - 180] deg
%
% Output:
% Raw :: [N] Added wave resistance
%
% Input ship specific:
% CWPAfore:: [m2] Forebody water plane area coefficeint, definition?
% Bwl     :: [m] Waterline beam
% Lwl     :: [m] Waterline length
% thrustd :: [-] Thrust deduction factor what is this??
%
% Input environmental variables:
% TWA     :: [rad] Relative wind direction 0 deg head wind
% TWS     :: [m/s] True windspeed 
% Vs      :: [m/s] Boat speed
% 
%--------------------------------------------------------------------------
global settings
run(settings.ShipData)
 Vs  = max(0,min(Vs,20));
 TWA = max(0,min(TWA,2.6));   % FAKE TO AVOID imaginary resistance
% Ship data MADE UP DATA, NOT FOR WPCC!!
Bwl      = B;
Lwl      = L;
thrustd  = 0.17;
CWPAfore = 0.667;

% Environmental data, global????
rho_water = 1025;
g         = 9.81;

%% Parameter definitions
SPA_C_peak  = 1;
SPA_C_ttail = 1;
SPA_C_tpeak = 1;
SPA_C_alfa  = 1;

SPA_a_01 = 0.7754;
SPA_a_02 = 0.1089;
SPA_a_03 = -0.775;
SPA_a_04 = 1.19;
SPA_a_05 = 8.395;
SPA_a_06 = 3.95;
SPA_a_07 = 0.905;
SPA_a_08 = 1.148;
SPA_a_09 = 0.1271;
SPA_a_10 = 0.1019;
SPA_a_11 = -0.5014;
SPA_a_12 = 9.592;
SPA_a_13 = -3.628;
SPA_a_14 = 11.77;
SPA_a_15 = -7.861;
SPA_a_16 = 1.168;
SPA_a_17 = -3.555;
SPA_a_18 = 0.1054;
%% Wave period and height from Pierson and Moskowitz
Tm = 5.5283*TWS/g;
Hs = sqrt(4*Tm^4*0.0081*g^2/691.18);

angle_wa = abs(TWA-pi);

if angle_wa < 0
    angle_wa = -angle_wa;
end

if angle_wa > pi 
    angle_wa = 2*pi-angle_wa;
end

if angle_wa < 3*pi/8 || angle_wa < 5*pi-angle_wa
    w_peak = SPA_C_peak*((SPA_a_01*sqrt(2*pi*g/Lwl/abs(cos(3*pi/8)))+SPA_a_02)*(SPA_a_03*Vs/sqrt(g*Lwl)+SPA_a_04));
else
    w_peak1 = SPA_C_peak * ((SPA_a_01*sqrt(2*pi*g/Lwl/abs(cos(3*pi/8)))+SPA_a_02)*(SPA_a_03*Vs/sqrt(g*Lwl)+SPA_a_04));
    w_peak2 = SPA_C_peak * ((SPA_a_01*sqrt(2*pi*g/Lwl/abs(cos(5*pi/8)))+SPA_a_02)*(SPA_a_03*Vs/sqrt(g*Lwl)+SPA_a_04));
    w_peak = (w_peak1 + w_peak2) / 2;
end

w_e = w_peak*(1-w_peak*Vs*cos(angle_wa)/g);

t_tail = SPA_C_ttail*(SPA_a_12*CWPAfore+SPA_a_13)*SPA_a_16*abs(tanh(SPA_a_17*w_e))*w_e^SPA_a_18;
t_peak = SPA_C_tpeak*(SPA_a_05*Vs/sqrt(g*Bwl)+SPA_a_06)*(SPA_a_07*abs(sin(angle_wa/2))^SPA_a_08+SPA_a_09);
alfa   = SPA_a_10*w_e^SPA_a_11;

raw_temp = 0;
for w = 0.05:0.05:3.5
    t_aw = t_peak*exp(-((w-w_peak)/alfa)^2)+t_tail/2*(1+tanh((w-w_peak-alfa)/(alfa/2)));
    raw_temp = raw_temp+0.05*2*t_aw*S_PM(Hs, Tm, w)*(1 - thrustd);
end

Raw = raw_temp*rho_water*g*Bwl^2/Lwl;

F = [-Raw;0;0];
M = [0;0;0];

if norm(imag(F))>0 || norm(imag(M))>0
    disp(' ');disp('WARNING, Wave resistance imaginary!!!'); 
    F = real(F);
    %Vs,TWS,TWA,F=F,M=M, F = real(F);
end % 


end % End of function


%% Returns Pierson-Moskowitz wave spectra S_PM(Hwa,Twa,w)
function S_PM = S_PM(Hs ,Tm , w)
    if w < 0.05 || w > 3.5 || Hs < 0.2 || Tm < 2.5
        S_PM = 0;
    else 
        fr = 2*pi/w/Tm;
        S_PM = Hs^2*Tm/8/pi^2*fr^5*exp(-fr^4/pi);
    end
end