%% Updates plot with new data
function plotUpdate()
    global tip_points
    global all_points
    global force_vals
    global armViz
    global tipViz
    global forceVizx
    global forceVizy
    global forceVizz
    
    %Get data
    allPoints = all_points;
    tipPoints = tip_points;
    forceVals = force_vals;
    %Length of links
    l = 1;

    %Get arm data, inserting 0s before first column
    x = allPoints(1,1:4);
    x = [0, x(:,:)];
    y = allPoints(1,5:8);
    y = [0, y(:,:)];
    z = allPoints(1,9:12);
    z = [0, z(:,:)];
    
    %Get tip history
    tipx = tipPoints(:,1);
    tipy = tipPoints(:,2);
    tipz = tipPoints(:,3);
    
    % Get current tip position
    curtip = [allPoints(1,4),allPoints(1,8),allPoints(1,12)];
    curtipx = curtip(1);
    curtipy = curtip(2);
    curtipz = curtip(3);
    
    %Get force data, starting at tip and projecting out in three directions
    forcex = [curtipx,curtipx+(forceVals(end,1))/10];
    forcey = [curtipy,curtipy+(forceVals(end,2))/10];
    forcez = [curtipz,curtipz+(forceVals(end,3))/10];
    
    %Update plot with new data
    set(armViz,'XData',x,'YData',y,'ZData',z);
    set(tipViz,'XData',tipx,'YData',tipy,'ZData',tipz);
    set(forceVizx,'XData',forcex,'YData',[curtipy, curtipy],'ZData',[curtipz, curtipz]);
    set(forceVizy,'XData',[curtipx, curtipx],'YData',forcey,'ZData',[curtipz, curtipz]);
    set(forceVizz,'XData',[curtipx, curtipx],'YData',[curtipy, curtipy],'ZData',forcez);
    drawnow;
end