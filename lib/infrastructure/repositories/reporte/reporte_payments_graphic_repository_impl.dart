import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/domain/entities/reportes/reporte_payments_graphic.dart';
import 'package:prestapagos/domain/repositories/reportes/reporte_payments_graphic_repository.dart';
import 'package:prestapagos/infrastructure/database/database.dart';

class ReportePaymentsGraphicRepositoryImpl
    extends ReportePaymentsGraphicRepository {
  final AppDatabase _db;

  ReportePaymentsGraphicRepositoryImpl({required this._db});

  @override
  Future<ReportePaymentsGraphic> getReportePaymentsGraphic() async {
    final pagosPorDia = await _db.customSelect('''
  SELECT 
    strftime('%w', fecha_pagado, 'unixepoch') AS numeroDia,
    COALESCE(SUM(monto_pagado), 0) AS totalMonto
  FROM amortizaciones
  WHERE fecha_pagado IS NOT NULL
  GROUP BY strftime('%w', fecha_pagado, 'unixepoch')
  ORDER BY numeroDia ASC
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
