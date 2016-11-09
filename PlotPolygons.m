function [] = PlotPolygons(polygons)

figure(1);
colormap hsv;

C = [0 0.25 0.5 0.75];

for p = 1:size(polygons)

    fill3(polygons(p).Points(1,:), polygons(p).Points(2,:), polygons(p).Points(3,:), C)
    
end

camproj('perspective')

end