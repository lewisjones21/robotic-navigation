

figure(104);

yyaxis left
plot(MeshDecMD, AvgExcessFractionMD * 100, 'Color', 'black');

ylabel('Average Excess Path Length (compared to optimum, %)')
ylim([ floor(100 * min(AvgExcessFractionMD, [], 2) / 5) * 5 ...
        ceil(100 * max(AvgExcessFractionMD, [], 2) / 5) * 5 ])

yyaxis right
plot(MeshDecMD, AvgTimesTakenMD, '--', 'Color', 'blue');

ylabel('Average Time Taken (to interpret and navigate, s)')
ylim([ 0, ceil(max(AvgTimesTakenMD, [], 2) / 0.5) * 0.5 ])
set(gca,'ycolor','blue')

xlabel('Mesh Decimation (proportional number of triangles compared to original mesh)')
title('Path Efficiency vs. Mesh Decimation Prior to Navigation Graph Generation')
xlim([ 0, max(MeshDecMD, [], 2) ])
set(gca,'XDir','Reverse')
grid on

legend('Average Excess Path Length', 'Average Time Taken', 'Location', 'south')

