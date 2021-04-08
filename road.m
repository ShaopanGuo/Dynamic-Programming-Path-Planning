classdef road
    
    properties
        length        % the length of the road
        velocity       % maximum allowable velocity on this road
    end
    
    methods
        function obj = road(len,vmax)
            if nargin < 2, vmax = ""; end
            if nargin < 1, len = ""; end
            obj.length = double(len);
            obj.velocity = double(vmax);
        end
        
        function obj= set.length(obj,len)
            obj.length = double(len);
        end
         function obj= set.velocity(obj,vmax)
            obj.velocity = double(vmax);
        end
    end
end

