function [ Results, TimeResults, FileName ] ...
    = TestNavCapabilityAll( TestType )
%TESTNAVCAPABILITYALL Tests the navigation capability of the system
%   Tests how successful the system is at navigating under a range of
%   different parameter settings on all test environments
%   
%   TestType - 1: Noise, 2: Point Decimation, 3: Mesh Decimation
%   
%   Results are given as matrices in the form:
% /      |             |             |              |            |       \
% |      |             |             |              |            |       |
% | ParamValues   PlaneResults MoundsResults CorridorResults RampResults |
% |      |             |             |              |            |       |
% \      |             |             |              |            |       /

FileName = tempname;

switch TestType
    case 1
        %Test each environment against a range of noise values
        NoiseValues = [0:0.01:0.05, 0.1:0.1:0.4]';
        NumNoiseValues = length(NoiseValues);
        Results = [ NoiseValues, zeros(NumNoiseValues, 4) ];
        TimeResults = [ NoiseValues, zeros(NumNoiseValues, 4) ];
        for environment = 1:4
            [SuccessRates, AvgTimesTaken, ~, ~, ~] ...
                = TestNavCapability(1, environment, 10, NoiseValues);
            Results(:,environment+1) = SuccessRates';
            TimeResults(:,environment+1) = AvgTimesTaken';
        end
        
        %Save the results to a temporary location, to avoid loss of data
        save(strcat(FileName, ' Noise Results'), 'Results');
        save(strcat(FileName, ' Noise Time Results'), 'TimeResults');
        
    case 2
        %Test each environment against a range of noise values
        PointDecValues = [1:-0.1:0.1]';
        NumPointDecValues = length(PointDecValues);
        Results = [ PointDecValues, zeros(NumPointDecValues, 4) ];
        TimeResults = [ PointDecValues, zeros(NumPointDecValues, 4) ];
        for environment = 1:4
            [SuccessRates, AvgTimesTaken, ~, ~, ~] ...
                = TestNavCapability(2, environment, 10, PointDecValues);
            Results(:,environment+1) = SuccessRates';
            TimeResults(:,environment+1) = AvgTimesTaken';
        end
        
        %Save the results to a temporary location, to avoid loss of data
        save(strcat(FileName, ' Point Dec Results'), 'Results');
        save(strcat(FileName, ' Point Dec Time Results'), 'TimeResults');
        
    case 3
        %Test each environment against a range of noise values
        MeshDecValues = [1:-0.1:0.1]';
        NumMeshDecValues = length(MeshDecValues);
        Results = [ MeshDecValues, zeros(NumMeshDecValues, 4) ];
        TimeResults = [ PointDecValues, zeros(NumMeshDecValues, 4) ];
        for environment = 1:4
            [SuccessRates, AvgTimesTaken, ~, ~, ~] ...
                = TestNavCapability(3, environment, 10, MeshDecValues);
            Results(:,environment+1) = SuccessRates';
            TimeResults(:,environment+1) = AvgTimesTaken';
        end
        
        %Save the results to a temporary location, to avoid loss of data
        save(strcat(FileName, ' Mesh Dec Results'), 'Results');
        save(strcat(FileName, ' Mesh Dec Time Results'), 'TimeResults');
end


end

