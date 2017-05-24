function [] = RunDemo8( MaxIncline, WheelSpan, CollisionRadius, ...
    MeshDecimationFraction, MaxSideLength, MinObstacleHeight)
%RUNDEMO8 Run the real-world exploration demo
%   Run a demonstration using several pre-collected point sets.
%
%   Use the given robot constraints:
%   -MaxIncline: Maximum traversable incline in degrees
%   -WheelSpan: Span of the robot wheel-base
%   -CollisionRadius: Object avoidance radius for safe traversal
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
        MaxSideLength = 0.45;
        if nargin < 5
            MeshDecimationFraction = 0.05;
            if nargin < 4
                Noise = 0.003;
            end
        end
    end
end


%Import Kinect data
load('Simulation/BarTestDataABCDEFGHIJ.mat');

%Extract, subsample and transform the test data
% PointsTransformedA = TransformPoints(PointsA(1:16:size(PointsA,1),:), ...
%         0, 0, ZAngleA, TranslationA);
% PointsTransformedB = TransformPoints(PointsB(1:16:size(PointsB,1),:), ...
%         0, 0, ZAngleB, TranslationB);
% PointsTransformedC = TransformPoints(PointsC(1:16:size(PointsC,1),:), ...
%         0, 0, ZAngleC, TranslationC);
% PointsTransformedD = TransformPoints(PointsD(1:16:size(PointsD,1),:), ...
%         0, 0, ZAngleD, TranslationD);
% PointsTransformedE = TransformPoints(PointsE(1:16:size(PointsE,1),:), ...
%         0, 0, ZAngleE, TranslationE);
% PointsTransformedF = TransformPoints(PointsF(1:16:size(PointsF,1),:), ...
%         0, 0, ZAngleF, TranslationF);
% PointsTransformedG = TransformPoints(PointsG(1:16:size(PointsG,1),:), ...
%         0, 0, ZAngleG, TranslationG);
% PointsTransformedH = TransformPoints(PointsH(1:16:size(PointsH,1),:), ...
%         0, 0, ZAngleH, TranslationH);
% PointsTransformedI = TransformPoints(PointsI(1:16:size(PointsI,1),:), ...
%         0, 0, ZAngleI, TranslationI);
% PointsTransformedJ = TransformPoints(PointsJ(1:16:size(PointsJ,1),:), ...
%         0, 0, ZAngleJ, TranslationJ);


% Points = [  PointsTransformedA; PointsTransformedB;
%             PointsTransformedC; PointsTransformedD;
%             PointsTransformedE; PointsTransformedF;
%             PointsTransformedG; PointsTransformedH;
%             PointsTransformedI; PointsTransformedJ; ];
%Points = Points(1:4:size(Points, 1), :);


Points = PointsA(1:4:size(PointsA, 1), :);

%Filter the point cloud data
% PointsA = PointsA(PointsA(:,2) < 3.5,:);       %Far plane
% PointsA = PointsA(PointsA(:,3) < 0.75,:);      %Top plane
% 
%PointsI = PointsI(PointsI(:,2) < 3.5,:);       %Far plane
%PointsI = PointsI(PointsI(:,3) < 0.75,:);      %Top plane

% hold off;
% PlotPoints([PointsA;
%     TransformPoints(PointsB, 0, 0, ZAngleB, TranslationB * .6);
%     TransformPoints(PointsC, 0, 0, ZAngleC, TranslationC * .52);
%     TransformPoints(PointsD, 0, 0, ZAngleD, TranslationD * .55);
%     TransformPoints(PointsE, 0, 0, ZAngleE, TranslationE * .56);
%     TransformPoints(PointsF, 0, 0, ZAngleF, [-2.3; 3.42; -0.05]);
%     TransformPoints(PointsG, 0, 0, ZAngleG, [-2.99; 2.; -0.05]);
%     TransformPoints(PointsH, 0, 0, ZAngleH, [-2.9; 2.58; -0.05]);
%     TransformPoints(PointsI, 0, 0, ZAngleI, [-2.9; 3.2; -0.05]);
%     TransformPoints(PointsJ, 0, 0, ZAngleJ, [-2.79; 1.95; -0.05]) ], ...
%         'green');
% hold on;
% PlotPoints(TransformPoints(PointsI, ...
% 	0, 0, ZAngleI, [-2.9000; 3.200; -0.05]), 'blue');
% PlotPoints(TransformPoints(PointsJ, ...
% 	0, 0, ZAngleJ, [-2.790; 1.95; -0.05]), 'red');
hold off;

