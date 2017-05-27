
iterations = 100;

AvgFactorAboveDirect = 0;
AvgCoordErrors = [0; 0];
AvgTimeTaken = 0;

NumFactorAboveDirect = 0;
NumCoordErrors = 0;
NumTimeTaken = 0;

for i = 1:iterations

    [FactorAboveDirect, CoordErrors, TimeTaken] ...
        = RunPlaneTest([ rand(2, 2) * 4 - 2, zeros(2, 1) ], 0.03, 0, 0.1, 2);

    if FactorAboveDirect > 0
        NumFactorAboveDirect = NumFactorAboveDirect + 1;
        AvgFactorAboveDirect = AvgFactorAboveDirect + FactorAboveDirect;
    end
    
    NumCoordErrors = NumCoordErrors + 1;
    AvgCoordErrors = AvgCoordErrors + CoordErrors;
    
    NumTimeTaken = NumTimeTaken + 1;
    AvgTimeTaken = AvgTimeTaken + TimeTaken;

end

AvgFactorAboveDirect = AvgFactorAboveDirect / NumFactorAboveDirect
AvgCoordErrors = AvgCoordErrors / NumCoordErrors
AvgTimeTaken = AvgTimeTaken / NumTimeTaken

