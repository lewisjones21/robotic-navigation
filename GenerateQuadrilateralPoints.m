function [points] = GenerateQuadrilateralPoints(corner, axis1, axis2, density1, density2)

% if size(corner) ~= 3 || size(axis1) ~= 3 || size(axis2) ~= 3 ...
%         || size(density1) ~= 1 || size(density2) ~= 1
%     throw(MException('GeneratePolygonPoints:BadInput',...
%             'Input array has incorrect dimensions.'))
% end
% if density1 < 2 || density2 < 2
%     throw(MException('GeneratePolygonPoints:BadInput',...
%             'Density values are too small.'))
% end

points = zeros(3, density1 * density2);

inc1 = axis1 / (density1 - 1);
inc2 = axis2 / (density2 - 1);

yPosition = corner;

for y=0:density2-1
    position = yPosition;
    for x=0:density1-1
        points(:,y * density1 + x + 1) = position;
        position = position + inc1;
    end
    yPosition = yPosition + inc2;
end

end