import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/domain/repositories/reportes/reporte_composicion_pagos_repository.dart';
import 'package:prestapagos/infrastructure/database/database.dart';

class ReporteComposicionPagosRepositoryImpl
    extends ReporteComposicionPagosRepository {
  final AppDatabase _db;

  ReporteComposicionPagosRepositoryImpl({required this._db});

  @override
  Future<ReporteComposicionPagos> getReporteComposicionPagos() async {
    final row = await _db.customSelect('''
      SELECT
        COALESCE(SUM(a.monto_capital), 0) as total_capital,
        COALESCE(SUM(a.monto_interes), 0) as total_interes,
        COALESCE(SUM(a.monto_mora), 0) as total_mora
      FROM amortizaciones a
      WHERE a.estado_amortizacion = 'pagado'
        AND strftime('%Y-%m', a.fecha_pagado, 'unixepoch') = strftime('%Y-%m', 'now')
    ''').getSingle();

    return ReporteComposicionPagos(
      totalCapital: row.read<double>('total_capital'),
      totalInteres: row.read<double>('total_interes'),
      totalMora: row.read<double>('total_mora'),
    );
  }
}
