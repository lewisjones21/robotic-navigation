function [points, triangles] = GenerateMock3DData1()

points = [
    0 0 0;
    1 0 0;
    1 1 0;
    0 1 0;
    0 2 0.5;
    1 2 0.2;
    2 2 0;
    2 0 0;
    2 1 0;
    1 1 -0.3;
    ];
triangles = [
    1 2 3;
    1 3 4;
    3 4 6;
    4 5 6;
    3 6 7;
    2 8 9;
    2 9 10;
    ];

end
