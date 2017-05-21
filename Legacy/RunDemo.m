
hold off;

%-Define environment interpretation constants
%Largest triangle side length (for removing mesh cap)
MaxSideLength = 0.65;
%Smallest obstacle height to not be considered an artefact
MinObstacleHeight = 0.03;

%-Define robot constraint constants
%Maximum traversable incline in degrees
MaxIncline = 20;
%Span of the robot wheel-base
WheelSpan = 0.15;
%Object avoidance radius for safe traversal
CollisionRadius = 0.2;


if ~exist('TestCase', 'var')
    warning('TestCase not defined; using default value:');
    TestCase = 2
end

switch TestCase
    case 0
        %Use existing points and triangles
        quit = false;
        if ~exist('Points', 'var')
            warning('Points matrix does not exist; create some points or set TestCase > 0');
            quit = true;
        else
            if isempty(Points)
                warning('Points matrix is empty; create some points or set TestCase > 0');
                quit = true;
            end
        end
        if quit == true
            clear quit;
            return;
        end
        clear quit;
        
        %Rotate and translate the point cloud
        Points = InverseTransformPointCloud(Points, 20, 0, 0, [0; 0; 0]);
        
        %Generate a closed mesh based on the point cloud
        [Triangles, Points, TraversableTriIndices, WallTriIndices, ...
            SharedSides, BoundaryPointIndices, TriangleSlopes] ...
                = CreateMap(Points, MaxSideLength, MinObstacleHeight, ...
                    MaxIncline);
        
    case 1
        [Points, Triangles] = GenerateMock3DData1();
        [Triangles, Points, TraversableTriIndices, WallTriIndices, ...
            SharedSides, BoundaryPointIndices, TriangleSlopes] ...
                = CreateMap(Points, MaxSideLength, MinObstacleHeight, ...
                    MaxIncline, Triangles);
        
        PathCoords = [  0.66, 0.33, 0.2;
                        1.5, 1.5, 0.2;
                        ];
        
    case 2
        %Generate a point cloud
        Points = GenerateMock3DData2();
        Points = AddNoise(Points, 0.003);

        %Create a triangle mesh from the point cloud
        [Triangles, Points, TraversableTriIndices, WallTriIndices, ...
            SharedSides, BoundaryPointIndices, TriangleSlopes] ...
                = CreateMap(Points, ...
                    MaxSideLength, MinObstacleHeight, MaxIncline);
        
        PathCoords = [  1, -1, 0.2;
                        1.5, 1.5, 0.2;
                        -1.25, 1.5, 0.2;
                        -1, -1, 0.7;
                        ];
        
    case 3
        %Generate a point cloud
        Points = GenerateMock3DData3();
        Points = AddNoise(Points, 0.003);
        
        %Create a triangle mesh from the point cloud
        [Triangles, Points, TraversableTriIndices, WallTriIndices, ...
            SharedSides, BoundaryPointIndices, TriangleSlopes] ...
                = CreateMap(Points, ...
                    MaxSideLength, MinObstacleHeight, MaxIncline);
        
        PathCoords = [  1, -1, 0.2;
                        -1, -1, 0.6;
                        ];
        
end

%Plot the mesh
PlotMesh(TraversableTriIndices, WallTriIndices, Triangles, Points, ...
    TriangleSlopes / MaxIncline);
hold on;

%DEBUG
%PlotWaypoints(Points(BoundaryPointIndices,:), 'm', false);
%PlotSharedSides(SharedSides, Triangles, Points);
%END DEBUG

%Draw links between triangles with shared sides
%PlotSharedSides(SharedSides, TraversableTriangles, Points);

%Place waypoints onto the mesh
%Waypoints = PlaceWaypoints(TraversableTriangles, Points, SharedSides);
[AllWaypoints, AllEdges, AllWaypointTriIndices] ...
    = GenerateNavigationGraph(TraversableTriIndices, Triangles, Points, SharedSides);

%Plot the edges
PlotEdges(Edges, Waypoints, 'red');
%Plot the waypoints
PlotWaypoints(Waypoints, 'red', false);

%Validate the waypoints and edges based on possible obstruction by other triangles
[Waypoints, Edges, WaypointTriIndices] ...
    = ValidateNavigationGraph(WheelSpan, CollisionRadius, ...
        AllWaypoints, AllEdges, AllWaypointTriIndices, ...
        WallTriIndices, Triangles, Points);

%Plot the edges
PlotEdges(Edges, Waypoints, 'black');
%Plot the waypoints
PlotWaypoints(Waypoints, 'white', false);

%Find a path through the navigation graph
[Path CoordErrors] = FindPath(Waypoints, Edges, PathCoords);

CoordErrors

%Plot the path
PlotNodes(PathCoords, 'b')
PlotPath(Waypoints(Path,:), 'm')

