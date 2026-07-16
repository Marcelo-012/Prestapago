import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartItem extends StatelessWidget {
  final String nombreGrafica;
  final List<String> labels;
  final List<double> values;
  final List<Color> colors;

  const PieChartItem({
    super.key,
    required this.nombreGrafica,
    required this.labels,
    required this.values,
    required this.colors,
  }) : assert(
         labels.length == values.length && values.length == colors.length,
         'labels, values y colors deben tener la misma longitud',
       );

  @override
  Widget build(BuildContext context) {
    final total = values.fold(0.0, (sum, v) => sum + v);
    if (total <= 0) return const SizedBox.shrink();

    return AspectRatio(
      aspectRatio: 1.3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: List.generate(labels.length, (i) {
                        final pct = total > 0 ? values[i] / total * 100 : 0.0;
                        return PieChartSectionData(
                          color: colors[i],
                          value: values[i],
                          title: '${pct.toStringAsFixed(1)}%',
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }),
                      centerSpaceRadius: 30,
                      sectionsSpace: 2,
                    ),
                    duration: const Duration(milliseconds: 250),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(labels.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: colors[i],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${labels[i]} (${values[i].toInt()})',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}
