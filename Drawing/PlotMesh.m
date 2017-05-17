function [] = PlotMesh(traversableTris, wallTris, points)
%PLOTMESH Plots the environment mesh
%   Plots the map of the environment, with walls in red and traversable
%   areas in green through yellow based on slope

savedhold = ishold;

span = [ min(points(:,1)) max(points(:,1)) min(points(:,2)) max(points(:,2)) min(points(:,3)) max(points(:,3)) ];

figure(1);

colormap hsv;

%Allow the first triangle to reset the figure if hold is off
fill3(points(traversableTris(1,:),1), points(traversableTris(1,:),2), points(traversableTris(1,:),3), 'g');
hold on;
%Plot the remainder of the traversable triangles
for p = 2:size(traversableTris, 1)

    fill3(points(traversableTris(p,:),1), points(traversableTris(p,:),2), points(traversableTris(p,:),3), 'g');

end

%Plot the wall triangles
for p = 1:size(wallTris, 1)

    fill3(points(wallTris(p,:),1), points(wallTris(p,:),2), points(wallTris(p,:),3), 'r');

end

axis(span);
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

% function [] = PlotTriangles(triangles, points)
% 
% savedhold = ishold;
% 
% span = [ min(points(:,1)) max(points(:,1)) min(points(:,2)) max(points(:,2)) min(points(:,3)) max(points(:,3)) ];
% 
% figure(1);
% 
% colormap hsv;
% 
% C = [0 0.33 0.66];
% %fill3(points(triangles(:, :),1), points(triangles(:, :),2), points(triangles(:, :),3), C);
% 
% %Allow the first triangle to reset the figure if hold is off
% fill3(points(triangles(1, :),1), points(triangles(1, :),2), points(triangles(1, :),3), C);
% hold on;
% for t = 2:size(triangles, 1)
% 
%     fill3(points(triangles(t, :),1), points(triangles(t, :),2), points(triangles(t, :),3), C);
%     
% end
% 
% grid on;
% axis(span);
% xlabel('x');
% ylabel('y');
% zlabel('z');
% camproj('perspective')
% 
% %Reset the hold state to what it was before starting this function
% if savedhold
%     hold on;
% else
%     hold off;
% end
% 
% end
