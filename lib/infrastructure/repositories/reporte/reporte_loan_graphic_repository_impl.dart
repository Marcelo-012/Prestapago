import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/domain/entities/entities.dart';
import 'package:prestapagos/domain/repositories/reportes/reporte_loan_graphic_repository.dart';
import 'package:prestapagos/infrastructure/database/database.dart';

class ReporteLoanGraphicRepositoryImpl extends ReporteLoanGraphicRepository {
  final AppDatabase _db;

  ReporteLoanGraphicRepositoryImpl(this._db);

  @override
  Future<ReporteLoanGraphic> getReporteLoanGraphic() async {
    final prestamosPorMesRows = await _db.customSelect('''
    SELECT 
      strftime('%Y-%m', fecha_creacion, 'unixepoch') AS mes,
      COALESCE(SUM(monto), 0) AS totalMonto
    FROM prestamos
    WHERE fecha_creacion IS NOT NULL
    GROUP BY strftime('%Y-%m', fecha_creacion, 'unixepoch')
    ORDER BY mes ASC
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
