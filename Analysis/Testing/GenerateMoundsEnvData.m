function [ points, restrictionTriangles ] ...
    = GenerateMoundsEnvData( width, depth )
%GENERATEMOUNDSENVDATA Generate the Mounds environment
%   Generate a point cloud and restricted area data for the Mounds
%   environment
%   
%   Restriction triangles are independent of the point cloud, so are
%   defined as a matrix of coordinates such that each row defines X, Y, Z
%   coordinates of a point, and every consecutive set of 3 rows defines one
%   triangle

proximityTolerance = 0.001;

left = -width / 2;
right = width / 2;
back = depth / 2;
front = -depth / 2;
bottom = 0;
top = 2;

height = top - bottom;

xDensity = 32;
yDensity = 32;
zDensity = 4;

points = [];

%Back Wall
points = [points; GenerateQuadrilateralPoints([left, back, bottom], ...
    [width, 0, 0], [0, 0, height], xDensity * 0.5, zDensity * 0.5)];

%Front Wall
points = [points; GenerateQuadrilateralPoints([left, front, bottom], ...
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


%Alter the z coordinates to make the mounds
points(:,3) = points(:,3) ...
                + 0.5 * sin(1.6 * points(:,1)) ...
                + 0.3 * cos(points(index, 1) + 2.2 * points(index, 2));

%Define triangles that a valid path may not intersect
%In this case, no specific obstructions are present, so leave the set empty
restrictionTriangles = [];

end
