import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/domain/repositories/reportes/reporte_morosidad_repository.dart';
import 'package:prestapagos/infrastructure/database/database.dart';

class ReporteMorosidadRepositoryImpl extends ReporteMorosidadRepository {
  final AppDatabase _db;

  ReporteMorosidadRepositoryImpl({required this._db});

  @override
  Future<ReporteMorosidad> getReporteMorosidad() async {
    final rows = await _db.customSelect('''
      SELECT
        CASE
          WHEN a.dias_mora BETWEEN 1 AND 30 THEN '1-30 días'
          WHEN a.dias_mora BETWEEN 31 AND 60 THEN '31-60 días'
          WHEN a.dias_mora BETWEEN 61 AND 90 THEN '61-90 días'
          ELSE '90+ días'
        END as rango,
        COUNT(*) as cantidad
      FROM amortizaciones a
      WHERE a.estado_amortizacion = 'atrasado'
      GROUP BY rango
      ORDER BY MIN(a.dias_mora) ASC
    ''').get();

    final rangos = rows.map((r) => r.read<String>('rango')).toList();
    final cantidades = rows.map((r) => r.read<int>('cantidad')).toList();

    return ReporteMorosidad(rangos: rangos, cantidades: cantidades);
  }
}
