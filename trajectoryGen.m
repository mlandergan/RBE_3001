%% Function to generate a smooth trajectory
% Takes in an initial time (t_i), final time (t_f), initial and final position, initial velocity (v_i),
% final velocity (v_f), and time step
% and iterator. 
% Returns a matrix with the time step, position, velocity, and acceleration values of the generated trajectory
% Created by Mark Landergan
function out = trajectoryGen(t_i, t_f, q_i, q_f, v_i, v_f, dt)
    out = zeros((t_f/dt),4);
    for i = 1:(t_f/dt)
        syms a0 a1 a2 a3
        ct = t_i + (dt*i);

      if((v_i == 0) && (v_f == 0))  % if start and end velocities are 0, use pre-defined coefficents 
      coefficients = [q_i,0,((3/t_f.^2)*(q_f-q_i)),((-2/t_f.^3)*(q_f-q_i))];
      qt = double(coefficients(1) + coefficients(2)*ct + coefficients(3)*ct.^2 + coefficients(4)*ct.^3);
      
      else
     
       % systems of equations for initial position, initial velocity, final
        % position and final velocity
        eqn1 = a0+(a1*t_i)+(a2*t_i.^2)+(a3*t_i.^3) == q_i;
        eqn2 = a1 + (2*a2*t_i) + (3*a3*t_i.^2) == v_i;
        eqn3 = a0 + (a1*t_f) + (a2*t_f.^2) + (a3*t_f.^3) == q_f;
        eqn4 = a1 + (2*a2*t_f) + (3*a3*t_f.^2) == v_f; 
        coefficients_symb = solve([eqn1, eqn2, eqn3, eqn4], [a0, a1, a2, a3]);
        a0 = coefficients_symb.a0;
        a1 = coefficients_symb.a1;
        a2 = coefficients_symb.a2;
        a3 = coefficients_symb.a3;
        coefficients = [a0,a1,a2,a3];
   
        qt = double(coefficients(1) + coefficients(2)*ct + coefficients(3)*ct.^2 + coefficients(4)*ct.^3);
      end
        
        vt = double(coefficients(2) + 2*coefficients(3)*ct + 3*coefficients(4)*ct.^2);
        at = double(2*coefficients(3) + 6*coefficients(4)*ct);
        out(i,:) = [ct,qt,vt,at];
    end
 end

 

