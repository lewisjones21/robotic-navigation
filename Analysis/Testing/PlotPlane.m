function [] = PlotPlane()
%PLOTPLANE Draws the schematic of the Plane environment
%   

savedhold = ishold;

figure(1);

hold off;

fill3([-3; -3; 3; 3], [-3; 3; 3; -3], [0; 0; 0; 0], 'green');

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
