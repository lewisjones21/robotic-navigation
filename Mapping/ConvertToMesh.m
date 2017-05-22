function [ triangles, points ] = ConvertToMesh( points, maxsidelength )
%CONVERTTOMESH Converts point cloud into triangle mesh
%   Converts the given point cloud (rows of tuples [X, Y, Z]) into a mesh
%   of triangles defined by indices referencing the given points ([p1, p2,
%   p3]), removes invalid triangles (assuming an open manifold mesh, with
%   maximum triangle side length as given), and simplifies the mesh

%Generate a closed mesh based on the point cloud
triangles = MyRobustCrust(points);
%Remove large triangles, which are typically capping a concave mesh
triangles = CullTriangles(triangles, points, maxsidelength);

%Decimate the mesh to simplify the data
[triangles, points] = reducepatch(triangles, points, 0.15);


end

