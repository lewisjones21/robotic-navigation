function [points] = GenerateMock3DData()

proximityTolerance = 0.001;

points = [];
points = [points, GenerateQuadrilateralPoints([-2, -2, 0], [4, 0, 0], [0, 0, 2], 8, 4)];
points = [points, GenerateQuadrilateralPoints([-2, 2, 0], [4, 0, 0], [0, 0, 2], 8, 4)];
points = [points, GenerateQuadrilateralPoints([-2, -2, 0], [0, 4, 0], [0, 0, 2], 8, 4)];
points = [points, GenerateQuadrilateralPoints([2, -2, 0], [0, 4, 0], [0, 0, 2], 8, 4)];

points = uniquetol(points', proximityTolerance, 'ByRows', true)';

end