function [] = PlotNodes(nodes, colour, noIndices)
%PLOTNODES Plots the nodes as large markers
%   Draw indices by default, but allow opt-out by inputting a third
%   parameter

%Validate the inputs
if size(nodes, 1) <= 0
    warning('No nodes given');
    return;
end
if size(nodes, 2) ~= 3
    warning('Nodes given in incorrect format');
    return;
end

if nargin < 2
    colour = 'blue';
end

savedhold = ishold;

figure(1);

%Draw the path coords (highlighted)
scatter3(nodes(:,1), nodes(:,2), nodes(:,3), 400, 'MarkerFaceColor', colour)

if nargin < 3 || ~noIndices
    %Draw indices showing the order of the path coords
    a = [1:size(nodes, 1)]'; b = num2str(a); c = cellstr(b);
    offset = ones(size(nodes, 1), 1) * 0.05;
    text(nodes(:,1) - offset, nodes(:,2), nodes(:,3) + offset, c, ...
        'Color', 'white');
end

%axis(span);
grid on;
xlabel('x');
ylabel('y');
zlabel('z');
camproj('perspective')

%Reset the hold state to what it was before starting this function
if savedhold
    hold on;
else
    hold off;
end

end
