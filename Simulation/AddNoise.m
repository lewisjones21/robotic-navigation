function [ points ] = AddNoise( points, standarddeviation )
%ADDNOISE Add noise to the points
%   Returns the set of points plus Gaussian noise with the provided
%   standard deviation

%Validate the inputs
if size(points, 1) <= 0
    warning('No points given');
    return;
end
if size(points, 2) ~= 3
    warning('Points given in incorrect format');
    return;
end

noise = randn(size(points)) * standarddeviation;
points = points + noise;

end
