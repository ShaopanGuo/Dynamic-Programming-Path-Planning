function mps = converterMPH(MPH)
% Convert MPH to m/s.

kph = 0.6213712 * MPH;
mps = (kph*1000) / (60*60);
end