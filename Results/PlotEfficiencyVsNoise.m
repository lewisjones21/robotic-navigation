

figure(104);

set(gca, 'ColorOrder', [0 0 0; 0 0 1], 'NextPlot', 'replacechildren');

yyaxis left
plot(NoiseN, AvgExcessFractionN * 100, 'Color', 'black');

ylabel('Average Excess Path Length (compared to optimum, %)')
ylim([ round(100 * min(AvgExcessFractionN, [], 2) / 5) * 5 - 5 ...
        round(100 * max(AvgExcessFractionN, [], 2) / 5) * 5 ])

yyaxis right
h = plot(NoiseN, AvgTimesTakenN, '--', 'Color', 'blue');

ylabel('Average Time Taken (to interpret and navigate, s)')
ylim([ 0, round(max(AvgTimesTakenN, [], 2) / 1) * 1 + 0.5 ])
set(gca,'ycolor','blue')

xlabel('Noise (standard deviation, metres)')
title('Path Efficiency vs. Noise Applied to Point Locations')
xlim([ -0.01, max(NoiseN, [], 2) ])
grid on

legend('Average Excess Path Length', 'Average Time Taken', 'Location', 'south')

