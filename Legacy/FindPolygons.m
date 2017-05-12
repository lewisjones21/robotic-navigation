function [polygons, coplanarPoints] = FindPolygons(points)

polygons = [];
coplanarPoints = [];

attempts = 1;
searchDistance = 1;
dotProductThreshold = 0.1;
planeDistanceThreshold = 0.2;

while size(points,2) >= 3
    for a = 1:attempts
        %Select a random point
        randomIndex = randi(size(points,2) - 1);
        A = points(:,randomIndex);
        B = [];
        C = [];
        D = [];
        Aindex = randomIndex;
        Bindex = -1;
        Cindex = -1;
        Dindex = -1;
        %Search for nearby points
        BDistance2 = searchDistance * searchDistance;
        CDistance2 = BDistance2;
        DDistance2 = BDistance2;
        for otherIndex = 1:size(points,2)
            if otherIndex == randomIndex
                break;
            end
            difference = points(:,otherIndex) - A;
            distance2 = dot(difference, difference);
            if distance2 < DDistance2
                if distance2 < CDistance2
                    if distance2 < BDistance2
                        DDistance2 = CDistance2;
                        D = C;
                        Dindex = Cindex;
                        CDistance2 = BDistance2;
                        C = B;
                        Cindex = Bindex;
                        BDistance2 = distance2;
                        B = points(:,otherIndex);
                        Bindex = otherIndex;
                    else
                        DDistance2 = CDistance2;
                        D = C;
                        Dindex = Cindex;
                        CDistance2 = distance2;
                        C = points(:,otherIndex);
                        Cindex = otherIndex;
                    end
                else
                    DDistance2 = distance2;
                    D = points(:,otherIndex);
                    Dindex = otherIndex;
                end
            end
        end
        if Aindex >= 0 && Bindex >= 0 && Cindex >= 0 && Dindex >= 0
            %Check whether A, B, C and D
            normal = cross(B - A, C - A);
            dotProduct = dot(D - A, normal);
            if dotProduct < 0
                dotProduct = -dotProduct;
            end
            if dotProduct < dotProductThreshold
                %This A, B, C, D set is a valid candidate for a polygon basis,
                %because the points are almost coplanar
                
                %Find the plane of best fit for the 4 points
                [planeNormal,~,planePoint] = affine_fit([A B C D]);
                planeDistance = dot(planePoint, planeNormal);
                %DEBUG - draw plane indicators
                scatter3(planePoint(1), planePoint(2), planePoint(3), 'g')
                scatter3(planePoint(1) + planeNormal(1), planePoint(2) + planeNormal(2), planePoint(3) + planeNormal(3), 'y')
                
                %Find all other points that lie on the plane (This may bridge across gaps to coplanar walls)
                coplanarPoints = points(:,abs(planeNormal'*points) - planeDistance <= planeDistanceThreshold);
                %DEBUG - highlight the found points
                scatter3(coplanarPoints(1,:), coplanarPoints(2,:), coplanarPoints(3,:), 'r')
                
                %DEBUG - return the polygon ABCD
                newPolygon = Polygon;
                newPolygon.Points = [A, B, C, D];
                polygons = [polygons, newPolygon];
                Aindex
                Bindex
                Cindex
                Dindex
                return;

                %Find the least-squares plane through the points

            end
        end
    end
end

end