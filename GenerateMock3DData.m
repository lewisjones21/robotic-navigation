function [points] = GenerateMock3DData()

proximityTolerance = 0.001;

points = [];

points = [points, GenerateQuadrilateralPoints([-2, -2, 0], [4, 0, 0], [0, 0, 2], 16, 8)];
points = [points, GenerateQuadrilateralPoints([-2, 2, 0], [4, 0, 0], [0, 0, 2], 16, 8)];
points = [points, GenerateQuadrilateralPoints([-2, -2, 0], [0, 4, 0], [0, 0, 2], 16, 8)];
points = [points, GenerateQuadrilateralPoints([2, -2, 0], [0, 4, 0], [0, 0, 2], 16, 8)];

points = [points,   [-0.5; -0.5; 0], [-0.5; 0.5; 0], [0.5; -0.5; 0], [0.5; 0.5; 0], ...
                    [-0.5; -0.5; 0.5], [-0.5; 0.5; 0.5], [0.5; -0.5; 0.5], [0.5; 0.5; 0.5]];

%points = [points,   [0.75; 0.75; 0], [0.75; 1.5; 0], [1.5; 0.75; 0], [1.5; 1.5; 0], ...
%                    [0.75; 0.75; 0.5], [0.75; 1.5; 0.5], [1.5; 0.75; 0.5], [1.5; 1.5; 0.5]];

points = uniquetol(points', proximityTolerance, 'ByRows', true)';

end