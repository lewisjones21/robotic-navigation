function [points] = DecimatePoints(points, factor)
%DECIMATEPOINTS Remove a random subset of the points
%   Removes a random subset of the given point cloud, with the subset size
%   determined as a factor of the size of the input point cloud

%Validate the inputs
if size(points, 1) <= 0
    warning('No points given');
    return;
end
if size(points, 2) ~= 3
    warning('Points given in incorrect format');
    return;
end

if factor <= 0
    warning('No decimation requested');
    return;
end

N = floor(size(points,2) * factor);

for i = 1:N
    randomVal = randi(size(points,2) - 1) + 1;
    points(:, randomVal) = [];
end

end