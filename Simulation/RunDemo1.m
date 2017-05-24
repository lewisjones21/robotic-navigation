function [] = RunDemo1( MaxIncline, WheelSpan, CollisionRadius, ...
    MaxSideLength, MinObstacleHeight)
%RUNDEMO1 Run a basic demo
%   Run a demonstration using a small test grid of points.
%   Use the given robot constraints:
%   -MaxIncline: Maximum traversable incline in degrees
%   -WheelSpan: Span of the robot wheel-base
%   -CollisionRadius: Object avoidance radius for safe traversal
%   and optional mapping validation parameters:
%   -MaxSideLength: Max side length of triangles in the triangulated mesh;
%       by default, the generated mesh is closed by large triangles, which
%       is unrealistic, so these are removed based on this parameter
%   -MinObstacleHeight: Smallest obstacle/ wall height to not be considered
%       an artefact

%Set default values where necessary
if nargin < 5
    MinObstacleHeight = 0.03;
    if nargin < 4
        MaxSideLength = 0.65;
    end
end

%Generate the test data
[Points, Triangles] = GenerateMock3DData1();

%Create a map from the test data, passing in the generated mesh
[Triangles, Points, TraversableTriIndices, WallTriIndices, ...
    SharedSides, TraversableSharedSides, BoundaryPointIndices, ...
    TriangleSlopes] ...
        = CreateMap(Points, MaxSideLength, MinObstacleHeight, ...
            MaxIncline, Triangles);

%Define a test path
PathCoords = [  0.66, 0.33, 0.2;
                0.5, 1.5, 0.1;
                1.5, 1.5, 0.2;
                ];

%Plot the mesh
hold off;
PlotMesh(TraversableTriIndices, WallTriIndices, Triangles, Points, ...
    TriangleSlopes / MaxIncline);
hold on;

%Place waypoints onto the mesh
[AllWaypoints, AllEdges, AllWaypointTriIndices] ...
    = GenerateNavigationGraph(TraversableTriIndices, Triangles, Points, ...
        TraversableSharedSides, WheelSpan * 6);

%Find the subset of waypoints and edges that are valid for the given robot
%constraints, based on possible obstruction by walls; in other demos, this
%allows specific navigation graphs to be generated for a variety of
%different robots based on the same full navigation graph
[Waypoints, Edges, WaypointTriIndices] ...
    = ValidateNavigationGraph(WheelSpan, CollisionRadius, ...
        AllWaypoints, AllEdges, AllWaypointTriIndices, ...
        WallTriIndices, Triangles, Points);

%Plot the full set of edges
PlotEdges(AllEdges, AllWaypoints, 'red');
%Plot the full set of waypoints
PlotWaypoints(AllWaypoints, 'red', false);

%Plot the valid edges
PlotEdges(Edges, Waypoints, 'black');
%Plot the valid waypoints
PlotWaypoints(Waypoints, 'white', false);

%Find a path through the navigation graph
[PathWaypointIndices CoordErrors] = FindPath(Waypoints, Edges, PathCoords);

%Plot the path
PlotNodes(PathCoords, 'blue')
PlotPath(Waypoints(PathWaypointIndices,:), 'magenta')

CoordErrors

%Analyse the path that was found
[PathLength, DirectDistance, FactorAboveDirect, PathHeightGain, ...
    MaxIncline, MaxFacedIncline, MaxTroughAngle, MaxRidgeAngle] ...
        = AnalysePath(PathWaypointIndices, Waypoints, WaypointTriIndices, ...
            Triangles, Points, PathCoords)

end

