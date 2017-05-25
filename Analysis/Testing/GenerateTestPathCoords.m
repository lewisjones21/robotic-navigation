function [ pathCoordRows ] ...
    = GenerateTestPathCoords( N, width, height, collisionRadius )
%GENERATETESTPATHCOORDS Generate pairs of start and end points
%   Generates N pairs of coordinates to be used as target start and end
%   positions in the testing environments; these follow the pattern that A
%   is positioned in the left 3rd of the environment, away from the
%   boundaries and B is positioned similarly in the right 3rd
%   
%   pathCoordRows is given in the rows of [Ax, Ay, Az, Bx, By, Bz]
%
%   The z coord is not relevant to analysis, so is set to 1 so that coords
%   will be above the environment when drawn for debugging


pathCoords = [];

if N < 1
    warn('No coords requested');
    return;
end
if width <= 0
    warn('Width is non-positive');
    return;
end
if height <= 0
    warn('Height is non-positive');
    return;
end

widthBy3 = width / 3;

if collisionRadius > widthBy3 / 2
    warn('Collision radius is too large');
    return;
end

widthBy3MinusBorder = widthBy3 - 2 * collisionRadius;
heightMinusBorder = height - 2 * collisionRadius;

%Generate start x in left 3rd, avoiding border area
Ax = ((rand(N, 1) - 0.5) * widthBy3MinusBorder) + (widthBy3 * 0.5);
%Generate end x in right 3rd, avoiding border area
Bx = ((rand(N, 1) - 0.5) * widthBy3MinusBorder) + (widthBy3 * 2.5);

%Generate start and end y within height range, avoiding border area
Ay = ((rand(N, 1) - 0.5) * heightMinusBorder) + (height * 0.5);
By = ((rand(N, 1) - 0.5) * heightMinusBorder) + (height * 0.5);

z = ones(N, 1);


pathCoords = [ Ax, Ay, z, Bx, By, z ];


end
