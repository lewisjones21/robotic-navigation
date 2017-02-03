
hold off;

Points = GenerateMock3DData();
Points = AddNoise(Points, 0.003);

Triangles = MyRobustCrust(Points);
Triangles = CullTriangles(Triangles, Points, 0.7);

ClassifiedTriangles = ClassifyPolygons(Triangles,Points,8,30);
GroundTriangles = ClassifiedTriangles(ClassifiedTriangles(:,4)==1,1:3);
TraversableTriangles = [ GroundTriangles; ClassifiedTriangles(ClassifiedTriangles(:,4)==2,1:3) ];

PlotTriangles(ClassifiedTriangles, Points);
hold on;

SharedEdges = FindSharedEdges(TraversableTriangles, Points);

PlotSharedEdges(SharedEdges, TraversableTriangles, Points);

Waypoints = PlaceWaypoints(TraversableTriangles, Points);

PlotWaypoints(Waypoints);
