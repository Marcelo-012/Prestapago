import 'package:prestapagos/config/helpers/helpers.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphicItem extends StatelessWidget {
  final String nombreGrafica;
  final List<String> ejeX;
  final List<double> ejeY;
  final List<String> contenido;

  const GraphicItem({
    super.key,
    required this.nombreGrafica,
    required this.ejeX,
    required this.ejeY,
    required this.contenido,
  }) : assert(
         ejeX.length == ejeY.length && ejeY.length == contenido.length,
         'ejeX, ejeY y contenido deben tener la misma longitud',
       );

  List<FlSpot> get _spots =>
      List.generate(ejeY.length, (i) => FlSpot(i.toDouble(), ejeY[i]));

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final ejes = ChartHelpers.calcularEjeY(ejeY, forzarMinCero: false);

    return AspectRatio(
      aspectRatio: 1.5,
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
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: (ejeY.length - 1).toDouble(),
                  minY: ejes.minY,
                  maxY: ejes.maxY,
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
                        interval: ejes.interval, // ← Aquí se usa
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
                        interval: (ejeX.length / 10).ceil().clamp(1, 999).toDouble(),
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
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) =>
                          colors.primary.withValues(alpha: 0.85),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final index = spot.x.toInt();
                          final texto = (index >= 0 && index < contenido.length)
                              ? contenido[index]
                              : spot.y.toString();
                          return LineTooltipItem(
                            texto,
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: colors.primary,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: colors.primary.withValues(alpha: 0.15),
                      ),
                      spots: _spots,
                    ),
                  ],
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
