

figure(104);
clf

yyaxis left
plot(ResultsN(:,1), ResultsN(:,2) * 100, '-', 'Color', 'black', 'LineWidth', 1.2);
hold on;
plot(ResultsN(:,1), ResultsN(:,3) * 100, '-', 'Color', 'blue', 'LineWidth', 1.2);
plot(ResultsN(:,1), ResultsN(:,4) * 100, '-', 'Color', 'red', 'LineWidth', 1.2);
plot(ResultsN(:,1), ResultsN(:,5) * 100, '-', 'Color', 'green', 'LineWidth', 1.2);

ylabel('Success Rate (finding any valid path between given points, %)')
ylim([ 0, 103 ])
set(gca,'ycolor','black')

yyaxis right
plot(ResultsN(:,1), TimeResultsN(:,2), '--', 'Color', 'black');
hold on;
plot(ResultsN(:,1), TimeResultsN(:,3), '--', 'Color', 'blue');
plot(ResultsN(:,1), TimeResultsN(:,4), '--', 'Color', 'red');
plot(ResultsN(:,1), TimeResultsN(:,5), '--', 'Color', 'green');

ylabel('Average Time Taken (to interpret and navigate, s)')
ylim([ 0, ceil(max(max(TimeResultsN(:,2:5), [], 1), [], 2) / 0.5) * 0.5 ])
set(gca,'ycolor','black')

xlabel('Noise (standard deviation, metres)')
title('Path-Finding Capability vs. Noise Applied to Point Locations')
xlim([ 0, max(ResultsN(:,1), [], 1) ])
set(gca,'XDir','Normal')
grid on

legend('Success Rate (Plane)', ...
    'Success Rate (Mounds)', ...
    'Success Rate (Corridor)', ...
    'Success Rate (Ramp)', ...
    'Average Time Taken (Plane)', ...
    'Average Time Taken (Mounds)', ...
    'Average Time Taken (Corridor)', ...
    'Average Time Taken (Ramp)', ...
    'Location', 'northeast')

hold off;

