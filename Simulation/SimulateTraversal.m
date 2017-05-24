function [] = SimulateTraversal( pathWaypoints, colour )
%SIMULATETRAVERSAL Draw a circle traversing the path
%   Simulates the motion of the robot as a visual illustration of how the
%   path would be followed

if size(pathWaypoints, 1) <= 0
    warning('No path waypoints given');
    return;
end
savedhold = ishold;

robotPosition = pathWaypoints(1,:);

handle = scatter3(robotPosition(1), robotPosition(2), robotPosition(3), ...
    1600, 'MarkerFaceColor', colour);


for p = 2:size(pathWaypoints, 1)
    segmentLength = norm(pathWaypoints(p,:) - pathWaypoints(p-1,:));
    if segmentLength > 0
        for i = 0:0.05/segmentLength:1
            robotPosition = pathWaypoints(p,:) * i ...
                                    + pathWaypoints(p-1,:) * (1 - i);
            set(handle, 'XData', robotPosition(1), ...
                        'YData', robotPosition(2), ...
                        'ZData', robotPosition(3));
            pause(0.02);
        end
    end
end

set(handle, 'XData', pathWaypoints(size(pathWaypoints, 1),1), ...
            'YData', pathWaypoints(size(pathWaypoints, 1),2), ...
            'ZData', pathWaypoints(size(pathWaypoints, 1),3));


if savedhold
    hold on;
else
    hold off;
end


end

