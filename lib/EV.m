classdef EV < handle
    %% MEMBERS
    properties
        role        % Leder: role=1; Follower: role = 2
        Af
        g
        rho
        Crr
        Cd
        gamma
        t
        dt
        tf
        alpha
        
        vDes
        aMax
        bMax
        bnHat
        Ln
        
        m       % Mass
        l       % Length
        
        c1;
        c2;
        c3;
        
        x       % [X, dX]
        r       % position vector [X]
        v      % velocity vector [dX]
        
        dx
        
        u        % Control Input [Ib]
%         Ib       % Battery current
    end
    
    properties
        r_des
        r_err
        r_err_prev
        r_err_sum
        
        v_des
        v_err
        v_err_prev
        v_err_sum
        
        kP_r
        kI_r
        kD_r
        
        kP_v
        kI_v
        kD_v
    end
        
    %% METHODS
    methods
        %% CONSTRUCTOR
        function obj = EV(role,params, initStates, initInputs, gains, ...
                simTime, dt, alpha, Ln)
            obj.role = role;
            obj.Af = 2.1;
            obj.g = 9.8;
            obj.rho = 1.23;
            obj.Crr = 0.01;
            obj.Cd = 0.38;
            obj.gamma = 1.2;
            obj.t = 0.0;
            obj.dt = dt;
            obj.tf = simTime;
            obj.alpha = alpha;
            
            obj.vDes = 50;
            obj.aMax = 2;
            obj.bMax = -3;
            obj.bnHat = -3.5;
            obj.Ln = Ln;
            
            obj.m = params('Mass');
            obj.l = params('Length');
            
            obj.c1 = 30;
            obj.c2 = obj.Crr * obj.m * obj.g * cos(obj.alpha);
            obj.c3 = 0.5 * obj.rho * obj.Af * obj.Cd;
            
            obj.x = initStates;
            obj.r = obj.x(1);
            obj.v = obj.x(2);
            
            obj.dx = zeros(2,1);
            
            obj.u = initInputs;
            
            obj.r_des = 0.0;
            obj.r_err = 0.0;
            obj.r_err_prev = 0.0;
            obj.r_err_sum = 0.0;
            
            obj.v_des = 0.0;
            obj.v_err = 0.0;
            obj.v_err_prev = 0.0;
            obj.v_err_sum = 0.0;
            
            obj.kP_r = gains('P_r');
            obj.kI_r = gains('I_r');
            obj.kD_r = gains('D_r');
            
            obj.kP_v = gains('P_v');
            obj.kI_v = gains('I_v');
            obj.kD_v = gains('D_v');
        end
        
        function state = GetStates(obj)
            state = obj.x;
        end
        
        function obj = EvalEOM(obj)    % Equations Of Motions
            obj.dx(1) = obj.v;
            obj.dx(2) = 1 / obj.m * (-obj.c3 * obj.x(2)^2 ...
                + obj.c1/obj.gamma*obj.u - obj.c2) - obj.g*sin(obj.alpha);
        end
        
        function obj = UpdateState(obj)
            obj.t = obj.t + obj.dt;
            
            obj.EvalEOM();
            obj.x = obj.x + obj.dx.*obj.dt;
            
            obj.r = obj.x(1);
            obj.v = obj.x(2);  
        end
        
        function obj = Ctrl(obj,refSig)
            if obj.role == 1
                i = find(refSig(1,:)>obj.x(1),1);
                if isempty(i)
                    obj.v_des = 0;
                else
                    obj.v_des = refSig(2,i);
                end
            else
                obj.v_des = gipps(obj.dt,obj.x(2),obj.aMax,obj.vDes, ...
                    obj.bMax,refSig(1),obj.x(1),obj.Ln,refSig(2),obj.bnHat);
%                 obj.kP_v = 100;
            end
                obj.v_err = obj.v_des - obj.x(2);
                obj.u = (obj.kP_v * obj.v_err + ...
                obj.kI_v * obj.v_err_sum + ...
                obj.kD_v * (obj.v_err - obj.v_err_prev)/obj.dt);
%                 obj.u = (((obj.kP_v * obj.v_err + ...
%                 obj.kI_v * obj.v_err_sum + ...
%                 obj.kD_v * (obj.v_err - obj.v_err_prev)/obj.dt) ...
%                 +obj.g*sin(obj.alpha))*obj.m+obj.c2*obj.x(2)^2+obj.c2) ...
%                 *obj.gamma/obj.c1;
                     
                obj.v_err_sum = obj.v_err_sum + obj.v_err;                
                obj.v_err_prev = obj.v_err;
        end
    end
    
end