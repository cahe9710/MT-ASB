classdef DVL_class < handle
    % This is NOT the truth but what the raw sensors sense
    properties
        Vx = 0;
        Vy = 0;         % Doppler velocity log
    end
    methods
        %-----------------------------------------------------
        function obj = DVL_class() % constructor method
        end    
        %-----------------------------------------------------
        function obj = sense(obj,truth) % 
            % Simulate sensors       
            obj.Vx          = truth.Vx;  % + sensorNoice ...
            obj.Vy          = truth.Vy;  % + sensorNoice ...
        end    
        %-----------------------------------------------------
    end
end
