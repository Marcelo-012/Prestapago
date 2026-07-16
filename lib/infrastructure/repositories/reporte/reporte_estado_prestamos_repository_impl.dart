import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/domain/repositories/reportes/reporte_estado_prestamos_repository.dart';
import 'package:prestapagos/infrastructure/database/database.dart';

class ReporteEstadoPrestamosRepositoryImpl
    extends ReporteEstadoPrestamosRepository {
  final AppDatabase _db;

  ReporteEstadoPrestamosRepositoryImpl({required this._db});

  @override
  Future<ReporteEstadoPrestamos> getReporteEstadoPrestamos() async {
    final rows = await _db.customSelect('''
      SELECT c.estado_prestamo, COUNT(*) as cantidad
      FROM configuracion_prestamos c
      GROUP BY c.estado_prestamo
      ORDER BY cantidad DESC
    ''').get();

    final estados = rows.map((r) => r.read<String>('estado_prestamo')).toList();
    final cantidades = rows
        .map((r) => (r.read<int>('cantidad')).toDouble())
        .toList();

    return ReporteEstadoPrestamos(estados: estados, cantidades: cantidades);
  }
}
