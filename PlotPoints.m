function [] = PlotPoints(points)

figure(1);

scatter3(points(1,:), points(2,:), points(3,:))
camproj('perspective')

end