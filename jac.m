%% Calculates the jacobian based on current arm position 
function out = jac(angles)
q1 = angles(1);
q2 = angles(2);
q3 = angles(3);
% Link Lengths
l2 = .166; %m
l3 = .200; %m

out = [ -sin(q1)*(l3*cos(q2 + q3) + l2*cos(q2)), -cos(q1)*(l3*sin(q2 + q3) + l2*sin(q2)), -l3*sin(q2 + q3)*cos(q1);...
   cos(q1)*(l3*cos(q2 + q3) + l2*cos(q2)), -sin(q1)*(l3*sin(q2 + q3) + l2*sin(q2)), -l3*sin(q2 + q3)*sin(q1);...
                                        0,            l3*cos(q2 + q3) + l2*cos(q2),          l3*cos(q2 + q3)];

end