import 'package:prestapagos/config/helpers/helpers.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/database/database.dart';
import 'package:prestapagos/infrastructure/repositories/reporte/reporte_queries.dart';

class ReporteLoanGraphicRepositoryImpl extends ReporteLoanGraphicRepository {
  final AppDatabase _db;

  ReporteLoanGraphicRepositoryImpl(this._db);

  @override
  Future<ReporteLoanGraphic> getReporteLoanGraphic() async {
    final prestamosPorMesRows = await _db.customSelect('''
      $cteUltimos6Meses
      SELECT m.mes,
        COALESCE((
          SELECT SUM(p.monto) FROM prestamos p
          INNER JOIN configuracion_prestamos cp ON cp.id_prestamo = p.id_prestamo
          WHERE strftime('%Y-%m', p.fecha_creacion, 'unixepoch') <= m.mes
            AND cp.estado_prestamo NOT IN ('cancelado', 'incobrable')
        ), 0) AS totalMonto
      FROM meses m
      ORDER BY m.mes ASC
    ''').get();

    final montoMes = prestamosPorMesRows
        .map((row) => row.read<double>('totalMonto'))
        .toList();

    final nombreMes = prestamosPorMesRows
        .map((row) => HumanFormats.nameMonth(row.read<String>('mes')))
        .toList();

    return ReporteLoanGraphic(montoMes: montoMes, nombreMes: nombreMes);
  }
}
