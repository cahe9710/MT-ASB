function eta  = multirig_knockDown(awa,xCP)
global settings
run(settings.ShipData)
% Knocks down aws as a function of awa and rig placement in relation to others

% xCP=0 is mid ship

%  multirig_knockDown(deg2rad(50),[-80 -30 0 30 80])

if abs(xCP)>(L/2);XXXXX;end
if(abs(awa)>pi); STOP_awa_aws;end

awa = abs(awa);
% Now take care of if we are beating or reaching
x = xCP+(L/2); % x  in range 0-200m from stern
if awa>pi/2
    awa = pi-awa;
    x   = (L/2)-xCP;
end

tmp = (awa-pi/2);
k   = 0.2*abs(tmp)^1 * sign(tmp); % Slope
k   = min(1,max(0,(1+k*(L-x)/L).^2));
eta = 1.4*k;
% eta = 1.4;
