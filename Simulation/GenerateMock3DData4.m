function [points] = GenerateMock3DData4()

proximityTolerance = 0.001;

left = -3;
right = 3;
back = 3;
front = -3;
bottom = 0;
top = 2;

width = right - left;
depth = front - back;
height = top - bottom;

xDensity = 16;
yDensity = 16;
zDensity = 8;

points = [];

%Back Wall
points = [points; GenerateQuadrilateralPoints([left, back, bottom], ...
    [width, 0, 0], [0, 0, height], xDensity * 0.5, zDensity * 0.5)];

%Left Wall
points = [points; GenerateQuadrilateralPoints([left, back, bottom], ...
    [0, depth, 0], [0, 0, height], xDensity * 0.5, zDensity * 0.5)];

%Right Wall
points = [points; GenerateQuadrilateralPoints([right, back, bottom], ...
    [0, depth, 0], [0, 0, height], xDensity * 0.5, zDensity * 0.5)];

%Floor
points = [points; GenerateQuadrilateralPoints([left, back, bottom], ...
    [width, 0, 0], [0, depth, 0], xDensity, yDensity)];

%Ceiling
points = [points; GenerateQuadrilateralPoints([left, back, top], ...
    [width, 0, 0], [0, depth, 0], xDensity * 0.25, yDensity * 0.25)];

points = uniquetol(points, proximityTolerance, 'ByRows', true);

end
