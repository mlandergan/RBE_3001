%% takes in three matrixes, representing the trajectory from an initial positon to a goal position in the x,y,z 
function move2xyz(pp,start, trajx, trajy, trajz,weigh)
 path = []; % create an empty array to store path 
 global torque_vals
   
 for i=1:size(trajx,1)
    path = [path; inversePosKin(trajx(i,2),trajy(i,2),trajz(i,2))]; % calculate joint angles to get to goal position
 end
        
 for i=1:size(path,1)
    move2angle(pp,start,[path(i,1), path(i,2), path(i,3)]); % drive to calculated joint angles
  
  if(weigh == 1)  
  if(i == size(path,1)-1)
   for k=1:75    
    if(~isempty(torque_vals))
      move2angle(pp,start,[path(i,1), path(i,2), path(i,3)]); % drive to calculated joint angles
      calcForce();
    end
   end
  end
  end
  
 end

end