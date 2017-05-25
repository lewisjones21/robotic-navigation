function [] = PlotRestrictionTriangles(restrictionTriangles)
%PLOTRESTRICTIONTRIANGLES Draws the given restriction triangles
%   

%Validate the inputs
if size(restrictionTriangles, 1) <= 0
    warning('No restriction triangles given');
    return;
end
if size(restrictionTriangles, 2) ~= 3
    warning('Restriction triangles given in incorrect format');
    return;
end

savedhold = ishold;

figure(1);

hold on;

for i = 1:size(restrictionTriangles,1)/3
    fill3(  restrictionTriangles((i-1)*3+(1:3),1), ...
            restrictionTriangles((i-1)*3+(1:3),2), ...
            restrictionTriangles((i-1)*3+(1:3),3), 'red');
end


%Reset the hold state to what it was before starting this function
if savedhold
    hold on;
else
    hold off;
end

end
