%% Visualize arm in 3D
function armviz3()

    global armViz
    global tipViz
    global forceVizx
    global forceVizy
    global forceVizz

    view(3);
    hold on;
    axis([-2, 2, -2, 2, 0, 3])
    box on;
    grid on;
    % Initialize empty plots with labels
    armViz = plot3(NaN,NaN,NaN,'-');
    tipViz = plot3(NaN,NaN,NaN);
    forceVizx = plot3(NaN,NaN,NaN,'.-');
    forceVizy = plot3(NaN,NaN,NaN,'.-');
    forceVizz = plot3(NaN,NaN,NaN,'.-');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    hold off;
end
