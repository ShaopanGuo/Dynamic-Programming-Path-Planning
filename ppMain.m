% main function
clc; clear; close all

addpath('./lib')

%% Generate a map.
s = [1 1 2 2 3 4 5];
t = [2 3 4 5 5 6 6];
G = digraph(s,t);         % This map is a digraph.
I = full(incidence(G)); 
% plot(G)

%% Path Planning
numInter = size(I,1);
numEdge = size(I,2);
[v0,~,~] = converterMPH(70);                  % average velocity limitation: 70mph 
rng(1)
vmax = v0 * (1 + rand(numEdge,1));      % generate maximum velocity for each
                                        % road segment.
len0 = 10*1000;                       % average road length: 1km               
len = len0 * (1 + rand(numEdge,1));     % generate road lenth for each
                                        % road segment.
alpha = zeros(1,numEdge);
% alpha = pi/4 * rand(1,numEdge);

% Generate roads.                                        
% road12 = road(len(1),vmax(1),alpha(1));
% road13 = road(len(2),vmax(2),alpha(2));
% road24 = road(len(3),vmax(3),alpha(3));
% road25 = road(len(4),vmax(4),alpha(4));
% road35 = road(len(5),vmax(5),alpha(5));
% road46 = road(len(6),vmax(6),alpha(6));
% road56 = road(len(7),vmax(7),alpha(7));
% roads = [road12, road13, road24, road25, road35, road46, road56];

roads = [];
for i=1:numEdge
    roads = [roads road(len(i),vmax(i),alpha(i))];
end

% Electric Vehicle
m = 2300;        % Total mass of the vehicle: 2300kg
Voc = 340;       % Open circuit voltage: 340v
Crr = 0.01;      % Rolling resistance coefficient
g = 9.8;         % Gravitational acceleration: 9.8m/s
c2 = Crr * m * g * cos(0);     % Rolling resistance
rho = 1.23;                    % Air density
Af = 2.1;                      % Vehicle frontal area: 2.1m^2
Cd = 0.38;                     % Aerodynamic drag coefficient
c3 = 0.5 * rho * Af * Cd;
gamma = 1.2;                   % The conversion rate: Ib = gamma*Ia
c1 = 30;                       % The ratio between Fmot and Ia: Fmot = c1 * Ia

% Generate rewards.
% reward12 = ppReward(roads(1).velocity,roads(1).length,roads(1).slope,m,Voc,c1,gamma,Crr, Af, Cd, g, rho);
% reward13 = ppReward(roads(2).velocity,roads(2).length,roads(2).slope,m,Voc,c1,gamma,Crr, Af, Cd, g, rho);
% reward24 = ppReward(roads(3).velocity,roads(3).length,roads(3).slope,m,Voc,c1,gamma,Crr, Af, Cd, g, rho);
% reward25 = ppReward(roads(4).velocity,roads(4).length,roads(4).slope,m,Voc,c1,gamma,Crr, Af, Cd, g, rho);
% reward35 = ppReward(roads(5).velocity,roads(5).length,roads(5).slope,m,Voc,c1,gamma,Crr, Af, Cd, g, rho);
% reward46 = ppReward(roads(6).velocity,roads(6).length,roads(6).slope,m,Voc,c1,gamma,Crr, Af, Cd, g, rho);
% reward56 = ppReward(roads(7).velocity,roads(7).length,roads(7).slope,m,Voc,c1,gamma,Crr, Af, Cd, g, rho);
% rewards = [reward12, reward13, reward24, reward25, reward35, reward46, reward56];

rewards = [];
for ii=1:numEdge
    rewards = [rewards ppReward(roads(i).velocity,roads(i).length,...
        roads(i).slope,m,Voc,c1,gamma,Crr, Af, Cd, g, rho)];
end

[pathR, costR] = ppR(rewards,I,numInter);

[path, cost] = ppDP(rewards,I,1, numInter);

path = [1, 3, 7];

%% INIT. PARAMS
ev1_params = containers.Map({'Mass', 'Length'}, {2300, 5});

ev1_initStates = [0,...               % position
    0]';                              % velocity

Ln = 7.62;                            
%     the effective size of vehicle n; that is the physical length plus
%     a margin into which the following vehicle is not willing to introduce
%     even at rest

ev2_initStates = [-Ln,...             % position
    0]';                              % velocity
ev3_initStates = [-2*Ln,...             % position
    0]';                              % velocity
ev4_initStates = [-3*Ln,...             % position
    0]';    

ev1_initInputs = [0];

ev1_gains = containers.Map({'P_r','I_r','D_r', ...
    'P_v','I_v','D_v'}, ...
    {0.0, 0.0, 0.0, ...
    3.0, 0.0, 0.0});
ev2_gains = containers.Map({'P_r','I_r','D_r', ...
    'P_v','I_v','D_v'}, ...
    {0.0, 0.0, 0.0, ...
    100.0, 0.0, 0.0});

simulationTime = 1773;
dt = 1;
alpha = 0;
role1 = 1;        % Leader
role2 = 2;        % Follower
 
ev1 = EV(role1,ev1_params, ev1_initStates, ev1_initInputs, ev1_gains, ...
    simulationTime,dt,alpha,Ln);
ev2 = EV(role2,ev1_params, ev2_initStates, ev1_initInputs, ev2_gains, ...
    simulationTime,dt,alpha,Ln);
