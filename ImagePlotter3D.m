
filename = '0.png';

A = imread(filename);

B = A(1:16:end, 1:16:end);

figure(1);

surf(B)
camproj('perspective')