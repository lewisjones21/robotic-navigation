function [points] = GenerateMock3DData()

points = [];
points = [points, GenerateQuadrilateralPoints([-2, -2, 0], [4, 0, 0], [0, 0, 2], 8, 4)];
points = [points, GenerateQuadrilateralPoints([-2, 2, 0], [4, 0, 0], [0, 0, 2], 8, 4)];
points = [points, GenerateQuadrilateralPoints([-2, -2, 0], [0, 4, 0], [0, 0, 2], 8, 4)];
points = [points, GenerateQuadrilateralPoints([2, -2, 0], [0, 4, 0], [0, 0, 2], 8, 4)];

end