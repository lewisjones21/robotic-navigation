function [] = PlotPolygons(polygons)

figure(1);

for p = 1:size(polygons)

    fill3(polygons(p).Points(1,:), polygons(p).Points(2,:), polygons(p).Points(3,:), [1 0 0])
    
end
camproj('perspective')

end