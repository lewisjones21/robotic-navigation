function [] = PlotWaypoints(waypoints, colour, drawIndices)
%PLOTWAYPOINTS Draws the given waypoints
%   

%Validate the inputs
if size(waypoints, 1) <= 0
    warning('No waypoints given');
    return;
end
if size(waypoints, 2) ~= 3
    warning('Waypoints given in incorrect format');
    return;
end

if nargin < 3
    drawIndices = 0;
    if nargin < 2
        colour = 'white';
    end
end

savedhold = ishold;

figure(1);

%span = [ min([points(:,1); xlim(1)]) max([points(:,1); xlim(2)]) ...
%        min([points(:,2); ylim(1)]) max([points(:,2); ylim(2)]) ...
%        min([points(:,3); zlim(1)]) max([points(:,3); zlim(2)]) ];

scatter3(waypoints(:,1), waypoints(:,2), waypoints(:,3), 'o', ...
    'MarkerFaceColor', colour)
    
if drawIndices
    a = [1:size(waypoints, 1)]'; b = num2str(a); c = cellstr(b);
    text(waypoints(:,1), waypoints(:,2), waypoints(:,3), c);
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
