import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartItem extends StatelessWidget {
  final String nombreGrafica;
  final List<String> ejeX;
  final List<double> ejeY;
  final List<String> contenido;
  final Color barColor;
  final double aspectRatio;

  const BarChartItem({
    super.key,
    required this.nombreGrafica,
    required this.ejeX,
    required this.ejeY,
    required this.contenido,
    this.barColor = Colors.blue,
    this.aspectRatio = 1.5,
  }) : assert(
         ejeX.length == ejeY.length && ejeY.length == contenido.length,
         'ejeX, ejeY y contenido deben tener la misma longitud',
       );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final maxY = ejeY.isEmpty
        ? 1.0
        : ejeY.reduce((a, b) => a > b ? a : b) * 1.2;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            nombreGrafica,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 6),
              child: BarChart(
                BarChartData(
                  minY: 0,
                  maxY: maxY,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(
                        color: colors.outline.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      left: const BorderSide(color: Colors.transparent),
                      right: const BorderSide(color: Colors.transparent),
                      top: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= ejeX.length) {
                            return const SizedBox.shrink();
                          }
                          final label = ejeX[index];
                          return SideTitleWidget(
                            meta: meta,
                            space: 8,
                            child: Text(
                              label.length <= 7
                                  ? label
                                  : '${label.substring(0, 5)}.',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) =>
                          colors.primary.withValues(alpha: 0.85),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final index = group.x.toInt();
                        final texto = (index >= 0 && index < contenido.length)
                            ? contenido[index]
                            : rod.toY.toStringAsFixed(2);
                        return BarTooltipItem(
                          texto,
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  barGroups: List.generate(ejeY.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: ejeY[i],
                          color: barColor,
                          width: 16,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                duration: const Duration(milliseconds: 250),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
