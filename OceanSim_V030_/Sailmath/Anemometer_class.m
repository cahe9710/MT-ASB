classdef Anemometer_class < handle
    % This is NOT the truth but what the raw sensors sense
    properties
        awa = 0;
        aws = 0;      % Measured by Anemometers
        k   = 0.01;    % Filter constant
    end
    methods
        %-----------------------------------------------------
        function obj = Anemometer_class() % constructor method
        end    
        %-----------------------------------------------------
        function obj = sense(obj,truth) % 
            % Simulate sensors        
            %obj.aws         = truth.aws; % + sensorNoice ...
            %obj.awa         = truth.awa; % + sensorNoice ...

            x = (1-obj.k)*obj.aws*sin(obj.awa) + obj.k*truth.aws*sin(truth.awa);
            y = (1-obj.k)*obj.aws*cos(obj.awa) + obj.k*truth.aws*cos(truth.awa);

            obj.aws =  sqrt(x*x+y*y);
            obj.awa =  atan2(x,y);
        end    
        %-----------------------------------------------------
    end
end
