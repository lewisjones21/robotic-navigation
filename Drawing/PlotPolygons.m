function [] = PlotPolygons(polygons, points)

savedhold = ishold;

span = [ min(points(:,1)) max(points(:,1)) min(points(:,2)) max(points(:,2)) min(points(:,3)) max(points(:,3)) ];

figure(1);

colormap hsv;

if (size(polygons, 2) == 3)%These are not classified polygons
    
    C = [ 1 ];
    %Allow the first polygon to reset the figure if hold is off
    fill3(points(1,polygons(1,:)), points(2,polygons(1,:)), points(3,polygons(1,:)), C);
    hold on;
    for p = 2:size(polygons, 1)

        fill3(points(1,polygons(p,:)), points(2,polygons(p,:)), points(3,polygons(p,:)), C);

    end
    
else if (size(polygons, 2) == 4)%These are classified polygons
        
    C = [ 0 0.5 1 ];
    %Allow the first polygon to reset the figure if hold is off
    XYZ = [ points(:,polygons(1, 1:3))' ];
    fill3(XYZ(:,1), XYZ(:,2), XYZ(:,3), C(polygons(1,4)));
    hold on;
    for p = 2:size(polygons, 1)

        XYZ = [ points(:,polygons(p, 1:3))' ];
        fill3(XYZ(:,1), XYZ(:,2), XYZ(:,3), C(polygons(p,4)));

    end
    
end

grid on;
axis(span);
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
