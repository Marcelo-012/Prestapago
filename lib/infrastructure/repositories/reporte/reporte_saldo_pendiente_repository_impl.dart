import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/domain/repositories/reportes/reporte_saldo_pendiente_repository.dart';
import 'package:prestapagos/infrastructure/database/database.dart';

class ReporteSaldoPendienteRepositoryImpl
    extends ReporteSaldoPendienteRepository {
  final AppDatabase _db;

  ReporteSaldoPendienteRepositoryImpl({required this._db});

  @override
  Future<ReporteSaldoPendiente> getReporteSaldoPendiente() async {
    final rows = await _db.customSelect('''
      WITH RECURSIVE meses(mes) AS (
        SELECT strftime('%Y-%m', 'now', '-6 months')
        UNION ALL
        SELECT strftime('%Y-%m', mes || '-01', '+1 month')
        FROM meses
        WHERE mes < strftime('%Y-%m', 'now')
      )
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
