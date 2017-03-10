function [points] = GenerateMock3DData2()

proximityTolerance = 0.001;

left = 2;
right = -2;
back = -2;
front = 2;
bottom = 0;
top = 2;

width = right - left;
depth = front - back;
height = top - bottom;

xDensity = 16;
yDensity = 16;
zDensity = 8;

points = [];

%Left Wall
points = [points; GenerateQuadrilateralPoints([left, back, bottom], ...
    [0, depth, -height * 0.66], [0, 0, height], xDensity, zDensity)];
points = [points; GenerateQuadrilateralPoints([left, back, bottom], ...
    [0, depth, 0], [0, 0, height * 0.33], xDensity, zDensity * 0.5)];

%Back Wall
points = [points; GenerateQuadrilateralPoints([left, back, bottom], ...
    [width * 0.5, 0, 0], [0, 0, height], xDensity * 0.5, zDensity)];
points = [points; GenerateQuadrilateralPoints([left + width * 0.5, back, bottom + height * 0.4], ...
    [width * 0.5, 0, 0], [0, 0, height], xDensity * 0.5, zDensity)];

%Right Wall
points = [points; GenerateQuadrilateralPoints([right, front, bottom], ...
    [0, -depth, height * 0.4], [0, 0, height], xDensity, zDensity)];

%Floor
points = [points; GenerateQuadrilateralPoints([left, front, bottom], ...
    [width * 0.5, 0, 0], [0, -depth, 0], xDensity * 0.5, yDensity)];
points = [points; GenerateQuadrilateralPoints([left + width * 0.5, front, bottom], ...
    [width * 0.5, 0, 0], [0, -depth * 0.25, 0], xDensity * 0.5, yDensity * 0.25)];

%Ceiling (gets culled)
points = [points; GenerateQuadrilateralPoints([left, back, top], ...
    [width, 0, 0], [0, depth, 0], xDensity * 0.125, yDensity * 0.125)];

%Front Wall (gets culled)
points = [points; GenerateQuadrilateralPoints([left, front, bottom], ...
    [width, 0, 0], [0, 0, height], xDensity * 0.125, zDensity * 0.125)];

%Ramp
points = [points; GenerateQuadrilateralPoints([left + width * 0.5, front - depth * 0.25, bottom], ...
    [width * 0.5, 0, 0], [0, -depth * 0.75, height * 0.4], xDensity, yDensity * 0.75)];
points = [points; GenerateQuadrilateralPoints([left + width * 0.5, front - depth * 0.5, bottom], ...
    [0, -depth * 0.5, 0], [0, 0, height * 0.25], xDensity * 0.5, zDensity * 0.25)];

%Remove points that are to high
points = points(points(:,3) <= top,:);
%Remove points that are to low
points = points(points(:,3) >= bottom,:);
    

points = uniquetol(points, proximityTolerance, 'ByRows', true);

end
