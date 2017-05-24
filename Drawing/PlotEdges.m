function [] = PlotEdges( edges, waypoints, colour )
%PLOTEDGES Draws lines between waypoints to represent their interconnecting
%arcs

if size(waypoints, 1) <= 0
    warning('No waypoints given');
    return;
end
if size(edges, 1) <= 0
    warning('No edges given');
    return;
end

savedhold = ishold;

figure(1);

X = [ waypoints(edges(:,1),1) waypoints(edges(:,2),1) ];
Y = [ waypoints(edges(:,1),2) waypoints(edges(:,2),2) ];
Z = [ waypoints(edges(:,1),3) waypoints(edges(:,2),3) ];

%Draw lines where edges exist
line(X(1,:), Y(1,:), Z(1,:), 'Color', colour,'LineWidth',1.5);
hold on;
for l = 2:size(X,1)
    line(X(l,:), Y(l,:), Z(l,:), 'Color', colour,'LineWidth',1.5);
end

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

