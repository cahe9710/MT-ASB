classdef Ship_class < handle
    %
    properties
        u     = 0;  % [m/s]   x-Velocity
        v     = 0;  % [m/s]   y-Velocity 
        p     = 0;  % [rad/s] Roll rate
        r     = 0;  % [rad/s] Yaw rate 
    end
    methods
        %-----------------------------------------------------
        function obj = Ship_class() % constructor method
        end
        %-----------------------------------------------------
        function Xval = get_Xval(obj) % 
            Xval = [obj.u obj.v obj.p obj.r];
        end
        %-----------------------------------------------------
        function set_Xval(obj,Xval) % 
                obj.u = Xval(1);
                obj.v = Xval(2);
                obj.p = Xval(3);
                obj.r = Xval(4);
        end
        %-----------------------------------------------------
    end
end
