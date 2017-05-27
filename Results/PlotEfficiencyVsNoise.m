

figure(104);
hold off;

yyaxis left
plot(NoiseN, AvgExcessFractionN * 100, 'Color', 'black', 'LineWidth', 1.2);

ylabel('Average Excess Path Length (compared to optimum, %)')
ylim([ floor(100 * min(AvgExcessFractionN, [], 2) / 5) * 5 - 5 ...
        ceil(100 * max(AvgExcessFractionN, [], 2) / 5) * 5 ])

yyaxis right
plot(NoiseN, AvgTimesTakenN, '--', 'Color', 'blue');

ylabel('Average Time Taken (to interpret and navigate, s)')
ylim([ 0, ceil(max(AvgTimesTakenN, [], 2) / 0.5) * 0.5 ])
set(gca,'ycolor','blue')

xlabel('Noise (standard deviation, metres)')
title('Path Efficiency vs. Noise Applied to Point Locations')
xlim([ -0.01, max(NoiseN, [], 2) ])
set(gca,'XDir','Normal')
grid on

legend('Average Excess Path Length', 'Average Time Taken', 'Location', 'south')

