clc; clear; clf;

javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

delete '*.csv';
delete 'CSVs/*.csv';

pp = PacketProcessor(7); % create new Packet processor object
gainValues = zeros(15, 1, 'single'); % create a 15x1 matrix of zeros for gainValues command

%Arrays for plot data
global elapsed_time
global tip_points
global all_points
global joint_angles
global x_traj
global y_traj
global z_traj
global torque_vals
global force_vals
global weight

% initialize arrays to be empty
elapsed_time = [];
tip_points = [];
all_points = [];
joint_angles = [];
x_traj = [];
y_traj = [];
z_traj = [];
torque_vals = [];
force_vals = [];

% set gain values
gainValues(1:3,:) = [0.001,0.0015,0.01]; 
gainValues(4:6,:) = [0.001,0.002,0.014];
gainValues(7:9,:) = [0.0025,0.0,0.014];

pp.command(39, gainValues); % send the gain values

RobotState = "DetermineColor"; % initialize state to DetermineColor
start = tic; % start timer
values = zeros(15, 1, 'single'); % create 15x1 matrix of zeros
armviz3();
while(1) % remain in state machine
switch RobotState
    case "DetermineColor"
         move2angle(pp,start,[0,5,0]); % go home position
         
         activateGripper(pp,0); % open the gripper
         blueObjects = getBlueXY; % get x,y position (cm) of any blue objects
         yellowObjects = getYellowXY; % get x,y position (cm) of any yellow objects
         greenObjects = getGreenXY; % get x,y position (cm) of any green objects
         RobotState = "MoveToObject";

    case "MoveToObject"
        disp("MoveToObject");
        % logic to determine which color to go to
        
        xoff = 19.1;
        yoff = 1.5;
        if(~(isnan(yellowObjects(1,1))))%20.1
            goalPos = [yellowObjects(1)+xoff,-yellowObjects(1,2)+yoff,5]; % create goal position from tracked object and apply offsets
            currColor = "yellow";
            disp("yellow");
        elseif(~(isnan(blueObjects(1,1))))
            goalPos = [blueObjects(1)+xoff,-blueObjects(1,2)+yoff,5]; % create goal position from tracked object and apply offsets
            currColor = "blue";
            disp("blue");
        elseif(~(isnan(greenObjects(1,1))))
            goalPos = [greenObjects(1)+xoff,-greenObjects(1,2)+yoff,5]; % create goal position from tracked object and apply offsets
            currColor = "green";
            disp("green");            
        end
        
        % calculate traj from origin to 5 cm above centroid of colored object
        trajx1 = trajectoryGen(0, 10, 9, goalPos(1), 0, 0, 0.1); % create path of positions from 9 cm in the x direction to goal x positon 
        trajy1 = trajectoryGen(0, 10, 0, goalPos(2), 0, 0, 0.1); % create path of positions from 0 cm in the y direction to goal y positon 
        trajz1 = trajectoryGen(0, 10, 5, goalPos(3)+5, 0, 0, 0.1); % create path of positions from 5 cm in the z direction to goal z positon + 5 cm 
       
        % calculate traj from 5 cm above centroid of colored object to object
        trajx2 = trajectoryGen(0, 10, goalPos(1), goalPos(1), 0, 0, 0.1); 
        trajy2 = trajectoryGen(0, 10, goalPos(2), goalPos(2), 0, 0, 0.1); 
        trajz2 = trajectoryGen(0, 10, goalPos(3)+5, goalPos(3)-1, 0, 0, 0.1); 
        
        % determine angavgfles to get to goal position and move there
        move2xyz(pp,start,trajx1,trajy1,trajz1,0);
        move2xyz(pp,start,trajx2,trajy2,trajz2,0); 
           
        % set RobotState to GrabObject
        RobotState = "GrabObject"; 

    case "GrabObject"
        activateGripper(pp,1); % close the gripper
        pause(2);
        RobotState = "WeighObject"; % set RobotState to WeighObject
      
    case "WeighObject"
         xheight = 16.6;
         yheight = 0;
         zheight = 35;
         trajxLift = trajectoryGen(0, 5, goalPos(1), xheight, 0, 0, 0.1); % create path of positions from 0 cm in the x direction to goal x positon 
         trajyLift = trajectoryGen(0, 5, goalPos(2), yheight, 0, 0, 0.1); % create path of positions from 0 cm in the y direction to goal y positon 
         trajzLift = trajectoryGen(0, 5, goalPos(3), zheight, 0, 0, 0.1); % create path of positions from 0 cm in the z direction to goal z positon 
         move2xyz(pp,start,trajxLift,trajyLift,trajzLift,1);
              
         weight = determineWeight(); %  determine weight  
         plotUpdate();
         RobotState = "SortObject";
         
    case "SortObject"
        if((currColor == "yellow") && (weight == 0))
            % put object in yellow light section
            trajx2 = trajectoryGen(0, 10, xheight, 0, 0, 0, 0.1); % create path of positions from 0 cm in the x direction to goal x positon 
            trajy2 = trajectoryGen(0, 10, yheight, -19, 0, 0, 0.1); % create path of positions from 0 cm in the y direction to goal y positon 
            trajz2 = trajectoryGen(0, 10, zheight, 8, 0, 0, 0.1); % create path of positions from 0 cm in the z direction to goal z positon       
        end
        
        if((currColor == "yellow") && (weight == 0.2))
            % put object in yellow heavy section
            trajx2 = trajectoryGen(0, 10, xheight, 0, 0, 0, 0.1); % create path of positions from 0 cm in the x direction to goal x positon 
            trajy2 = trajectoryGen(0, 10, yheight, 19, 0, 0, 0.1); % create path of positions from 0 cm in the y direction to goal y positon 
            trajz2 = trajectoryGen(0, 10,  zheight, 8, 0, 0, 0.1); % create path of positions from 0 cm in the z direction to goal z positon 
        end        
        
        if((currColor == "blue") && (weight == 0))
            % put object in blue light section
            trajx2 = trajectoryGen(0, 10, xheight, 12, 0, 0, 0.1); % create path of positions from 0 cm in the x direction to goal x positon 
            trajy2 = trajectoryGen(0, 10, yheight, -19, 0, 0, 0.1); % create path of positions from 0 cm in the y direction to goal y positon 
            trajz2 = trajectoryGen(0, 10, zheight, 8, 0, 0, 0.1); % create path of positions from 0 cm in the z direction to goal z positon  
        end
        
        if((currColor == "blue") && (weight == 0.2))
            % put object in blue heavy section
            trajx2 = trajectoryGen(0, 10, xheight, 12, 0, 0, 0.1); % create path of positions from 0 cm in the x direction to goal x positon 
            trajy2 = trajectoryGen(0, 10, yheight, 19, 0, 0, 0.1); % create path of positions from 0 cm in the y direction to goal y positon 
            trajz2 = trajectoryGen(0, 10, zheight, 8, 0, 0, 0.1); % create path of positions from 0 cm in the z direction to goal z positon  
        end
        
        if((currColor == "green") && (weight == 0))
            % put object in green light section
            trajx2 = trajectoryGen(0, 10, xheight, 24, 0, 0, 0.1); % create path of positions from 0 cm in the x direction to goal x positon 
            trajy2 = trajectoryGen(0, 10, yheight, -19, 0, 0, 0.1); % create path of positions from 0 cm in the y direction to goal y positon 
            trajz2 = trajectoryGen(0, 10, zheight, 8, 0, 0, 0.1); % create path of positions from 0 cm in the z direction to goal z positon 
        end
        
        if((currColor == "green") && (weight == 0.2))
            % put object in green heavy section
            trajx2 = trajectoryGen(0, 10, xheight, 24, 0, 0, 0.1); % create path of positions from 0 cm in the x direction to goal x positon 
            trajy2 = trajectoryGen(0, 10, yheight, 18, 0, 0, 0.1); % create path of positions from 0 cm in the y direction to goal y positon 
            trajz2 = trajectoryGen(0, 10, zheight, 8, 0, 0, 0.1); % create path of positions from 0 cm in the z direction to goal z positon  
        end
        move2xyz(pp,start,trajx2,trajy2,trajz2, 0); % drive to calculated trajectory
        activateGripper(pp,0); % open gripper
        pause(3); 
        goalPos = []; % clear goal position 
        RobotState = "DetermineColor"; % set state to DetermineColor to restart state machine
        
  end
end
pp.shutdown()
clear java;
