function [ intersects ] ...
    = CheckSphereTriangleCollision( trianglePoints, centre, radius )
%CHECKSPHERETRIANGLECOLLISION Determines whether the sphere intersects the
%triangle
%   trianglePoints is given as 3 rows of 3 vertex coordinates
%   centre notes the centre of the sphere
%   radius is the radius of the sphere

%Validate the inputs
if size(centre, 2) ~= 3
    warning('Centre given in incorrect format');
    return;
end
if size(trianglePoints, 1) ~= 3 || size(trianglePoints, 2) ~= 3
    warning('Triangle points given in incorrect format');
    return;
end

intersects = false;

cRel2 = trianglePoints(2,:) - trianglePoints(1,:);
cRel3 = trianglePoints(3,:) - trianglePoints(1,:);
n = cross(cRel2, cRel3);
if (norm(n) > 0)
    n = n / norm(n);
else
    warning('Triangle is a line; check the triangle definition');
    return;
end

d = dot(centre - trianglePoints(1,:), n);

if d > radius || d < -radius
    %Sphere cannot possibly be close enough to triangle to intersect
    return;
end

r2 = radius * radius;

%Quick check: see if the centre is close enough to the triangle
maxDist = sqrt(max(dot(cRel2, cRel2), dot(cRel3, cRel3))) - radius;
cRel = centre - trianglePoints(1,:);
if maxDist * maxDist > dot(cRel, cRel)
    return;
end

%Quick check: see if the centre is close enough to any vertex
%Check if centre is within range of v1
%cRel = centre - trianglePoints(1,:);
if dot(cRel, cRel) <= r2
    intersects = true;
    return;
end
%Check if centre is within range of v2
cRel = centre - trianglePoints(2,:);
if dot(cRel, cRel) <= r2
    intersects = true;
    return;
end
%Check if centre is within range of v3
cRel = centre - trianglePoints(3,:);
if dot(cRel, cRel) <= r2
    intersects = true;
    return;
end

%To do: vectorise this?
n12 = cross(trianglePoints(2,:) - trianglePoints(1,:), n); n12 = n12 / norm(n12);
n23 = cross(trianglePoints(3,:) - trianglePoints(2,:), n); n23 = n23 / norm(n23);
n31 = cross(trianglePoints(1,:) - trianglePoints(3,:), n); n31 = n31 / norm(n31);

d12 = dot(trianglePoints(1,:) - centre, n12);
d23 = dot(trianglePoints(2,:) - centre, n23);
d31 = dot(trianglePoints(3,:) - centre, n31);

if d12 >= 0
    %Projection of centre is in front of edge v1->v2
    if d23 >= 0
        %Projection of centre is in front of edge v2->v3
        if d31 >= 0
            %Projection of centre is in front of edge v1->v2
            %Projection of centre is in front of edge v2->v3
            %Projection of centre is in front of edge v3->v1:
            %Projection of centre is inside triangle
            %Distance to triangle plane was already found small enough
            intersects = true;
            return;
        else
            %Projection of centre is in front of edge v1->v2
            %Projection of centre is in front of edge v2->v3
            %Projection of centre is behind edge v3->v1:
            %Projection is inside the 'V' defined by edges v1->v2, v2->v3
            edge = trianglePoints(1,:) - trianglePoints(3,:);
            edgeLength2 = dot(edge, edge);
            centreEdgeDist2 = dot(centre - trianglePoints(3,:), edge);
            if centreEdgeDist2 <= 0 || centreEdgeDist2 >= edgeLength2
                %Centre is not alongside edge v3->v1
                %It would have to be within range of v3 or v1 (checked)
                return;
            end
            %Otherwise, projection of centre to edge v3->v1 is on edge
            %Check if centre is within range of edge v3->v1
            if d * d + d31 * d31 <= r2
                intersects = true;
                return;
            else
                return;
            end
        end
    else
        %Projection of centre is behind edge v2->v3
        if d31 >= 0
            %Projection of centre is in front of edge v1->v2
            %Projection of centre is behind edge v2->v3
            %Projection of centre is in front of edge v3->v1
            %Projection is inside the 'V' defined by edges v1->v2, v3->v1
            edge = trianglePoints(3,:) - trianglePoints(2,:);
            edgeLength2 = dot(edge, edge);
            centreEdgeDist2 = dot(centre - trianglePoints(2,:), edge);
            if centreEdgeDist2 <= 0 || centreEdgeDist2 >= edgeLength2
                %Centre is not alongside edge v2->v3
                %It would have to be within range of v2 or v3 (checked)
                return;
            end
            %Otherwise, projection of centre to edge v2->v3 is on edge
            %Check if centre is within range of edge v2->v3
            if d * d + d23 * d23 <= r2
                intersects = true;
                return;
            else
                return;
            end
        else
            %Projection of centre is in front of edge v1->v2
            %Projection of centre is behind edge v2->v3
            %Projection of centre is behind edge v3->v1
            %Check if centre is within range of v3
            cRel = centre - trianglePoints(3,:);
            if dot(cRel, cRel) <= r2
                intersects = true;
                return;
            else
                return;
            end
        end
    end
else
    %Projection of centre is behind edge v1->v2
    if d23 >= 0
        %Projection of centre is in front of edge v2->v3
        if d31 >= 0
            %Projection of centre is behind edge v1->v2
            %Projection of centre is in front of edge v2->v3
            %Projection of centre is in front of edge v3->v1:
            %Projection is inside the 'V' defined by edges v2->v3, v3->v1
            edge = trianglePoints(2,:) - trianglePoints(1,:);
            edgeLength2 = dot(edge, edge);
            centreEdgeDist2 = dot(centre - trianglePoints(1,:), edge);
            if centreEdgeDist2 <= 0 || centreEdgeDist2 >= edgeLength2
                %Centre is not alongside edge v1->v2
                %It would have to be within range of v1 or v2 (checked)
                return;
            end
            %Otherwise, projection of centre to edge v1->v2 is on edge
            %Check if centre is within range of edge v1->v2
            if d * d + d12 * d12 <= r2
                intersects = true;
                return;
            else
                return;
            end
        else
            %Projection of centre is behind edge v1->v2
            %Projection of centre is in front of edge v2->v3
            %Projection of centre is behind edge v3->v1:
            %Check if centre is within range of v1
            cRel = centre - trianglePoints(1,:);
            if dot(cRel, cRel) <= r2
                intersects = true;
                return;
            else
                return;
            end
        end
    else
        %Projection of centre is behind edge v2->v3
        if d31 >= 0
            %Projection of centre is behind edge v1->v2
            %Projection of centre is behind edge v2->v3
            %Projection of centre is in front of edge v3->v1
            %Projection is inside the 'V' defined by edges v1->v2, v3->v1
            %Check if centre is within range of v2
            cRel = centre - trianglePoints(1,:);
            if dot(cRel, cRel) <= r2
                intersects = true;
                return;
            else
                return;
            end
        else
            %Projection of centre is behind edge v1->v2
            %Projection of centre is behind edge v2->v3
            %Projection of centre is behind edge v3->v1
            
            %This should be impossible; throw error and return false
            error('Triangle intersection test has reached an impossible scenario; check the triangle definition');
            return;
            
        end
    end
end

end

