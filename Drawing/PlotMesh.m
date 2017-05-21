function [] = PlotMesh(traversableTriIndices, wallTriIndices, triangles, points, triangleSlopes)
%PLOTMESH Plots the environment mesh
%   Plots the map of the environment, with walls in red and traversable
%   areas in green through yellow based on slope (if given)

savedhold = ishold;

span = [ min(points(:,1)) max(points(:,1)) ...
         min(points(:,2)) max(points(:,2)) ...
         min(points(:,3)) max(points(:,3)) ];

figure(1);

naughtToOne = 0:0.01:1;
map = [naughtToOne', ones(101, 1), zeros(101, 1)];
colormap(map);

c = triangleSlopes;

if size(traversableTriIndices, 1) > 0
    %Allow the first triangle to reset the figure if hold is off
    fill3(points(triangles(traversableTriIndices(1),:),1), ...
            points(triangles(traversableTriIndices(1),:),2), ...
            points(triangles(traversableTriIndices(1),:),3), ...
            c(traversableTriIndices(1)));

    hold on;
    %Plot the remainder of the traversable triangles
    for t = 2:size(traversableTriIndices, 1)

        fill3(points(triangles(traversableTriIndices(t),:),1), ...
            points(triangles(traversableTriIndices(t),:),2), ...
            points(triangles(traversableTriIndices(t),:),3), ...
            c(traversableTriIndices(t)));

    end
else
    warning('No traversable triangles given');
end

if size(wallTriIndices, 1) > 0
    %Plot the wall triangles
    for t = 1:size(wallTriIndices, 1)
        
        fill3(points(triangles(wallTriIndices(t),:),1), ...
            points(triangles(wallTriIndices(t),:),2), ...
            points(triangles(wallTriIndices(t),:),3), 'r');
        
    end
else
    warning('No wall triangles given');
end

axis(span);
axis equal;
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
