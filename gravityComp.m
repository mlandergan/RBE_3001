%% Gravity Compensation Calculation
% Takes in the 3 current joint angles and the mass of the current object
% and returns a gravity compensation value based on the dynamics
function grav = gravityComp(angles,m)
theta2 = angles(2);
theta3 = angles(3);
l2 = 16.6;
l3 = 20.0;
g = 9.81; % m/s^2
Kg = 0.00065;

% Gravity compensation terms from output of dynamics.m
g2 = g*m*(l2*cos(theta2) + l3*cos(theta2)*cos(theta3) - l3*sin(theta2)*sin(theta3)) + g*l2*m*cos(theta2);
gtip = g*l3*m*cos(theta2 + theta3);

grav = (g2+gtip)*Kg
end