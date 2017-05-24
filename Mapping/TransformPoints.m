function [ points ] ...
    = TransformPoints( points, xAngle, yAngle, zAngle, translation )
%TRANSFORMPOINTS Transforms a camera point cloud to world coords
%   Rotates each point in the point cloud about the X, then Y, then Z axes
%   by the given angles, then translates by the given vector

%Generate the rotation matrix
R = makehgtform('zrotate', zAngle, 'yrotate', yAngle, 'xrotate', xAngle);
R = R(1:3,1:3);

%Rotate and translate the point cloud
points = (R * points' + translation)';


end

