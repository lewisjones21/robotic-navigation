
Points = GenerateMock3DData();
Points = AddNoise(Points, 0.003);

Triangles = MyRobustCrust(Points);
Triangles = CullTriangles(Triangles, Points, 0.7);

ClassifiedTriangles = ClassifyPolygons(Triangles,Points,8,30);
GroundTriangles = ClassifiedTriangles(ClassifiedTriangles(:,4)==1,1:3);

PlotTriangles(ClassifiedTriangles, Points);

Waypoints = PlaceWaypoints(Triangles, Points);