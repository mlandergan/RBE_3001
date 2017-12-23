%% Computes forces at the tip of the arm
% Converts from joint torques to tip forces by inverting the force-torque
% relationship.
function calcForce()
    global torque_vals
    global force_vals
    global joint_angles
    % Computes Jacobian based on current angles, transposes, inverts, then
    % multiplies by current torques measured from strain gauges
    inv_jac = (jac(joint_angles(end,:))')^-1;
    currForce = inv_jac*torque_vals(end,:)';
    force_vals = [force_vals; currForce'];
    force_vals(end,3) = force_vals(end,3)+1;
end