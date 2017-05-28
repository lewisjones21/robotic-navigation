

figure(104);
clf

yyaxis left
plot(ResultsMD(:,1), ResultsMD(:,2) * 100, '-', 'Color', 'black', 'LineWidth', 1.2);
hold on;
plot(ResultsMD(:,1), ResultsMD(:,3) * 100, '-', 'Color', 'blue', 'LineWidth', 1.2);
plot(ResultsMD(:,1), ResultsMD(:,4) * 100, '-', 'Color', 'red', 'LineWidth', 1.2);
plot(ResultsMD(:,1), ResultsMD(:,5) * 100, '-', 'Color', 'green', 'LineWidth', 1.2);

ylabel('Success Rate (finding any valid path between given points, %)')
ylim([ 0, 103 ])
set(gca,'ycolor','black')

yyaxis right
plot(ResultsMD(:,1), TimeResultsMD(:,2), '--', 'Color', 'black');
hold on;
plot(ResultsMD(:,1), TimeResultsMD(:,3), '--', 'Color', 'blue');
plot(ResultsMD(:,1), TimeResultsMD(:,4), '--', 'Color', 'red');
plot(ResultsMD(:,1), TimeResultsMD(:,5), '--', 'Color', 'green');

ylabel('Average Time Taken (to interpret and navigate, s)')
ylim([ 0, ceil(max(max(TimeResultsMD(:,2:5), [], 1), [], 2) / 5) * 5 ])
set(gca,'ycolor','black')

xlabel('Mesh Decimation (proportional number of triangles compared to original mesh)')
title('Path-Finding Capability vs. Mesh Decimation Prior to Navigation Graph Generation')
xlim([ 0, max(ResultsMD(:,1), [], 1) ])
set(gca,'XDir','Reverse')
grid on

legend('Success Rate (Plane)', ...
    'Success Rate (Mounds)', ...
    'Success Rate (Corridor)', ...
    'Success Rate (Ramp)', ...
    'Time Results (see previous figure)', ...
    'Location', 'southwest')
%     'Average Time Taken (Plane)', ...
%     'Average Time Taken (Mounds)', ...
%     'Average Time Taken (Corridor)', ...
%     'Average Time Taken (Ramp)', ...
%     'Location', 'southwest')
% legend('See previous figure', 'Location', 'southwest')

hold off;

