classdef PID_class < handle
    %PDI_CLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Kp        = 0;
        Ki        = 0;
        Kd        = 0;
        lastError = 0; % Previous error
        I         = 0; % Integral
        D         = 0; % Derivative
        max       = 0; % Max 
        min       = 0; % Max
        lastTime  = 0;
    end
    
    methods
        %-----------------------------------------------------
        function obj = PID_class(gains_P_I_D,min,max) % constructor method
            obj.Kp  = gains_P_I_D(1);
            obj.Ki  = gains_P_I_D(2);
            obj.Kd  = gains_P_I_D(3);
            obj.max = max;
            obj.min = min;
        end      
        %-----------------------------------------------------
        function  pid_out = get_pid_out(obj,time,error) % Get PID output
            dt             = time-obj.lastTime;
            obj.lastTime   = time;
            obj.I          = obj.I + (error*dt);
            obj.I          = max(obj.min,min(obj.I,obj.max));
            obj.D          = (error-obj.lastError)/dt;
            pid_out        = (obj.Kp*error) + (obj.Ki*obj.I) + (obj.Kd*obj.D);
            pid_out        = max(obj.min,min(pid_out,obj.max));
            if abs(pid_out)== obj.max;bj.I=0;end;
            obj.lastError  = error;
        end
    end
end

