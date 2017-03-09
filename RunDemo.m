
hold off;

if ~exist('TestCase', 'var')
    warning('TestCase not defined; using default value:');
    TestCase = 1
end

switch TestCase
    case 0
        Use existing points and triangles
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
        if ~exist('Triangles', 'var')
            warning('Triangles matrix does not exist; create some points or set TestCase > 0');
            quit = true;
        else
            if isempty(Triangles)
                warning('Triangles matrix is empty; create some points or set TestCase > 0');
                quit = true;
            end
        end
        if quit == true
            clear quit;
            return;
        end
        clear quit;
        
    case 1
        [Points, Triangles] = GenerateMock3DData1();
        StartPos = [0.66, 0.33, 0.2];
        EndPos = [1.5, 1.5, 0.2];
        
    case 2
        %Generate a point cloud
        Points = GenerateMock3DData2();
        Points = AddNoise(Points, 0.003);

        %Generate a closed mesh based on the point cloud
        Triangles = MyRobustCrust(Points);
        %Remove large triangles, which are typically capping a concave mesh
        Triangles = CullTriangles(Triangles, Points, 0.7);

        %Decimate the mesh to simplify the data
        [Triangles, Points] = reducepatch(Triangles, Points, 400);
        
        StartPos = [1, -1, 0.2];
        EndPos = [-1, -1, 0.7];
        
    case 3
        %Generate a point cloud
        Points = GenerateMock3DData3();
        Points = AddNoise(Points, 0.003);

        %Generate a closed mesh based on the point cloud
        Triangles = MyRobustCrust(Points);
        %Remove large triangles, which are typically capping a concave mesh
        Triangles = CullTriangles(Triangles, Points, 0.65);

        %Decimate the mesh to simplify the data
        [Triangles, Points] = reducepatch(Triangles, Points, 500);
        
        StartPos = [1, -1, 0.2];
        EndPos = [-1, -1, 0.6];
        
end

%Classify the triangles and sub-group them
ClassifiedTriangles = ClassifyPolygons(Triangles, Points, 8, 30);
GroundTriangles = ClassifiedTriangles(ClassifiedTriangles(:,4)==1,1:3);
TraversableTriangles = [ GroundTriangles; ClassifiedTriangles(ClassifiedTriangles(:,4)==2,1:3) ];
WallTriangles = ClassifiedTriangles(ClassifiedTriangles(:,4)==3,1:3);

%Plot the mesh
PlotTriangles(ClassifiedTriangles, Points);
hold on;

%Find sides that are common to more than one triangle
SharedSides = FindSharedSides(TraversableTriangles, Points);
%Draw links between triangles with shared sides
%PlotSharedSides(SharedSides, TraversableTriangles, Points);

%Place waypoints onto the mesh
%Waypoints = PlaceWaypoints(TraversableTriangles, Points, SharedSides);
[Waypoints, Edges, WaypointTriangles] = GenerateNavigationGraph(TraversableTriangles, Points, SharedSides);

%Plot the edges
PlotEdges(Edges, Waypoints, 'red');
%Plot the waypoints
PlotWaypoints(Waypoints, 'red', false);

%Validate the waypoints and edges based on possible obstruction by other triangles
CollisionRadius = 0.2;
[Waypoints, Edges, WaypointTriangles] ...
    = ValidateNavigationGraph(CollisionRadius, Waypoints, Edges, WaypointTriangles, SharedSides, WallTriangles, Points);

%Plot the edges
PlotEdges(Edges, Waypoints, 'black');
%Plot the waypoints
PlotWaypoints(Waypoints, 'white', false);

%Find a path through the navigation graph
Path = FindPath(Waypoints, Edges, StartPos, EndPos);
%Plot the path
PlotPath(StartPos, [ 0.9100 0.4100 0.1700 ])
PlotPath(EndPos, [ 0.9100 0.4100 0.1700])
PlotPath(Waypoints(Path,:), 'r')

