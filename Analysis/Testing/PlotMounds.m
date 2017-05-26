function [] = PlotMounds()
%PLOTMOUNDS Draws the schematic of the Mounds environment
%   

savedhold = ishold;

figure(1);

hold off;

n = length(-3:0.2:3);

points = zeros(n*n, 3);

xValues = -3:0.2:3;
yValues = -3:0.2:3;

for x = 1:n
    for y = 1:n
        index = (x - 1) * n + y;
        points(index, 1) = xValues(x);
        points(index, 2) = yValues(y);
        points(index, 3) ...
            = 0.2 * sin(1.6 * points(index, 1)) ...
            + 0.1 * cos(points(index, 1) + 2.2 * points(index, 2));
    end
end

PlotPoints(points)

for x = 1:n-1
    for y = 1:n-1
        indexA = (x - 1) * n + y;
        indexB = (x    ) * n + y;
        indexC = (x - 1) * n + y + 1;
        indexD = (x    ) * n + y + 1;
        fill3([ points(indexA, 1), points(indexD, 1);
                points(indexB, 1), points(indexB, 1);
                points(indexC, 1), points(indexC, 1);], ...
              [ points(indexA, 2), points(indexD, 2);
                points(indexB, 2), points(indexB, 2);
                points(indexC, 2), points(indexC, 2);], ...
              [ points(indexA, 3), points(indexD, 3);
                points(indexB, 3), points(indexB, 3);
                points(indexC, 3), points(indexC, 3);], 'green');
        hold on;
    end
end

axis([-3 3 -3 3 0 3]);
axis equal;
grid on;
xlabel('x');
ylabel('y');
zlabel('z');
camproj('perspective')
view([-20,40])


%Reset the hold state to what it was before starting this function
if savedhold
    hold on;
else
    hold off;
end

end
