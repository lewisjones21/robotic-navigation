function [] = PlotPath(pathWaypoints, colour, noIndices, linesOnly)
%PLOTPATH Draws the given path
%   Plots the series of waypoints, given as rows containing triplets of
%   coordinates, in the given colour

%Validate the inputs
if size(pathWaypoints, 1) <= 0
    warning('No path waypoints given');
    return;
end
if size(pathWaypoints, 2) ~= 3
    warning('Path waypoints given in incorrect format');
    return;
end

savedhold = ishold;

figure(1);

lastIndex = size(pathWaypoints,1);

%Draw the interconnecting lines
line(pathWaypoints(1,1), pathWaypoints(1,2), pathWaypoints(1,3), 'Color', colour,'LineWidth',3);
hold on;
for l = 2:lastIndex
    line(pathWaypoints(:,1), pathWaypoints(:,2), pathWaypoints(:,3), 'Color', colour,'LineWidth',3);
end

if nargin < 4 || ~linesOnly
    %Draw the path waypoints (highlighted)
    scatter3(pathWaypoints(:,1), ...
            pathWaypoints(:,2), ...
            pathWaypoints(:,3), ...
                144, 'MarkerFaceColor', colour)
    scatter3(pathWaypoints([1, lastIndex],1), ...
            pathWaypoints([1, lastIndex],2), ...
            pathWaypoints([1, lastIndex],3), ...
                400, 'MarkerFaceColor', colour)
end

if nargin < 3 || ~noIndices
    %Draw indices showing the order of the path points
    a = [1:size(pathWaypoints, 1)]'; b = num2str(a); c = cellstr(b);
    offset = ones(size(pathWaypoints, 1), 1) * 0.05;
    text(pathWaypoints(:,1) - offset, ...
        pathWaypoints(:,2), ...
        pathWaypoints(:,3) + offset, c);
end

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
