function [] = PlotCorridor()
%PLOTCORRIDOR Draws the schematic of the Corridor environment
%   

savedhold = ishold;

figure(1);

hold off;
%Floor
fill3(  [-3;-3;-1;-1; 1; 1; 3; 3; 1; 1;-1;-1], ...
        [-3; 3; 3; 1; 1; 3; 3;-3;-3;-1;-1;-3], ...
        [ 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0], 'green');

hold on;
%Far Walls
fill3(  [-1;-1;   -1;-1], ...
        [ 3; 1;    1; 3], ...
        [ 0; 0;    1; 1], 'red');
fill3(  [-1; 1;    1;-1], ...
        [ 1; 1;    1; 1], ...
        [ 0; 0;    1; 1], 'red');
fill3(  [ 1; 1;    1; 1], ...
        [ 1; 3;    3; 1], ...
        [ 0; 0;    1; 1], 'red');
%Close Walls
fill3(  [-1;-1;   -1;-1], ...
        [-3;-1;   -1;-3], ...
        [ 0; 0;    1; 1], 'red');
fill3(  [-1; 1;    1;-1], ...
        [-1;-1;   -1;-1], ...
        [ 0; 0;    1; 1], 'red');
fill3(  [ 1; 1;    1; 1], ...
        [-1;-3;   -3;-1], ...
        [ 0; 0;    1; 1], 'red');

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
