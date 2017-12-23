function move2angle(pp,start,angles)
global elapsed_time
global tip_points
global all_points
global joint_angles
global x_traj
global y_traj
global z_traj
global torque_vals
global weight

% offsets for Torque calculations
torqueOffset1 = 2071;
torqueOffset2 = 2091;
torqueOffset3 = 1894;

count = 0;
setpoints = zeros(1,3);
setpoints(1,1) = angle2enc(angles(1,1)); % get desired angle and convert to ticks
setpoints(1,2) = angle2enc(angles(1,2)); 
setpoints(1,3) = angle2enc(angles(1,3));

values = zeros(15, 1, 'single');

%pp.command(38, values);
err = 100;

% keep sending setpoints as goal values until the arm is withing 10 degree of error
while(err > 50)
        count = count +1;
		% set desired setpoints
		values(1) = setpoints(1,1);
		values(4) = setpoints(1,2);
		values(7) = setpoints(1,3);
        
	    returnValues = pp.command(37, values); % send setpoints
        valuesTransposed = transpose(returnValues);      
         %Convert raw encoder data to joint and tip positions
        averageValues = runavg(valuesTransposed); % running average on data
        angleValues = encmap(averageValues); % map encoder ticks to angles
        xyzPoints = kinMat(angleValues); % calculate x,y,z points of joints and endpoint
        curTipPoints = [xyzPoints(1,4),xyzPoints(1,8),xyzPoints(1,12)];   
        
        % Set gravity compensation terms
        g = gravityComp(angleValues, weight);
        values(3) = g;
        values(6) = g;
        
        % gets current torque values from packet processor commands and
        % applies offsets and scale
        curr_torque_vals = [valuesTransposed(3)-torqueOffset1,valuesTransposed(6)-torqueOffset2,valuesTransposed(9)-torqueOffset3]/(178.5);
        torque_vals = [torque_vals; curr_torque_vals]; % appends current torque value
        
        tip_points = [tip_points; curTipPoints]; % record the tip points
        all_points = [xyzPoints]; %Record xyz positions of all joints
        joint_angles = [joint_angles; angleValues];%Record current joint angles
        
        time = toc(start);
        elapsed_time = [elapsed_time; time]; % appends elapsed time
        calcForce();
        if(count > 1) 
            break;
        end
end
end