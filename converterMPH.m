function [mps kph fps]= converterMPH(MPH)
% Convert mph to m/s.

kph = 1.609344 * MPH;
mps = 0.44704 * MPH;
fps = 1.46666667 * MPH;
end