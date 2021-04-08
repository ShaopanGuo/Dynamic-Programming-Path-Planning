% main function
clc; clear; close all

% Generate a map.
s = [1 1 2 2 3 4 5];
t = [2 3 4 5 5 6 6];
G = digraph(s,t);         % This map is a digraph.
I = full(incidence(G)); 
plot(G)

%% Generate rewards.
numInter = size(I,1);
numEdge = size(I,2);
v0 = converterMPH(70);                  % average velocity limitation: 70mph 
rng(1)
vmax = v0 * (1 + rand(numEdge,1));      % generate maximum velocity for each
                                        % road segment.
len0 = 10 * 1000;                       % average road length: 10km               
len = len0 * (1 + rand(numEdge,1));     % generate road lenth for each
                                        % road segment.
% Generate roads.                                        
road12 = road(len(1),vmax(1));
road13 = road(len(2),vmax(2));
road24 = road(len(3),vmax(3));
road25 = road(len(4),vmax(4));
road35 = road(len(5),vmax(5));
road46 = road(len(6),vmax(6));
road56 = road(len(7),vmax(7));