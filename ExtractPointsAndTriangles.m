function [points, triangles] = ExtractPointsAndTriangles(image)

%Decimate the image (for now, to reduce processing)
decimationFactor = 16;
image = image(1:decimationFactor:end, 1:decimationFactor:end);

%Initialise the output points matrix
points = zeros(size(image,1) * size(image,2), 3);

%Arrange the points into row format
for y = 1:size(image,2)
    for x = 1:size(image,1)
        points(y * size(image,1) + x,:) = [x, y, image(x,y)];
    end
end

%Initialise the output triangles matrix
triangles = ones(2 * (size(image,1) - 1) * (size(image,2) - 1), 3);

%Create triangles based on the image array
for y = 1:size(image,2)-1
    for x = 1:size(image,1)-1
        if (image(x, y) > 0 && image(x+1, y+1) > 0)
            if (image(x+1, y) > 0)
                triangles(2 * (y * size(image,1) + x),:) ...
                        = [y * size(image,1) + x, y * size(image,1) + x + 1, (y + 1) * size(image,1) + x + 1];
            end
            if (image(x, y+1) > 0)
                triangles(2 * (y * size(image,1) + x) + 1,:) ...
                        = [y * size(image,1) + x, (y + 1) * size(image,1) + x, (y + 1) * size(image,1) + x + 1];
            end
        end
    end
end

%Remove any zero-depth elements (results of noise)
%isZero = points(:,3) == 0;
%points(isZero,:) = [];

end