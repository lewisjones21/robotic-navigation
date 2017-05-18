
hold off;

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
        
        %Generate a closed mesh based on the point cloud
        Triangles = MyRobustCrust(Points);
        
    case 1
        [Points, Triangles] = GenerateMock3DData1();
        [Triangles, Points, TraversableTriIndices, WallTriIndices, SharedSides, BoundaryPointIndices] ...
                = CreateMap(Points, 0.65, 0.03, Triangles);
        
        PathCoords = [  0.66, 0.33, 0.2;
                        1.5, 1.5, 0.2;
                        ];
        
    case 2
        %Generate a point cloud
        Points = GenerateMock3DData2();
        Points = AddNoise(Points, 0.003);

        %Create a triangle mesh from the point cloud
        [Triangles, Points, TraversableTriIndices, WallTriIndices, SharedSides, BoundaryPointIndices] ...
                = CreateMap(Points, 0.65, 0.03);
        
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
        [Triangles, Points, TraversableTriIndices, WallTriIndices, SharedSides, BoundaryPointIndices] ...
                = CreateMap(Points, 0.65, 0.03);
        
        PathCoords = [  1, -1, 0.2;
                        -1, -1, 0.6;
                        ];
        
end

%Plot the mesh
PlotMesh(Triangles(TraversableTriIndices,:), Triangles(WallTriIndices,:), Points);
hold on;

%DEBUG
%PlotWaypoints(Points(BoundaryPointIndices,:), 'm', false);
%PlotSharedSides(SharedSides, Triangles, Points);
%END DEBUG

%Draw links between triangles with shared sides
%PlotSharedSides(SharedSides, TraversableTriangles, Points);

%Place waypoints onto the mesh
%Waypoints = PlaceWaypoints(TraversableTriangles, Points, SharedSides);
[Waypoints, Edges, WaypointTriIndices] ...
    = GenerateNavigationGraph(TraversableTriIndices, Triangles, Points, SharedSides);

%Plot the edges
PlotEdges(Edges, Waypoints, 'red');
%Plot the waypoints
PlotWaypoints(Waypoints, 'red', false);

%Validate the waypoints and edges based on possible obstruction by other triangles
WheelSpan = 0.15;
CollisionRadius = 0.2;
[Waypoints, Edges, WaypointTriIndices] ...
    = ValidateNavigationGraph(WheelSpan, CollisionRadius, Waypoints, Edges, ...
    WaypointTriIndices, WallTriIndices, Triangles, Points);

%Plot the edges
PlotEdges(Edges, Waypoints, 'black');
%Plot the waypoints
PlotWaypoints(Waypoints, 'white', false);

%Find a path through the navigation graph
Path = FindPath(Waypoints, Edges, PathCoords);
%Plot the path
PlotNodes(PathCoords, 'y')
PlotPath(Waypoints(Path,:), 'm')

