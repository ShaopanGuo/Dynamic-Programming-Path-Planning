classdef EV
    % This is an Electric Vehicle.
    
    properties
        mass        % Total mass of the vehicle
        Voc         % Open circuit voltage
        Crr         % Rolling coefficient
        Af          % Vehicle frontal area
        c1          % The ratio between Fmot and Ia: Fmot = c1 * Ia
        gamma       % The conversion rate: Ib = gamma*Ia
%         frr         % rolling resistance frr = Crr*mass*g*cos(road.slope)
%                     % In this homework, it is denoted as c2.
%         c3          % The coefficient of v^2
%         position    % vehicle's position
%         velocity    % vehicle's velocity
%         acceleration    % vehicle's acceleration
%         Ib              % battery current       
    end
    
    methods
        function obj = EV(m,Voc,Crr,Af)
            obj.mass = double(m);
            obj.Voc = double(Voc);
            obj.Crr = double(Crr);
            obj.Af = double(Af);
        end
        
        function obj = set.mass(obj,m)
            obj.mass = double(m);
        end
        function obj = set.Voc(obj,Voc)
            obj.Voc = double(Voc);
        end
        function obj = set.Crr(obj,Crr)
            obj.Crr = double(Crr);
        end
        function obj = set.Af(obj,Af)
            obj.Af = double(Af);
        end
    end
end

