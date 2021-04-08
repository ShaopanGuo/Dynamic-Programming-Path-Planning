% main function

% Generate a map.
s = [1 1 2 2 3 4 5];
t = [2 3 4 5 5 6 6];
G = digraph(s,t);         % This map is a digraph.
I = full(incidence(G)); 
plot(G)

% Generate rewards.
numInter = size(I,1);
numEdge = size(I,2);
vbar = converterMPH(70)
vmax = rand(numEdge,1);