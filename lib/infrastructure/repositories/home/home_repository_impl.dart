import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/database/database.dart';

class HomeRepositoryImpl extends HomeRepository {
  final AppDatabase _db;

  HomeRepositoryImpl({required this._db});

  @override
  Future<List<UltimoPago>> getUltimosPagos() async {
    final rows = await _db.customSelect('''
      SELECT a.id_amortizacion, a.id_prestamo, p.id_deudor, d.nombre,
        a.monto_pagado, a.fecha_pagado, a.monto_capital, a.monto_interes, a.monto_mora
      FROM amortizaciones a
      JOIN prestamos p ON p.id_prestamo = a.id_prestamo
      JOIN deudores d ON d.id_deudor = p.id_deudor
      WHERE a.fecha_pagado IS NOT NULL
      ORDER BY a.fecha_pagado DESC
      LIMIT 5
    ''').get();

    return rows.map((r) {
      final fechaInt = r.read<int>('fecha_pagado');
      return UltimoPago(
        idAmortizacion: r.read<int>('id_amortizacion'),
        idPrestamo: r.read<int>('id_prestamo'),
        idDeudor: r.read<int>('id_deudor'),
        nombreCliente: r.read<String>('nombre'),
        montoPagado: r.read<double>('monto_pagado'),
        fechaPagado: DateTime.fromMillisecondsSinceEpoch(fechaInt * 1000),
        montoCapital: r.read<double>('monto_capital'),
        montoInteres: r.read<double>('monto_interes'),
        montoMora: r.read<double>('monto_mora'),
      );
    }).toList();
  }

  @override
  Future<List<ProximoVencimiento>> getProximosVencimientos() async {
    final rows = await _db.customSelect('''
      SELECT a.id_prestamo, p.id_deudor, d.nombre,
        a.monto_capital, a.monto_interes, a.fecha_vencimiento,
        a.dias_mora, a.estado_amortizacion
      FROM amortizaciones a
      JOIN prestamos p ON p.id_prestamo = a.id_prestamo
      JOIN deudores d ON d.id_deudor = p.id_deudor
      WHERE a.estado_amortizacion IN ('pendiente', 'atrasado')
      ORDER BY a.fecha_vencimiento ASC
      LIMIT 5
    ''').get();

    return rows.map((r) {
      final fechaInt = r.read<int>('fecha_vencimiento');
      return ProximoVencimiento(
        idPrestamo: r.read<int>('id_prestamo'),
        idDeudor: r.read<int>('id_deudor'),
        nombreCliente: r.read<String>('nombre'),
        montoCapital: r.read<double>('monto_capital'),
        montoInteres: r.read<double>('monto_interes'),
        fechaVencimiento: DateTime.fromMillisecondsSinceEpoch(fechaInt * 1000),
        diasMora: r.read<int>('dias_mora'),
        estado: r.read<String>('estado_amortizacion'),
      );
    }).toList();
  }

  @override
  Future<List<ClienteResumen>> getMejoresClientes() async {
    final rows = await _db.customSelect('''
      SELECT d.id_deudor, d.nombre, d.telefono,
        COALESCE(d.email, '') as email, d.direccion,
        d.numero_identificacion, d.edad, d.estado,
        COALESCE((
          SELECT ROUND(AVG(sq.score)) FROM (
            SELECT s.score FROM scores s
            INNER JOIN prestamos p ON s.id_prestamo = p.id_prestamo
            WHERE p.id_deudor = d.id_deudor
            ORDER BY p.fecha_creacion DESC LIMIT 5
          ) sq
        ), 0) AS score
      FROM deudores d
      ORDER BY score DESC
      LIMIT 5
    ''').get();

    return rows.map((r) => ClienteResumen(
      idDeudor: r.read<int>('id_deudor'),
      nombre: r.read<String>('nombre'),
      telefono: r.read<String>('telefono'),
      estado: r.read<String>('estado'),
      score: r.read<double>('score'),
    )).toList();
  }
}
