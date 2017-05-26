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
top = 3;

height = top - bottom;

xDensity = 16;
yDensity = 16;
zDensity = 6;

points = [];

%Back Wall
points = [points; GenerateQuadrilateralPoints([left, back, bottom], ...
    [width, 0, 0], [0, 0, height], xDensity, zDensity)];

%Front Wall
points = [points; GenerateQuadrilateralPoints([left, front, bottom], ...
    [width, 0, 0], [0, 0, height], xDensity, zDensity)];

%Left Wall
points = [points; GenerateQuadrilateralPoints([left, front, bottom], ...
    [0, depth, 0], [0, 0, height], yDensity, zDensity)];

%Right Wall
points = [points; GenerateQuadrilateralPoints([right, front, bottom], ...
    [0, depth, 0], [0, 0, height], yDensity, zDensity)];

%Floor
points = [points; GenerateQuadrilateralPoints([left, front, bottom], ...
    [width, 0, 0], [0, depth, 0], xDensity, yDensity)];

%Ceiling
points = [points; GenerateQuadrilateralPoints([left, front, top], ...
    [width, 0, 0], [0, depth, 0], xDensity, yDensity)];

points = uniquetol(points, proximityTolerance, 'ByRows', true);


%Alter the z coordinates to make the mounds
points(:,3) = points(:,3) ...
                + 0.2 * sin(1.6 * points(:,1)) ...
                + 0.1 * cos(points(:, 1) + 2.2 * points(:, 2));

%Define triangles that a valid path may not intersect
%In this case, no specific obstructions are present, so leave the set empty
restrictionTriangles = [];

end
