%% activateGripper takes in pp, a packet processor object defined in hid

% takes in action, which can be either 0.3 or 0.7. A value of 0.7 will close
% the gripper. A value of 0.3 will open the gripper
function activateGripper(pp, action)

values = zeros(15, 1, 'single');
values(1) = action; % package data 
pp.command(40, values); % send the data

end