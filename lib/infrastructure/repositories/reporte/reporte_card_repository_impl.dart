import 'package:drift/drift.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/database/database.dart';

class ReporteCardRepositoryImpl implements ReporteCardRepository {
  final AppDatabase _db;

  ReporteCardRepositoryImpl(this._db);

  @override
  Future<ReporteCard> getReporteCard() async {
    final now = DateTime.now();
    final yM = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    final results = await Future.wait([
      _db.customSelect('SELECT COALESCE(SUM(monto), 0) AS total FROM prestamos').getSingle(),
      _db.customSelect(
        "SELECT COALESCE(SUM(monto_pagado), 0) AS total FROM amortizaciones",
      ).getSingle(),
      _db.customSelect(
        'SELECT COALESCE(SUM(monto - COALESCE('
        '(SELECT SUM(monto_pagado) FROM amortizaciones WHERE id_prestamo = p.id_prestamo), 0'
        ')), 0) AS total FROM prestamos p',
      ).getSingle(),
      _db.customSelect(
        "SELECT COALESCE(SUM(monto_interes),0) AS total FROM amortizaciones WHERE estado_amortizacion = 'pagado'",
      ).getSingle(),
      _db.customSelect(
        "SELECT COALESCE(SUM(monto_mora),0) AS total FROM amortizaciones WHERE estado_amortizacion = 'pagado'",
      ).getSingle(),
      _db.customSelect(
        'SELECT COALESCE(SUM(monto),0) AS total FROM prestamos '
        "WHERE strftime('%Y-%m',fecha_creacion,'unixepoch') = ?",
        variables: [Variable<String>(yM)],
      ).getSingle(),
      _db.customSelect(
        "SELECT COALESCE(SUM(monto_pagado),0) AS total FROM amortizaciones "
        "WHERE strftime('%Y-%m',fecha_pagado,'unixepoch') = ? AND estado_amortizacion = 'pagado'",
        variables: [Variable<String>(yM)],
      ).getSingle(),
      _db.customSelect(
        "SELECT COALESCE(SUM(monto_interes+monto_mora),0) AS total FROM amortizaciones "
        "WHERE strftime('%Y-%m',fecha_pagado,'unixepoch') = ? AND estado_amortizacion = 'pagado'",
        variables: [Variable<String>(yM)],
      ).getSingle(),
      _db.customSelect('SELECT COUNT(*) AS total FROM deudores').getSingle(),
      _db.customSelect('SELECT COUNT(*) AS total FROM prestamos').getSingle(),
      _db.customSelect(
        "SELECT COUNT(*) AS total FROM configuracion_prestamos WHERE estado_prestamo IN ('activo', 'atrasado')",
      ).getSingle(),
    ]);

    return ReporteCard(
      totalPrestado: results[0].read<double>('total'),
      totalPagado: results[1].read<double>('total'),
      totalPendiente: results[2].read<double>('total'),
      totalInteresesCobrados: results[3].read<double>('total'),
      totalInteresesMoraCobrados: results[4].read<double>('total'),
      totalPrestadoEsteMes: results[5].read<double>('total'),
      totalCobradoEsteMes: results[6].read<double>('total'),
      totalGanadoEsteMes: results[7].read<double>('total'),
      totalPrestamos: results[9].read<int>('total'),
      totalPrestamosActivos: results[10].read<int>('total'),
      totalClientes: results[8].read<int>('total'),
    );
  }
}
