function [points] = DecimatePoints(points, factor)

N = floor(size(points,2) * factor);

for i = 1:N
    randomVal = randi(size(points,2) - 1) + 1;
    points(:, randomVal) = [];
end

end