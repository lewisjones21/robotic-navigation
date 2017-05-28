

figure(104);
clf

yyaxis left
plot(ResultsPD(:,1), ResultsPD(:,2) * 100, '-', 'Color', 'black', 'LineWidth', 1.2);
hold on;
plot(ResultsPD(:,1), ResultsPD(:,3) * 100, '-', 'Color', 'blue', 'LineWidth', 1.2);
plot(ResultsPD(:,1), ResultsPD(:,4) * 100, '-', 'Color', 'red', 'LineWidth', 1.2);
plot(ResultsPD(:,1), ResultsPD(:,5) * 100, '-', 'Color', 'green', 'LineWidth', 1.2);

ylabel('Success Rate (finding any valid path between given points, %)')
ylim([ 0, 103 ])
set(gca,'ycolor','black')

yyaxis right
plot(ResultsPD(:,1), TimeResultsPD(:,2), '--', 'Color', 'black');
hold on;
plot(ResultsPD(:,1), TimeResultsPD(:,3), '--', 'Color', 'blue');
plot(ResultsPD(:,1), TimeResultsPD(:,4), '--', 'Color', 'red');
plot(ResultsPD(:,1), TimeResultsPD(:,5), '--', 'Color', 'green');

ylabel('Average Time Taken (to interpret and navigate, s)')
ylim([ 0, ceil(max(max(TimeResultsPD(:,2:5), [], 1), [], 2) / 0.5) * 0.5 ])
set(gca,'ycolor','black')

xlabel('Point Decimation (fraction remaining)')
title('Path-Finding Capability vs. Point Decimation Prior to Mesh Triangulation')
xlim([ 0, max(ResultsPD(:,1), [], 1) ])
set(gca,'XDir','Reverse')
grid on

legend('Success Rate (Plane)', ...
    'Success Rate (Mounds)', ...
    'Success Rate (Corridor)', ...
    'Success Rate (Ramp)', ...
    'Time Results (see prev. fig.)', ...
    'Location', 'southwest')
%     'Average Time Taken (Plane)', ...
%     'Average Time Taken (Mounds)', ...
%     'Average Time Taken (Corridor)', ...
%     'Average Time Taken (Ramp)', ...
%     'Location', 'southwest')
% legend('See previous figure', 'Location', 'southwest')

hold off;

