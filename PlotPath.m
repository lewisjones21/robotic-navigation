function [] = PlotPath(pathWaypoints, colour)

savedhold = ishold;

figure(1);

lastIndex = size(pathWaypoints,1);

%Draw the interconnecting lines
line(pathWaypoints(1,1), pathWaypoints(1,2), pathWaypoints(1,3), 'Color', colour,'LineWidth',3);
hold on;
for l = 2:lastIndex
    line(pathWaypoints(:,1), pathWaypoints(:,2), pathWaypoints(:,3), 'Color', colour,'LineWidth',3);
end

%Draw the path waypoints (highlighted)
scatter3(pathWaypoints(:,1), pathWaypoints(:,2), pathWaypoints(:,3), 144, 'MarkerFaceColor', colour)
%Draw the path waypoints (highlighted)
scatter3(pathWaypoints([1, lastIndex],1), pathWaypoints([1, lastIndex],2), pathWaypoints([1, lastIndex],3), ...
    400, 'MarkerFaceColor', colour)

%Draw indices showing the order of the path points
a = [1:size(pathWaypoints, 1)]'; b = num2str(a); c = cellstr(b);
text(pathWaypoints(:,1), pathWaypoints(:,2), pathWaypoints(:,3), c);

%axis(span);
grid on;
xlabel('x');
ylabel('y');
zlabel('z');
camproj('perspective')

%Reset the hold state to what it was before starting this function
if savedhold
    hold on;
else
    hold off;
end

end
