% main function
clc; clear; close all

% Generate a map.
s = [1 1 2 2 3 4 5];
t = [2 3 4 5 5 6 6];
G = digraph(s,t);         % This map is a digraph.
I = full(incidence(G)); 
plot(G)

% Generate rewards.
numInter = size(I,1);
numEdge = size(I,2);
v0 = converterMPH(70);                  % average velocity limitation: 70mph 
rng(1)
vmax = v0 * (1 + rand(numEdge,1));      % generate maximum velocity for each
                                        % road segment.
len0 = 10 * 1000;                       % average road length: 10km               
len = len0 * (1 + rand(numEdge,1));     % generate road lenth for each
                                        % road segment.