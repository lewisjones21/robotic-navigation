

figure(104);

yyaxis left
plot(PointDecPD, AvgExcessFractionPD * 100, 'Color', 'black');

ylabel('Average Excess Path Length (compared to optimum, %)')
ylim([ floor(100 * min(AvgExcessFractionPD, [], 2) / 5) * 5 ...
        ceil(100 * max(AvgExcessFractionPD, [], 2) / 5) * 5 ])

yyaxis right
plot(PointDecPD, AvgTimesTakenPD, '--', 'Color', 'blue');

ylabel('Average Time Taken (to interpret and navigate, s)')
ylim([ 0, ceil(max(AvgTimesTakenPD, [], 2) / 0.5) * 0.5 ])
set(gca,'ycolor','blue')

xlabel('Point Decimation (fraction remaining)')
title('Path Efficiency vs. Point Decimation Prior to Mesh Triangulation')
xlim([ 0, max(PointDecPD, [], 2) ])
set(gca,'XDir','Reverse')
grid on

legend('Average Excess Path Length', 'Average Time Taken', 'Location', 'north')

