function [polygons] = FindPolygons(points)

polygons = [];

attempts = 1;
searchDistance = 1;
dotProductThreshold = 0.1;

while size(points,2) >= 3
    for a = 1:attempts
        %Select a random point
        randomIndex = randi(size(points,2) - 1);
        A = points(:,randomIndex);
        B = [];
        C = [];
        D = [];
        %Search for nearby points
        BDistance2 = searchDistance * searchDistance;
        CDistance2 = BDistance2;
        DDistance2 = BDistance2;
        for otherIndex = 1:size(points,2)
            distance2 = dot(points(:,otherIndex), A);
            if distance2 < DDistance2
                if distance2 < CDistance2
                    if distance2 < BDistance2
                        DDistance2 = CDistance2;
                        D = C;
                        CDistance2 = BDistance2;
                        C = B;
                        BDistance2 = distance2;
                        B = points(:,otherIndex);
                    else
                        DDistance2 = CDistance2;
                        D = C;
                        CDistance2 = distance2;
                        C = points(:,otherIndex);
                    end
                else
                    DDistance2 = distance2;
                    D = points(:,otherIndex);
                end
            end
        end
        %Check whether A, B, C and D
        Normal = cross(B - A, C - A);
        if dot(D - A, Normal) < dotProductThreshold
            %This A, B, C, D set is a valid candidate for a polygon basis,
            %because the points are almost coplanar
            
            %DEBUG - return the polygon ABCD
            newPolygon = Polygon;
            newPolygon.Points = [A, B, C, D];
            polygons = [polygons, newPolygon];
            a;
            return;
            
            %Find the least-squares plane through the points
            
        end
    end
end

end