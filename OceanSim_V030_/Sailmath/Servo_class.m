classdef Servo_class < handle
    %
    %
    properties
        deflection          = 0;             % [rad]   The actual position. (positive leading edge to starboard)
        deflection_setpoint = 0;             % [rad]   The last commanded setpoint
        deflection_rate     = 0;             % [rad/s] Rudder deflection rate
        time_lastUpdate     = 0;             % [s]     Time
        delta_max           = 0;
        delta_min           = 0;
    end
    
    methods
        %-----------------------------------------------------
        function obj = Servo_class(delta_min,delta_max,deflection_rate) % constructor method
            obj.delta_max       = delta_max;
            obj.delta_min       = delta_min;
            obj.deflection_rate = deflection_rate;
        end
        %-----------------------------------------------------
        function  deflection = update(obj,time,setpoint) % Updates
            obj.deflection_setpoint = min(max(setpoint,obj.delta_min),obj.delta_max);
            dt                  = time-obj.time_lastUpdate; % [s] Time step since last we were here
            obj.time_lastUpdate = time;                     % [s] Update object time
            step                = obj.deflection_setpoint-obj.deflection; % The naive stepsize
            step                = sign(step)*min(abs(step),dt*obj.deflection_rate); % To prevent overshoot
            deflection          = obj.deflection + step; % Update the deflection
            obj.deflection      = deflection;
        end
        %-----------------------------------------------------
        function val = print(obj)
            fprintf('  Deflection    =%.2f°   setpoint= %.2f°\n',rad2deg(obj.deflection),rad2deg(obj.deflection_setpoint));
        end
    end
end
