function [  ] = PlotSharedSides( sharedSides, triangles, points )
%PLOTSHAREDEDGES Draws lines between triangles with shared edges
%   Draws a plot similar to the Voronoi tessellation

savedhold = ishold;

figure(1);

%As a test, first just highlight shared edges
%XYZ = [ points(sharedSides(:,3),:) points(sharedSides(:,4),:) ];

%Find the relevant triangle vertices
firstTriangleIndices = sharedSides(:,1);
secondTriangleIndices = sharedSides(:,2);
firstTrianglesVertexIndices = triangles(firstTriangleIndices,:);
secondTrianglesVertexIndices = triangles(secondTriangleIndices,:);
firstTriangleCentres = (points(firstTrianglesVertexIndices(:,1),:) ...
                        + points(firstTrianglesVertexIndices(:,2),:) ...
                        + points(firstTrianglesVertexIndices(:,3),:)) / 3;
secondTriangleCentres = (points(secondTrianglesVertexIndices(:,1),:) ...
                        + points(secondTrianglesVertexIndices(:,2),:) ...
                        + points(secondTrianglesVertexIndices(:,3),:)) / 3;

X = [ firstTriangleCentres(:,1) secondTriangleCentres(:,1) ];
Y = [ firstTriangleCentres(:,2) secondTriangleCentres(:,2) ];
Z = [ firstTriangleCentres(:,3) secondTriangleCentres(:,3) ];

% leftPointIndices = sharedSides(:,3);
% rightPointIndices = sharedSides(:,4);
% leftPointCoordinates = points(leftPointIndices,:);
% rightPointCoordinates = points(rightPointIndices,:);

%Draw lines across shared edges
line(X(1,:), Y(1,:), Z(1,:), 'Color', 'magenta','LineWidth',1.5);
hold on;
for l = 2:size(X,1)
    line(X(l,:), Y(l,:), Z(l,:), 'Color', 'magenta','LineWidth',1.5);
end
%line(XYZ(:, [1 4]), XYZ(:, [2 5]), XYZ(:, [3 6]));

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

