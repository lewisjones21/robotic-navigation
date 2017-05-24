function [] = PlotTriangles(triangles, points)
%PLOTTRIANGLES Draws the given triangles
%   

%Validate the inputs
if size(points, 1) <= 0
    warning('No points given');
    return;
end
if size(points, 2) ~= 3
    warning('Points given in incorrect format');
    return;
end
if size(triangles, 1) <= 0
    warning('No triangles given');
    return;
end
if size(triangles, 2) ~= 3
    warning('Triangles given in incorrect format');
    return;
end

savedhold = ishold;

span = [ min(points(:,1)) max(points(:,1)) min(points(:,2)) max(points(:,2)) min(points(:,3)) max(points(:,3)) ];

figure(1);

colormap hsv;

if (size(triangles, 2) == 3)%These are not classified triangles
    
    C = [ 1 ];
    %Allow the first triangle to reset the figure if hold is off
    fill3(points(triangles(1,:),1), points(triangles(1,:),2), points(triangles(1,:),3), C);
    hold on;
    %Plot the remainder of the triangles
    for p = 2:size(triangles, 1)

        fill3(points(triangles(p,:),1), points(triangles(p,:),2), points(triangles(p,:),3), C);

    end
    
elseif (size(triangles, 2) == 4)%These are classified polygons
        
    C = [ 0 1 0; 0 0 1; 1 0 0 ];
    %Allow the first triangle to reset the figure if hold is off
    XYZ = [ points(triangles(1, 1:3),:) ];
    fill3(XYZ(:,1), XYZ(:,2), XYZ(:,3), C(triangles(1,4),:));
    %Plot the remainder of the triangles
    hold on;
    for p = 2:size(triangles, 1)

        XYZ = [ points(triangles(p, 1:3),:) ];
        fill3(XYZ(:,1), XYZ(:,2), XYZ(:,3), C(triangles(p,4),:));

    end
    
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
