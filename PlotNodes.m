function [] = PlotNodes(nodes, colour)

savedhold = ishold;

figure(1);

%Draw the path waypoints (highlighted)
scatter3(nodes(:,1), nodes(:,2), nodes(:,3), 400, 'MarkerFaceColor', colour)

%axis(span);
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
