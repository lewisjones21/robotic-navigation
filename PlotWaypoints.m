function [] = PlotWaypoints(points, colour, drawIndices)

if nargin < 2
   drawIndices = 0;
end

savedhold = ishold;

figure(1);

%span = [ min([points(:,1); xlim(1)]) max([points(:,1); xlim(2)]) ...
%        min([points(:,2); ylim(1)]) max([points(:,2); ylim(2)]) ...
%        min([points(:,3); zlim(1)]) max([points(:,3); zlim(2)]) ];

scatter3(points(:,1), points(:,2), points(:,3), 'o', 'MarkerFaceColor', colour)
    
if drawIndices
    a = [1:size(points, 1)]'; b = num2str(a); c = cellstr(b);
    text(points(:,1), points(:,2), points(:,3), c);
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
