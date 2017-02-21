
hold off;

if ~Basic
    %Generate a point cloud
    Points = GenerateMock3DData();
    Points = AddNoise(Points, 0.003);

    %Generate a closed mesh based on the point cloud
    Triangles = MyRobustCrust(Points);
    %Remove large triangles, which are typically capping a concave mesh
    Triangles = CullTriangles(Triangles, Points, 0.7);
    
    %Decimate the mesh to simplify the data
    [Triangles, Points] = reducepatch(Triangles, Points, 200 - Basic * 120);
else
    Points = [
        0 0 0;
        1 0 0;
        1 1 0;
        0 1 0;
        0 2 0.5;
        1 2 0.2;
        2 0 0;
        2 1 0;
        ];
    Triangles = [
        1 2 3;
        1 3 4;
        3 4 6;
        4 5 6;
        2 7 8;
        ];
end

%Classify the triangles and sub-group them
ClassifiedTriangles = ClassifyPolygons(Triangles, Points, 8, 30);
GroundTriangles = ClassifiedTriangles(ClassifiedTriangles(:,4)==1,1:3);
TraversableTriangles = [ GroundTriangles; ClassifiedTriangles(ClassifiedTriangles(:,4)==2,1:3) ];

%Plot the mesh
PlotTriangles(ClassifiedTriangles, Points);
hold on;

%Find sides that are common to more than one triangle
SharedSides = FindSharedSides(TraversableTriangles, Points);
%Draw links between triangles with shared sides
%PlotSharedSides(SharedSides, TraversableTriangles, Points);

%Place waypoints onto the mesh
%Waypoints = PlaceWaypoints(TraversableTriangles, Points, SharedSides);
[Waypoints, Edges] = GenerateNavigationGraph(TraversableTriangles, Points, SharedSides);
%Plot the edges
PlotEdges(Edges, Waypoints);
%Plot the waypoints
PlotWaypoints(Waypoints);