Points = [PointsA;
    TransformPoints(PointsB, 0, 0, ZAngleB, TranslationB + [0;0;-0.025]);
    TransformPoints(PointsC, 0, 0, ZAngleC, TranslationC);
    TransformPoints(PointsD, 0, 0, ZAngleD, TranslationD);
    TransformPoints(PointsE, 0, 0, ZAngleE, TranslationE);
    TransformPoints(PointsF, 0, 0, ZAngleF, TranslationF);
    TransformPoints(PointsG, 0, 0, ZAngleG, TranslationG);
    TransformPoints(PointsH, 0, 0, ZAngleH, TranslationH);
    TransformPoints(PointsI, 0, 0, ZAngleI, TranslationI);
    TransformPoints(PointsJ, 0, 0, ZAngleJ, TranslationJ) ];
% Points = [PointsA;
%     TransformPoints(PointsB, 0, 0, ZAngleB, TranslationB * .6);
%     TransformPoints(PointsC, 0, 0, ZAngleC, TranslationC * .52);
%     TransformPoints(PointsD, 0, 0, ZAngleD, TranslationD * .55);
%     TransformPoints(PointsE, 0, 0, ZAngleE, TranslationE * .56);
%     TransformPoints(PointsF, 0, 0, ZAngleF, [-2.3; 3.42; -0.05]);
%     TransformPoints(PointsG, 0, 0, ZAngleG, [-2.99; 2.; -0.05]);
%     TransformPoints(PointsH, 0, 0, ZAngleH, [-2.9; 2.58; -0.05]);
%     TransformPoints(PointsI, 0, 0, ZAngleI, [-2.9; 3.2; -0.05]);
%     TransformPoints(PointsJ, 0, 0, ZAngleJ, [-2.79; 1.95; -0.05]) ];

%Filter out some regions of space
Left = -7; Right = 2;
Back = -1; Front = 6.5;
Bottom = -1; Top = 2.5;
Points = Points(Points(:,1) > Left, :);
Points = Points(Points(:,1) < Right, :);
Points = Points(Points(:,2) > Back, :);
Points = Points(Points(:,2) < Front, :);
Points = Points(Points(:,3) > Bottom, :);
Points = Points(Points(:,3) < Top, :);

%Remove a proportiong of the points to decrease mesh triangulation time
Points = Points(1:32:size(Points,1),:);%DecimatePoints(Points, 0.8);

%Create a map from the test data, passing in the generated mesh
[Triangles, Points, TraversableTriIndices, WallTriIndices, ...
    SharedSides, TraversableSharedSides, BoundaryPointIndices, ...
    TriangleInclines] ...
        = CreateMap(MaxIncline, MeshDecimationFraction, MaxSideLength, ...
            MinObstacleHeight, Points);

%Define a test path
PathCoords = [   0,   1,    0;
                 0, 3.5,    0;
                -3, 3.5,    0;
                -3,   1.5,    0;
                ];

%Plot the mesh
hold off;
PlotMesh(TraversableTriIndices, WallTriIndices, Triangles, Points, ...
    TriangleInclines / MaxIncline);
hold on;

%PlotSharedSides(SharedSides, Triangles, Points)
%PlotWaypoints(Points(BoundaryPointIndices,:), 'yellow', true)

%Place waypoints onto the mesh
[AllWaypoints, AllEdges, AllWaypointTriIndices] ...
    = GenerateNavigationGraph(TraversableTriIndices, Triangles, Points, ...
        TraversableSharedSides, WheelSpan * 8);

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
        = AnalysePath(PathWaypointIndices, WaypointTriIndices, ...
        	TriangleInclines, Waypoints, Triangles, Points, PathCoords)

end

