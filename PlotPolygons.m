function [] = PlotPolygons(polygons, points)

figure(1);
hold on;
grid on;
axis([-2.2 2.2 -2.2 2.2 -0.2 2.2]);
xlabel('x');
ylabel('y');
zlabel('z');

colormap hsv;

C = [ 1 ];

for t = 1:size(polygons, 1)

    XYZ = [ points(:,polygons(t, :))' ];
    fill3(XYZ(:,1), XYZ(:,2), XYZ(:,3), C);
    
end

camproj('perspective')

end