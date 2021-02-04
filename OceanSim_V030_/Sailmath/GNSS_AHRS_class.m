classdef GNSS_AHRS_class < handle
    %-----
    properties
        sog,cog;            % GNSS (dual antenna)
        yaw,roll;           % AHRS
        yaw_rate,roll_rate; % AHRS 
        leeway;
    end
    methods
        %-----------------------------------------------------
        function obj = GNSS_AHRS_class() % constructor method
        end    
        %-----------------------------------------------------
        function obj = sense(obj,truth) % 
            % Simulate sensors                        
            obj.sog         = truth.sog; % + sensorNoice ...
            obj.cog         = truth.cog; % + sensorNoice ...
            
            obj.yaw         = truth.yaw; % + sensorNoice ...
            obj.yaw_rate    = truth.Rz;  % + sensorNoice ...

            obj.roll        = truth.roll; % + sensorNoice ...
            obj.roll_rate   = truth.Rx;   % + sensorNoice ...
            
            obj.leeway      = unwrap_pi(truth.cog-truth.yaw);
        end    
        %-----------------------------------------------------
    end
end
