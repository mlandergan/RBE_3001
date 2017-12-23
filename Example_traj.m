clc; clear; clf;
trajx1 = trajectoryGen(0, 10, 10, 55, 0, 0, 0.1) % create path of positions from 9 cm in the x direction to goal x positon 

xct = trajx1(:,1);
xqt = trajx1(:,2);

plot(xct, xqt);
hold on;