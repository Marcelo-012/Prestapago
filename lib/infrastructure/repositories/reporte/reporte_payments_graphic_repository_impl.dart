import 'package:prestapagos/config/helpers/helpers.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/database/database.dart';

class ReportePaymentsGraphicRepositoryImpl
    extends ReportePaymentsGraphicRepository {
  final AppDatabase _db;

  ReportePaymentsGraphicRepositoryImpl({required this._db});

  @override
  Future<ReportePaymentsGraphic> getReportePaymentsGraphic() async {
    final pagosPorDia = await _db.customSelect('''
      SELECT
        d.numeroDia,
        COALESCE(SUM(a.monto_pagado), 0) AS totalMonto
      FROM (
        SELECT '0' AS numeroDia UNION ALL SELECT '1' UNION ALL
        SELECT '2' UNION ALL SELECT '3' UNION ALL
        SELECT '4' UNION ALL SELECT '5' UNION ALL
        SELECT '6'
      ) d
      LEFT JOIN amortizaciones a
        ON strftime('%w', a.fecha_pagado, 'unixepoch') = d.numeroDia
        AND a.fecha_pagado IS NOT NULL
      GROUP BY d.numeroDia
      ORDER BY d.numeroDia ASC
    ''').get();

    final montoPago = pagosPorDia
        .map((row) => row.read<double>('totalMonto'))
        .toList();

    final nombreDia = pagosPorDia
        .map((row) => HumanFormats.dayOfWeek(row.read<String>('numeroDia')))
        .toList();

    return ReportePaymentsGraphic(fechaPago: nombreDia, montoPago: montoPago);
  }
}
