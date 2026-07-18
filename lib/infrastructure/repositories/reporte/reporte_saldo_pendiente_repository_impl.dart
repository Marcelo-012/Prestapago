import 'package:prestapagos/config/helpers/helpers.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/database/database.dart';
import 'package:prestapagos/infrastructure/repositories/reporte/reporte_queries.dart';

class ReporteSaldoPendienteRepositoryImpl
    extends ReporteSaldoPendienteRepository {
  final AppDatabase _db;

  ReporteSaldoPendienteRepositoryImpl({required this._db});

  @override
  Future<ReporteSaldoPendiente> getReporteSaldoPendiente() async {
    final rows = await _db.customSelect('''
      $cteUltimos6Meses
      SELECT m.mes,
        COALESCE((
          SELECT SUM(a.monto_capital)
          FROM amortizaciones a
          WHERE a.estado_amortizacion IN ('pendiente', 'atrasado')
            AND a.id_prestamo IN (
              SELECT p.id_prestamo FROM prestamos p
              WHERE strftime('%Y-%m', p.fecha_creacion, 'unixepoch') <= m.mes
            )
        ), 0) as saldo
      FROM meses m
      ORDER BY m.mes ASC
    ''').get();

    final meses = rows
        .map((r) => HumanFormats.shortNameMonth(r.read<String>('mes')))
        .toList();
    final saldos = rows.map((r) => r.read<double>('saldo')).toList();

    return ReporteSaldoPendiente(meses: meses, saldos: saldos);
  }
}
