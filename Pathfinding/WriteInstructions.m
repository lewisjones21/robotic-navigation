function [ startAngle, distances, turnAngles ] ...
    = WriteInstructions( path, waypoints, filename )
%WRITEINSTRUCTIONS Outputs verbal navigation instructions
%   Outputs verbal instructions describing how to follow the given 
%   navigation path; if a filename is given, the instructions are also
%   stored in a corresponding .txt file; outputs starting angle, distances
%   to travel between waypoints and angles to turn at each intersection
%   (measured clockwise; turning right)


%Extract the relevant waypoints
pathWaypoints = waypoints(path);

%Formulate waypoints into instructions
numPoints = size(path, 2);

differences = waypoints(path(2:numPoints),:) - waypoints(path(1:numPoints-1),:);

distances = sqrt(sum(differences.^2,2));
directions = atan2(differences(:,1), differences(:,2)) * 180 / pi;

startDir = directions(1);

turnAngles = directions(2:numPoints-1,:) - directions(1:numPoints-2,:);
turnAngles = [ turnAngles; 0 ];

% turnAngles = sum(abs(differences(1:numPoints-2,:) .* differences(2:numPoints-1,:)), 2);
% turnAngles = acos(abs(turnAngles(:)) ./ norm(turnAngles(:))) * 180 / pi;
% turnAngles = [ turnAngles; 0 ];

turnDirRightIndices = cross(differences(1:numPoints-2,:), differences(2:numPoints-1,:));
turnDirRightIndices = (turnDirRightIndices(:,3) < 0);

turnDirs = cell(numPoints - 1,1);
for i=1:numPoints - 2
    if turnDirRightIndices(i)
        turnDirs{i} = 'right';
    else
        turnDirs{i} = 'left';
    end
end

turnDirs{numPoints - 1} = 'right';

%Define output formats
startFormat = 'Turn to face %4.2f degrees CW from original North;\n';
instrFormat = 'Move forwards %4.3f meters then turn %s %4.1f degrees;\n';

instructionValues = cat(2, num2cell(distances(1:numPoints-1)), turnDirs, num2cell(abs(turnAngles)));


%If a filename was given
if nargin > 2
    %Print to the file
    if ~contains(filename, '.txt', 'IgnoreCase', true)
        filename = strcat(filename, '.txt');
    end
    file = fopen(filename,'w');
    fprintf(file, startFormat, startDir);
    for i=1:numPoints - 1
        fprintf(file, instrFormat, instructionValues{i,:});
    end
    fclose(file);
    
else
    %Otherwise, print to the console
    fprintf(startFormat, startDir);
    for i=1:numPoints - 1
        fprintf(instrFormat, instructionValues{i,:});
    end
end


end

