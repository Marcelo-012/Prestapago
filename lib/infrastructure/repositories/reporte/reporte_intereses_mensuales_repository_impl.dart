import 'package:prestapagos/config/helpers/helpers.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/database/database.dart';
import 'package:prestapagos/infrastructure/repositories/reporte/reporte_queries.dart';

class ReporteInteresesMensualesRepositoryImpl
    extends ReporteInteresesMensualesRepository {
  final AppDatabase _db;

  ReporteInteresesMensualesRepositoryImpl({required this._db});

  @override
  Future<ReporteInteresesMensuales> getReporteInteresesMensuales() async {
    final rows = await _db.customSelect('''
      $cteUltimos6Meses
      SELECT m.mes,
        COALESCE(SUM(a.monto_interes), 0) as total
      FROM meses m
      LEFT JOIN amortizaciones a
        ON a.estado_amortizacion = 'pagado'
        AND a.fecha_pagado IS NOT NULL
        AND strftime('%Y-%m', a.fecha_pagado, 'unixepoch') = m.mes
      GROUP BY m.mes
      ORDER BY m.mes ASC
    ''').get();

    final meses = rows
        .map((r) => HumanFormats.shortNameMonth(r.read<String>('mes')))
        .toList();
    final montos = rows.map((r) => r.read<double>('total')).toList();

    return ReporteInteresesMensuales(meses: meses, montos: montos);
  }
}
