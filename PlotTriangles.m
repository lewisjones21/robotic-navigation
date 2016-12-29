function [] = PlotTriangles(triangles, points)

figure(1);
hold on;
grid on;
axis([-2.2 2.2 -2.2 2.2 -0.2 2.2]);
xlabel('x');
ylabel('y');
zlabel('z');

colormap hsv;

C = [0 0.33 0.66];

for t = 1:size(triangles, 1)

    XYZ = [ points(:,triangles(t, 1))';
            points(:,triangles(t, 2))';
            points(:,triangles(t, 3))'
        ];
    fill3(XYZ(:,1), XYZ(:,2), XYZ(:,3), C);
    
end

camproj('perspective')

end