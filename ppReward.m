function reward = ppReward(vmax,l,alpha,m,Voc,c1,gamma,Crr, Af, Cd, g, rho)

frr = Crr * m * g * cos(alpha);        % rolling resistance
fad = 0.5 * rho * Af * Cd * vmax^2;    % air resistance 
fgx = m * g * sin(alpha);              % grade resistance
ft = frr + fad + fgx;                  % traction force

Ia = ft / c1;        % armature current
Ib = gamma * Ia;     % battery current

tf = l / vmax;       % This is length "l", not number 1.
reward = Voc * Ib * tf;
end