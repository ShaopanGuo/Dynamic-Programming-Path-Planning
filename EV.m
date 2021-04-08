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
        function obj = EV(m,Voc,Crr,Af,c1,gamma)
            if nargin < 6, gamma = ""; end
            if nargin < 5, c1 = ""; end
            if nargin < 4, Af = ""; end
            if nargin < 3, Crr = ""; end
            if nargin < 2, Voc = ""; end
            if nargin < 1, m = ""; end
            obj.mass = double(m);
            obj.Voc = double(Voc);
            obj.Crr = double(Crr);
            obj.Af = double(Af);
            obj.c1 = double(c1);
            obj.gamma = double(gamma);
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
        function obj = set.c1(obj,c1)
            obj.c1 = double(c1);
        end
        function obj = set.gamma(obj,gamma)
            obj.gamma = double(gamma);
        end
    end
end

