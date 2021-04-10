clear; close all; clc
vDes = 75;        % The desired maximum speed of the following vehicle
                  % in mph
[~,~,vDes] = converterMPH(vDes);    % in ft/s                  
aMax = 6.5;       % The maximum acceleration which the following vehicle 
                  % wishes to take, in ft/s^2
bMax = -9.5;      % The most deceleration that the follower wishes to 
                  % undertake, in ft/s^2
bnHat = -11.5;    % The most severe deceleration rate that vehicle n+1 
                  % estimate for vehicle n, in ft/s^2
Ln = 25;          % The effective vehicle length, in ft.
dt = 1;       % the apparent reation time, in s.

v_ = 79.64;     % in fts
% v_ = 54.3;      % in mph
xn_ = 0;        % in ft
x_ = -120;      % in ft
vn_ = 76.81;    % in fts

[v,v1,v2] = gipps(dt,v_,aMax,vDes,bMax,xn_,x_,Ln,vn_,bnHat);
[v1mph,~,~] = converterFPS(v1);
[v2mph,~,~] = converterFPS(v2);
[vmph,~,~] = converterFPS(v);

                 