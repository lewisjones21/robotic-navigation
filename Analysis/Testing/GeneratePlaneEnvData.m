function [ points, restrictionTriangles ] ...
    = GeneratePlaneEnvData( width, depth )
%GENERATEPLANEENVDATA Generate the Plane environment
%   Generate a point cloud and restricted area data for the Plane
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
    [width, 0, 0], [0, 0, height], xDensity * 0.5, zDensity)];

%Front Wall
points = [points; GenerateQuadrilateralPoints([left, front, bottom], ...
    [width, 0, 0], [0, 0, height], xDensity * 0.5, zDensity)];

%Left Wall
points = [points; GenerateQuadrilateralPoints([left, front, bottom], ...
    [0, depth, 0], [0, 0, height], xDensity * 0.5, zDensity)];

%Right Wall
points = [points; GenerateQuadrilateralPoints([right, front, bottom], ...
    [0, depth, 0], [0, 0, height], xDensity * 0.5, zDensity)];

%Floor
points = [points; GenerateQuadrilateralPoints([left, front, bottom], ...
    [width, 0, 0], [0, depth, 0], xDensity, yDensity)];

%Ceiling
% points = [points; GenerateQuadrilateralPoints([left, front, top], ...
%     [width, 0, 0], [0, depth, 0], xDensity * 0.25, yDensity * 0.25)];

points = uniquetol(points, proximityTolerance, 'ByRows', true);


%Define triangles that a valid path may not intersect
%In this case, no major obstructions are present, so leave the set empty
restrictionTriangles = [];

end
