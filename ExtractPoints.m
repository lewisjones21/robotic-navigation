function [points] = ExtractPoints(image)

%Decimate the image (for now, to reduce processing)
image = image(1:4:end, 1:4:end);

%surf(A)
points = zeros(3, size(image,1) * size(image,2));

for y=1:size(image,2)
    for x=1:size(image,1)
        points(:,y * size(image,1) + x) = [x; y; image(x,y)];
    end
end

end