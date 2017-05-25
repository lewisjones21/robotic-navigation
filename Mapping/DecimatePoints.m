function [points] = DecimatePoints(points, fractionLeft)
%DECIMATEPOINTS Remove a random subset of the points
%   Removes a random subset of the given point cloud, with the size of the
%   remaining set of points given as fractionLeft of the size of the input
%   point cloud

%Validate the inputs
if size(points, 1) <= 0
    warning('No points given');
    return;
end
if size(points, 2) ~= 3
    warning('Points given in incorrect format');
    return;
end

if fractionLeft >= 1
    warning('No decimation requested');
    return;
end
if fractionLeft <= 0
    points = [];
    warning('No points remaining');
    return;
end

N = floor(size(points, 1) * (1 - fractionLeft));
randomIndices = randperm(size(points, 1));

points(randomIndices(1:N), :) = [];


end