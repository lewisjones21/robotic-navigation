function [ FactorAboveDirect, CoordErrors, TimeTaken ] ...
    = RunPlaneTest( PathCoords, Noise, PointDecimationFraction, ...
        MeshDecimationFraction, SpacingFactor, ...
        MaxSideLength, MinObstacleHeight)
%RUNPLANETEST Run a pathfinding test on a plane
%   Determine how well the system can find a path across a plane between
%   the given positions
%   
%   Use optional generation parameters:
%   -Noise: standard deviation (metres) of noise to add to points prior to
%       mesh generation
%   -MeshDecimationFraction: the fraction of the original number of
%       triangles to which the mesh triangle count should be reduced
%   
%   Use optional mapping validation parameters:
%   -MaxSideLength: Max side length of triangles in the triangulated mesh;
%       by default, the generated mesh is closed by large triangles, which
%       is unrealistic, so these are removed based on this parameter
%   -MinObstacleHeight: Smallest obstacle/ wall height to not be considered
%       an artefact


%Set default values where necessary
if nargin < 7
    MinObstacleHeight = 0.03;
    if nargin < 6
        MaxSideLength = 0.65;
    end
end

%Generate the test data
Points = GenerateMock3DData4();

%Decimate the points
Points = DecimatePoints(Points, PointDecimationFraction);

%Add noise to the points cloud positions
Points = AddNoise(Points, Noise);

startTime = cputime;

%Create a map from the test data, passing in the generated mesh
[Triangles, Points, TraversableTriIndices, ~, ~, TraversableSharedSides] ...
    = CreateMap(30, MeshDecimationFraction, MaxSideLength, ...
        MinObstacleHeight, Points);

% %Plot the mesh
% hold off;
% PlotMesh(TraversableTriIndices, [], Triangles, Points);
% hold on;

%Place waypoints onto the mesh
[Waypoints, Edges, ~] ...
    = GenerateNavigationGraph(TraversableTriIndices, Triangles, Points, ...
        TraversableSharedSides, SpacingFactor);
%Don't bother validating the navigation graph as this test doesn't concern
%obstacle avoidance - the plane should be flat and unobstructed

% %Plot the valid edges
% PlotEdges(Edges, Waypoints, 'black');
% %Plot the valid waypoints
% PlotWaypoints(Waypoints, 'white', false);

%Find a path through the navigation graph
[PathWaypointIndices CoordErrors] = FindPath(Waypoints, Edges, PathCoords);

TimeTaken = cputime - startTime;

% %Plot the path
% PlotNodes(PathCoords, 'blue')
% PlotPath(Waypoints(PathWaypointIndices,:), 'magenta')

%Analyse the lengths of the path that was found
[~, ~, FactorAboveDirect] ...
        = AnalysePathMinimal(PathWaypointIndices, ...
            Waypoints, Triangles, Points, PathCoords, CoordErrors);

end

