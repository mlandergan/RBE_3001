function jointAngles = inversePosKin(px, py, pz)
l1 = 9.0;  % cm
l2 = 16.6; % cm
l3 = 20.0; % cm

%Set up constants
pz = pz - 12;
r = sqrt(px.^2 +py.^2);
z =  l1 - pz;
b = atan2(pz-l1, r);

%Calculate q0
q0 = atan2(py, px);

mag1 = sqrt(r.^2 + z.^2);
mag2 = l3.^2 - l2.^2;

%calculate gamma
y = acos((mag2 - (mag1.^2)) / (-2*l2*mag1));

mag4 =  r.^2 + z.^2;
mag5 = l2.^2 + l3.^2;

%Calculate q2
q2 =  -acos((mag4 - mag5)/ (-2*l2*l3)) + 0.5*pi;

%Calculate q1
q1 = b + y;

% convert radians to degrees
q0 = q0*(180/pi);
q1 = q1*(180/pi);
q2 = q2*(180/pi) * -1;

jointAngles(1,1) = q0;
jointAngles(1,2) = q1;
jointAngles(1,3) = q2;

end