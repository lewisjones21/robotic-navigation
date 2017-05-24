function [ triangles, points ] = ConvertToMesh( points, ...
    maxsidelength, meshDecimationFraction )
%CONVERTTOMESH Converts point cloud into triangle mesh
%   Converts the given point cloud (rows of tuples [X, Y, Z]) into a mesh
%   of triangles defined by indices referencing the given points ([p1, p2,
%   p3]), removes invalid triangles (assuming an open manifold mesh, with
%   maximum triangle side length as given), and simplifies the mesh

%Default the relevant outputs
triangles = [];

%Validate the inputs
if size(points, 1) <= 0
    warning('No points given');
    return;
end
if size(points, 2) ~= 3
    warning('Points given in incorrect format');
    return;
end

%Generate a closed mesh based on the point cloud
triangles = MyRobustCrust(points);
%Remove large triangles, which are typically capping a concave mesh
triangles = CullTriangles(triangles, points, maxsidelength);

if nargin > 2
    if meshDecimationFraction > 0
        %Decimate the mesh to simplify the data
        [triangles, points] ...
            = reducepatch(triangles, points, meshDecimationFraction);
    end
end


end

