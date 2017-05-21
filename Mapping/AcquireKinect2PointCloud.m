function [ points ] = AcquireKinect2PointCloud( downsample )
% ACQUIREKINECT2POINTSCLOUD Acquires a point cloud from Kinect
%   Uses the Kin2 class to acquire a depth frame from the Kinect 2 device
%   connected to the computer and returns the depth information as an Nx3
%   point cloud
%
%   +ve X ~ right
%   +ve Y ~ forwards
%   +ve Z ~ up
%
%   Code in this function uses the Kin2 toolbox as credited below and is
%   adapted from the demos provided with the toolbox
%
% Juan R. Terven, jrterven@hotmail.com
% Diana M. Cordova, diana_mce@hotmail.com
% 
% Citation:
% Terven Juan. Cordova-Esparza Diana, "Kin2. A Kinect 2 Toolbox for MATLAB", Science of
% Computer Programming, 2016. DOI: http://dx.doi.org/10.1016/j.scico.2016.05.009
%
% https://github.com/jrterven/Kin2, 2016.

% Default to no downsampling
if nargin < 1
    downsample = 1;
end


% Create Kinect 2 object and initialize it
% Select sources as input parameters.
% Available sources: 'color', 'depth', 'infrared', 'body_index', 'body',
% 'face' and 'HDface'
k2 = Kin2('depth');

% images sizes
depth_width = 512; depth_height = 424; outOfRange = 8000;

% Create a matrix for the points
points = zeros(depth_height * depth_width, 3);

% Look for a valid frame from Kinect and save them on underlying buffer
validData = k2.updateData;
while ~validData
    % Try again
    validData = k2.updateData;
end

% Before processing the data, we need to make sure that a valid frame was
% acquired.
if validData

    % Obtain the point cloud
    [points, pcColors] = k2.getPointCloud('output','raw','color','true');

end

% Close kinect object
k2.delete;

if nargin > 0
    points = points(1:downsample:size(points, 1),:);
end

%Remap the coordinate system to the one stated in the description
points = [ -points(:,1), points(:,3), points(:,2) ];

%Validate the obtained points
points = points((isfinite(points(:,1)) & isfinite(points(:,2)) ...
        & isfinite(points(:,3))),:);


end
