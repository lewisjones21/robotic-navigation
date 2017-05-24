function [ sharedSides ] = FindSharedSides(triangles, points)
%FINDSHAREDSIDES Finds all shared triangle sides
%   Returns a list of all of the sides that are shared between pairs of
%   triangles; each output row records the two relevant triangle indices
%   and the indices of the two points that define the shared side

sharedSides = [];

if size(points, 1) <= 0
    warning('No points given');
    return;
end
if size(triangles, 1) <= 0
    warning('No triangles given');
    return;
end

for t1 = 1:size(triangles, 1)
    for t2 = t1+1:size(triangles, 1)
        %Check each combination of sides
        for p1 = 1:3
            for p2 = 1:3
                
                if points(triangles(t1,p1),:) == points(triangles(t2,p2),:) ...
                    %Triangles t1 and t2 share a point
                    if points(triangles(t1,mod(p1+1-1,3)+1),:) == points(triangles(t2,mod(p2+1-1,3)+1),:)
                        %They share another point in the same indexing direction
                        sharedSides = [sharedSides; t1 t2 triangles(t1,p1) triangles(t1,mod(p1+1-1,3)+1)];
                        
                    elseif points(triangles(t1,mod(p1+1-1,3)+1),:) == points(triangles(t2,mod(p2+2-1,3)+1),:)
                        %They share another point in the opposite indexing direction
                        sharedSides = [sharedSides; t1 t2 triangles(t1,p1) triangles(t1,mod(p1+1-1,3)+1)];
                        
                    end
                end
            end
        end
    end
end


end

