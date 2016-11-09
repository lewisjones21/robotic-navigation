function [] = PlotPoints(points)

figure(1);

scatter3(points(1,:), points(2,:), points(3,:))

a = [1:size(points, 2)]'; b = num2str(a); c = cellstr(b);
text(points(1,:), points(2,:), points(3,:), c);

camproj('perspective')

end