function [v,v1,v2] = gipps(deltaT,v_,aMax,vDes,bMax,xn_,x_,Ln,vn_,bnHat)
% The Gipps Model
% This function is based on Eq. (2.12) in elefteriadou14 
% v is the speed of vehicle n+1 at time t+Delta_t
% deltaT is the apparent reation time, a constant for  all vehicles
% v_ is the speed of vehicle n+1 at time t
% aMax is the maximum acceleration which the driver of vehicle n+1 whishes
%      whishes to undertake
% vDes is the speed at which the driver of vehicle n+1 whishes to travel
% bMax is the actual most severe deceleration rate that the driver of
%      vehicle n+1 wishes to undertake (b(n+1)<0)
% xn_ is the location of the front of vehicle n at time t
% x_ is the location of the front of vehicle n+1 at time t
% Ln  is the effective size of vehicle n; that is the physical length plus
%     a margin into which the following vehicle is not willing to introduce
%     even at rest
% vn_ is the speed of vehicle n at time t
% bnHat is the most severe deceleration rate that vehicle n+1 estimates for
%       vehicle n

v1 = v_ + 2.5*aMax*deltaT*(1 - v_/vDes)*sqrt(0.025 + v_/vDes);
v2 = bMax*deltaT + sqrt(bMax^2*deltaT^2 - bMax*(2*(xn_ - Ln - x_)-v_*deltaT-vn_^2/bnHat));
v = min([v1, v2]);
end

