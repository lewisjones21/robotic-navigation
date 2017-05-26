function [ valid ] = ValidatePath( waypoints, ...
            restrictionTriangles, collisionRadius )
%VALIDATEPATH Checks that the path is valid
%   Sweeps the path with a sphere (of given collisionRadius); if the sphere
%   does not intersect a restricted triangle at any point, the path is
%   valid

%Check the path has length
if size(waypoints, 1) <= 1
    valid = false;
    return;
end

%Check there are restrictions on the path
if size(restrictionTriangles,1) < 3
    valid = true;
    return;
end

%Define the distance between checking points
checkDistance = collisionRadius * 0.25;

%For each pair of adjacent waypoints
for w = 1:size(waypoints,1)-1
    
    length = norm(waypoints(w+1,:) - waypoints(w,:));
    %Interpolate between each pair of adjacent waypoints
    for i = 0:length/checkDistance:1
        %Find the interpolated sphere centre
        centre = waypoints(w,:) * (1 - i) + waypoints(w+1,:) * i;
        
        %Index through the restriction triangles; every 3 rows defines 1
        %triangle, so skip 3 indices at a time
        for t = 1:size(restrictionTriangles,1)/3
            %Check for intersection with this triangle
            valid = ~CheckSphereTriangleCollision( ...
                restrictionTriangles((t-1)*3+(1:3),:), ...
                centre, collisionRadius);
            
            %Debug
            hold on;
            if valid
                %scatter3(centre(1), centre(2), centre(3), ...
                %    1200 * collisionRadius, 'MarkerFaceColor', 'green');
            else
                scatter3(centre(1), centre(2), centre(3), ...
                    1200 * collisionRadius, 'MarkerFaceColor', 'red');
            end
            
            %If any check shows an intersection, the path is not valid
            if ~valid
                return;
            end
            
        end
    end
end


end

