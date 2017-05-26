function [ points, restrictionTriangles ] ...
    = GenerateRampEnvData( width, depth )
%GENERATERAMPENVDATA Generate the Ramp environment
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

widthBy3 = width / 3;
depthBy3 = depth / 3;

xDensity = 18;
yDensity = 18;
zDensity = 9;

xDensityBy3 = xDensity / 3;
yDensityBy3 = yDensity / 3;
zDensityBy3 = zDensity / 3;

points = [];

%Back Wall
%Left
points = [points; GenerateQuadrilateralPoints([left, back, bottom], ...
    [widthBy3, 0, 0], [0, 0, height], xDensityBy3, zDensity)];
%Middle
points = [points; GenerateQuadrilateralPoints( ...
    [left + widthBy3, back - depthBy3, bottom + 5 * proximityTolerance], ...
    [widthBy3, 0, 0], [0, 0, height], xDensityBy3, zDensity)];
%Right
points = [points; GenerateQuadrilateralPoints( ...
    [left + 2 * widthBy3, back, bottom], ...
    [widthBy3, 0, 0], [0, 0, height - 5 * proximityTolerance], ...
            xDensityBy3 * 0.5, zDensity)];

%Front Wall
%Left
points = [points; GenerateQuadrilateralPoints([left, front, bottom], ...
    [widthBy3, 0, 0], [0, 0, height], xDensityBy3, zDensity)];
%Middle
points = [points; GenerateQuadrilateralPoints( ...
    [left + widthBy3, front + depthBy3, bottom + 5 * proximityTolerance], ...
    [widthBy3, 0, 0], [0, 0, height - 5 * proximityTolerance], ...
            xDensityBy3, zDensity)];
%Right
points = [points; GenerateQuadrilateralPoints( ...
    [left + 2 * widthBy3, front, bottom], ...
    [widthBy3, 0, 0], [0, 0, height], xDensityBy3, zDensity)];

%Left Wall
points = [points; GenerateQuadrilateralPoints([left, front, bottom], ...
    [0, depth, 0], [0, 0, height], yDensity, zDensity)];

%Right Wall
points = [points; GenerateQuadrilateralPoints([right, front, bottom], ...
    [0, depth, 0], [0, 0, height], yDensity, zDensity)];

%Floor sections
%Left
points = [points; GenerateQuadrilateralPoints([left, front, bottom], ...
    [widthBy3, 0, 0], [0, depth, 0], xDensityBy3, yDensity)];
%Middle
points = [points; GenerateQuadrilateralPoints( ...
    [left + widthBy3, front + depthBy3, bottom], ...
    [widthBy3, 0, 0], [0, depthBy3, 0], xDensityBy3, yDensityBy3)];
%Right
points = [points; GenerateQuadrilateralPoints([right, front, bottom], ...
    [-widthBy3, 0, 0], [0, depth, 0], xDensityBy3, yDensity)];

%Ceiling sections
%Left
points = [points; GenerateQuadrilateralPoints([left, front, top], ...
    [widthBy3, 0, 0], [0, depth, 0], xDensityBy3, yDensity)];
%Middle
points = [points; GenerateQuadrilateralPoints( ...
    [left + widthBy3, front + depthBy3, top], ...
    [widthBy3, 0, 0], [0, depthBy3, 0], xDensityBy3, yDensityBy3)];
%Right
points = [points; GenerateQuadrilateralPoints([right, front, top], ...
    [-widthBy3, 0, 0], [0, depth, 0], xDensityBy3, yDensity)];


%Corridor Left Walls
points = [points; GenerateQuadrilateralPoints( ...
    [left + widthBy3, front, bottom + 3 * proximityTolerance], ...
    [0, depthBy3, 0], [0, 0, height - 3 * proximityTolerance], ...
            yDensityBy3, zDensity)];
points = [points; GenerateQuadrilateralPoints( ...
    [left + widthBy3, back, bottom + 3 * proximityTolerance], ...
    [0, -depthBy3, 0], [0, 0, height - 3 * proximityTolerance], ...
            yDensityBy3, zDensity)];

%Corridor Right Walls
points = [points; GenerateQuadrilateralPoints( ...
    [right - widthBy3, front, bottom + 3 * proximityTolerance], ...
    [0, depthBy3, 0], [0, 0, height - 3 * proximityTolerance], ...
            yDensityBy3, zDensity)];
points = [points; GenerateQuadrilateralPoints( ...
    [right - widthBy3, back, bottom + 3 * proximityTolerance], ...
    [0, -depthBy3, 0], [0, 0, height - 3 * proximityTolerance], ...
            yDensityBy3, zDensity)];


points = uniquetol(points, proximityTolerance, 'ByRows', true);


%Define triangles that a valid path may not intersect
%In this case, the major obstructions are the walls of the corridor;
%form triangles coincident with the inner walls
%           |     |
%          B|_____|D
%              F
% Y          _____
% ^        A|  E  |C
% |         |     |
% '-->X
%
restrictionTriangles = [ ...
    %A
    left + widthBy3,            front,                  bottom;
    left + widthBy3,            front + depthBy3,       bottom;
    left + widthBy3,            front + depthBy3,       top;
    %B
    left + widthBy3,            back,                   bottom;
    left + widthBy3,            back - depthBy3,        bottom;
    left + widthBy3,            back - depthBy3,        top;
    
    %C
    left +  2 * widthBy3,       front,                  bottom;
    left +  2 * widthBy3,       front + depthBy3,       bottom;
    left +  2 * widthBy3,       front + depthBy3,       top;
    %D
    left +  2 * widthBy3,       back,                   bottom;
    left +  2 * widthBy3,       back - depthBy3,        bottom;
    left +  2 * widthBy3,       back - depthBy3,        top;
    
    %E1
    left +      widthBy3,       front +     depthBy3,   bottom;
    left +  2 * widthBy3,       front + 	depthBy3,   bottom;
    left +      widthBy3,       front + 	depthBy3,   top;
    %E2
    left +      widthBy3,       front +     depthBy3,   top;
    left +  2 * widthBy3,       front +     depthBy3,   bottom;
    left +  2 *	widthBy3,       front + 	depthBy3,   top
    
    %F1
    left +      widthBy3,       front + 2 * depthBy3,   bottom;
    left +  2 * widthBy3,       front + 2 * depthBy3,   bottom;
    left +      widthBy3,       front + 2 * depthBy3,   top;
    %F2
    left +      widthBy3,       front + 2 * depthBy3,   top;
    left +  2 * widthBy3,       front + 2 * depthBy3,   bottom;
    left +  2 *	widthBy3,       front + 2 * depthBy3,   top
    ];


end