ev3 = EV(role2,ev1_params, ev3_initStates, ev1_initInputs, ev2_gains, ...
    simulationTime,dt,alpha,Ln);
ev4 = EV(role2,ev1_params, ev4_initStates, ev1_initInputs, ev2_gains, ...
    simulationTime,dt,alpha,Ln);

% %% Init. Data Fig.
% fig1 = figure('pos',[0 50 700 700]);
% 
% subplot(3,1,1)
% title('Position[m]')
% grid on;
% hold on;
% 
% subplot(3,1,2)
% title('Velocity[m/s]')
% grid on;
% hold on;
% 
% subplot(3,1,3)
% title('Spacing[m]')
% grid on;
% hold on;
% 
% %%
% numInter = size(path,2);
% r1Temp = len(path)';
% r1Des = zeros(1,numInter);
% v1Des = vmax(path)';
% for ii=1:numInter
%     if ii == 1
%         r1Des(ii) = r1Temp(ii);
%     else
%         r1Des(ii) = r1Des(ii-1) + r1Temp(ii);
%     end
% end
% commandSig1 = [r1Des; v1Des];
% for i = 1:simulationTime/dt
%     ev1.Ctrl(commandSig1);
%     ev1.UpdateState();
%     ev1_state = ev1.GetStates();
%     
%     commandSig2 = [ev1_state(1), ev1_state(2)];
%     ev2.Ctrl(commandSig2);
%     ev2.UpdateState();
%     ev2_state = ev2.GetStates();
%     
%     commandSig3 = [ev2_state(1), ev2_state(2)];
%     ev3.Ctrl(commandSig3);
%     ev3.UpdateState();
%     ev3_state = ev3.GetStates();
%     
%     commandSig4 = [ev3_state(1), ev3_state(2)];
%     ev4.Ctrl(commandSig4);
%     ev4.UpdateState();
%     ev4_state = ev4.GetStates();
%     %%
%     figure(1)
%     subplot(3,1,1)
%         plot(i*dt, ev1_state(1), 'r.')
% %         plot(i*dt, ev2_state(1), 'b.')
% 
%     subplot(3,1,2)
%         plot(i*dt, ev1_state(2), 'r.')
% %         plot(i*dt, ev2_state(2), 'b.')
%         
%     subplot(3,1,3)
%         plot(i*dt, ev1_state(1)-ev2_state(1),'r.', ...
%              i*dt, ev1_state(1)-ev3_state(1),'b.', ...
%              i*dt, ev1_state(1)-ev4_state(1),'g.')
% end

%% Init. Data Fig.
fig1 = figure('pos',[0 50 700 700]);

subplot(2,1,1)
title('Position[m]')
grid on;
hold on;

subplot(2,1,2)
title('Velocity[m/s]')
grid on;
hold on;

fig2 = figure('pos',[700 50 700 700]);

subplot(2,1,1)
title('Spacing[m]')
grid on;
hold on;

subplot(2,1,2)
title('Velocity Tracking[m/s]')
grid on;
hold on;

%%
numInter = size(path,2);
r1Temp = len(path)';
r1Des = zeros(1,numInter);
v1Des = vmax(path)';
for ii=1:numInter
    if ii == 1
        r1Des(ii) = r1Temp(ii);
    else
        r1Des(ii) = r1Des(ii-1) + r1Temp(ii);
    end
end
commandSig1 = [r1Des; v1Des];
for i = 1:simulationTime/dt
    ev1.Ctrl(commandSig1);
    ev1.UpdateState();
    ev1_state = ev1.GetStates();
    
    commandSig2 = [ev1_state(1), ev1_state(2)];
    ev2.Ctrl(commandSig2);
    ev2.UpdateState();
    ev2_state = ev2.GetStates();
    
    commandSig3 = [ev2_state(1), ev2_state(2)];
    ev3.Ctrl(commandSig3);
    ev3.UpdateState();
    ev3_state = ev3.GetStates();
    
    commandSig4 = [ev3_state(1), ev3_state(2)];
    ev4.Ctrl(commandSig4);
    ev4.UpdateState();
    ev4_state = ev4.GetStates();
    %%
    figure(1)
    subplot(2,1,1)
        plot(i*dt, ev1_state(1), 'r.')
%         plot(i*dt, ev2_state(1), 'b.')

    subplot(2,1,2)
        plot(i*dt, ev1_state(2), 'r.')
%         plot(i*dt, ev2_state(2), 'b.')

   figure(2)        
    subplot(2,1,1)
        plot(i*dt, ev1_state(1)-ev2_state(1),'r.', ...
             i*dt, ev1_state(1)-ev3_state(1),'b.', ...
             i*dt, ev1_state(1)-ev4_state(1),'g.')
         legend('$p_1 - p_2$', '$p_1 - p_3$', '$p_1 - p_4$', ...
             'Interpreter', 'latex')
         
    subplot(2,1,2)
        plot(i*dt, ev1_state(2)-ev2_state(2),'r.', ...
             i*dt, ev1_state(2)-ev3_state(2),'b.', ...
             i*dt, ev1_state(2)-ev4_state(2),'g.')
         legend('$v_1 - v_2$', '$v_1 - v_3$', '$v_1 - v_4$', ...
             'Interpreter', 'latex')
end
