function [ points ] = AddNoise( points, standarddeviation )
%ADDNOISE Add noise to the points
%   Returns the set of points plus Gaussian noise with the provided
%   standard deviation

noise = randn(size(points)) * standarddeviation;
points = points + noise;

end
