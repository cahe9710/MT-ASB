classdef Rig_class < handle
    %
    % W1=Wing_class(130),  W1.update(12.1,10,deg2rad(-60));W1.set_trim(deg2rad(10)), W1.print  
    %
    properties
        sections          = [1 1 1 1]; % 4= all sections sailing. 3= all 3 retracted [lowest, , ,top]
        sections_setpoint = [1 1 1 1]; % Last setting commanded
        sections_rate     = 0.005;     % [section/sec]
        height            = 0;         % [m] Rig height
        area              = 0;         % [m2]  Rig area
        xCP               = 0;         % [m]   mast position from mid ship
        LOA               = 0;         % [m]   Ship length
        aoa               = 0;         % [rad] Angle of attack
        aws               = 0;         % Just for the record :-)
        awa               = 0;         % Just for the record :-)
        time_lastUpdate   = 0;         % [s]   Time
        F                 = [0 0 0];   % [N]   Forces 
        M                 = [0 0 0];   % [Nm]  Moments 
    end

    methods
        %-----------------------------------------------------
        function obj   = Rig_class(xCP,height,area) % constructor method
            obj.xCP    = xCP;
            obj.height = height;
            obj.area   = area;
        end
        %-----------------------------------------------------
        function  set_trim(obj,desired_trim) % 
            obj.trim_setpoint   = desired_trim;
        end        
        %-----------------------------------------------------
        function    [F,M,M_mastfoot,aoa] = calcFM(obj,aws,awa,trim,hoist)
          global settings
          if (hoist>1) || (hoist)<0.25 ; STOP_hoist;  end
          if (aws>40)  || (abs(awa)>pi); STOP_awa_aws;end
            
            q   = 0.5*settings.rho_air*aws^2; % [Pa] Dynamic pressure
            eta =  multirig_knockDown(awa,obj.xCP); % Multi-rig knock down factor
            q   = q*eta;
            
            aoa        = unwrap_pi(awa-trim); % Anemometer measures wind relative to Vx (no leeway)
            [cl,cd,cm] = naca0018(abs(aoa));
            
            % Forces in the wing-fixed coordinate system, x-forward, y to the right
            area    = hoist*obj.area;
            zCP_mf  = obj.height*hoist*0.4; % [m] Over mastFoot
            zCP_wl  = settings.D+zCP_mf; % [m] Over Sea level
            
            % Forces in the ship-fixed coordinate system, x-forward, y to the right
            if aoa>0
                Fxy = q*area*[-sin(awa) -cos(awa)
                              -cos(awa)  sin(awa)]*[-cl;-cd]; % Anemometer measures wind relative to Vx (no leeway)
            else
                if aoa<0
                    Fxy = q*area*[sin(awa) -cos(awa)
                                  cos(awa)  sin(awa)]*[cl;-cd]; % Anemometer measures wind relative to Vx (no leeway)
                else
                    if aoa==0
                        Fxy = q*area*[0 -cos(awa)
                                      0  sin(awa)]*[cl;-cd]; % Anemometer measures wind relative to Vx (no leeway)
                    end
                end
            end
            Mz     = Fxy(2)*obj.xCP; % Moment around water plane
            Mx     = Fxy(2)*zCP_wl;
            
            M_mastfoot = sqrt(Fxy(1)^2+Fxy(2)^2)*zCP_mf;
            
            obj.aws     = aws;
            obj.awa     = awa;
            obj.aoa     = aoa;
            
            % Forces & moments in xyz
            obj.F = [Fxy(1);Fxy(2);0];
            obj.M = [Mx;0;Mz];
            
            F = obj.F;
            M = obj.M;
        end
        %-----------------------------------------------------
        function val = print(obj)
            fprintf('  aws       =%6.1fm/s     awa     = %.2f°\n',obj.aws,rad2deg(obj.awa));
            fprintf('  Trim      =%6.2f°       setpoint= %.2f°\n',rad2deg(obj.trim),rad2deg(obj.trim_setpoint));
            fprintf('  Trim rate =%6.2f°/s   \n',rad2deg(obj.trim_rate));
        end
    end
end