function [ points ] = ExtractPoints( image, depthsteptolerance )

if nargin < 2
    depthsteptolerance = 0;%I.e. don't correct depth steps
end

%Decimate the image (for now, to reduce processing)
decimationFactor = 1;
image = image(1:decimationFactor:end, 1:decimationFactor:end);

%Initialise the output matrix
points = zeros(size(image,1) * size(image,2), 3);
extraPoints = [];

%Arrange the points into row format
for y = 1:size(image,2)
    for x = 1:size(image,1)
        points(y * size(image,1) + x,:) = [x, y, image(x,y)];
        %If there is a large step change in depth, a new points/ set of
        %points is introduced to span the step, using interpolation
    end
end

if (depthsteptolerance > 0)
    %If there is a large step change in depth, add a new point/ set of points
    %to span the step using interpolation
    for y = 1:size(image,2)-1
        for x = 1:size(image,1)-1
            %Check x direction
            diff = points(y * size(image,1) + x + 1,3) - points(y * size(image,1) + x + 1,3);
            if abs(diff) > depthsteptolerance
                numNewPoints = floor(depthsteptolerance / diff);
                newDepthStep = diff / (numNewPoints + 1);
                newXStep = 1 / (numNewPoints + 1);
                newPoints = [ x+[1:numNewPoints]*newXStep, ...
                        ones(numNewPoints,1)*y, ...
                        points(y * size(image,1) + x + 1,3)+[1:numNewPoints]*newDepthStep];
                
                extraPoints = [extraPoints; newPoints];
            end

        end
    end
end

%Remove any zero-depth elements (results of noise)
isZero = points(:,3) == 0;
points(isZero,:) = [];

end