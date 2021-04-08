% main function
clc; clear; close all

% Generate a map.
s = [1 1 2 2 3 4 5];
t = [2 3 4 5 5 6 6];
G = digraph(s,t);         % This map is a digraph.
I = full(incidence(G)); 
plot(G)

numInter = size(I,1);
numEdge = size(I,2);
v0 = converterMPH(70);                  % average velocity limitation: 70mph 
rng(1)
vmax = v0 * (1 + rand(numEdge,1));      % generate maximum velocity for each
                                        % road segment.
len0 = 10 * 1000;                       % average road length: 10km               
len = len0 * (1 + rand(numEdge,1));     % generate road lenth for each
                                        % road segment.
alpha = zeros(1,numEdge);

% Generate roads.                                        
road12 = road(len(1),vmax(1),alpha(1));
road13 = road(len(2),vmax(2),alpha(2));
road24 = road(len(3),vmax(3),alpha(3));
road25 = road(len(4),vmax(4),alpha(4));
road35 = road(len(5),vmax(5),alpha(5));
road46 = road(len(6),vmax(6),alpha(6));
road56 = road(len(7),vmax(7),alpha(7));
roads = [road12, road13, road24, road25, road35, road46, road56];

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
reward12 = ppReward(roads(1).velocity,roads(1).length,roads(1).slope,m,Voc,c1,gamma,Crr, Af, Cd, g, rho);
reward13 = ppReward(roads(2).velocity,roads(2).length,roads(2).slope,m,Voc,c1,gamma,Crr, Af, Cd, g, rho);
reward24 = ppReward(roads(3).velocity,roads(3).length,roads(3).slope,m,Voc,c1,gamma,Crr, Af, Cd, g, rho);
reward25 = ppReward(roads(4).velocity,roads(4).length,roads(4).slope,m,Voc,c1,gamma,Crr, Af, Cd, g, rho);
reward35 = ppReward(roads(5).velocity,roads(5).length,roads(5).slope,m,Voc,c1,gamma,Crr, Af, Cd, g, rho);
reward46 = ppReward(roads(6).velocity,roads(6).length,roads(6).slope,m,Voc,c1,gamma,Crr, Af, Cd, g, rho);
reward56 = ppReward(roads(7).velocity,roads(7).length,roads(7).slope,m,Voc,c1,gamma,Crr, Af, Cd, g, rho);
reward = [reward12, reward13, reward24, reward25, reward35, reward46, reward56];
