import 'package:drift/drift.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/domain/repositories/prestamos/prestamos_repository.dart';
import 'package:prestapagos/infrastructure/database/database.dart' as drift;

class PrestamoRepositoryImpl implements PrestamoRepository {
  final drift.AppDatabase _db;

  PrestamoRepositoryImpl({required this._db});

  @override
  Future<void> cancelarPrestamo(int idPrestamo) {
    // TODO: implement cancelarPrestamo
    throw UnimplementedError();
  }

  @override
  Future<int> countAmortizaciones(int idPrestamo) {
    // TODO: implement countAmortizaciones
    throw UnimplementedError();
  }

  @override
  Future<void> createPrestamo(Prestamo prestamo) {
    // TODO: implement createPrestamo
    throw UnimplementedError();
  }

  @override
  Future<void> deletePrestamo(int idPrestamo) {
    // TODO: implement deletePrestamo
    throw UnimplementedError();
  }

  @override
  Future<void> finalizarPrestamo(int idPrestamo) {
    // TODO: implement finalizarPrestamo
    throw UnimplementedError();
  }

  @override
  Future<Prestamo> getById(int idPrestamo) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<PrestamoDetalle> getDetalle(int idPrestamo) {
    // TODO: implement getDetalle
    throw UnimplementedError();
  }

  @override
  Future<PagedResult<PrestamoResumen>> getPaged({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final limit = pageSize + 1;
    final offset = page * pageSize;

    final searchPattern = (search != null && search.isNotEmpty)
        ? '%$search%'
        : '';

    final applyFilter = searchPattern.isNotEmpty;

    final rows = await _db
        .customSelect(
          '''
      SELECT
        p.id_prestamo,
        p.id_deudor,
        p.monto,
        p.plazo_meses,
        p.monto_cuota,
        p.fecha_creacion,
        (SELECT d.nombre FROM deudores d WHERE d.id_deudor = p.id_deudor) AS nombre,
        (SELECT COALESCE(SUM(a.monto_capital), 0) FROM amortizaciones a
         WHERE a.id_prestamo = p.id_prestamo AND a.estado_amortizacion = 'pagado') AS total_pagado,
        (SELECT cp.estado_prestamo FROM configuracion_prestamos cp
         WHERE cp.id_prestamo = p.id_prestamo) AS estado_prestamo,
        (SELECT a.estado_amortizacion FROM amortizaciones a
         WHERE a.id_prestamo = p.id_prestamo ORDER BY a.id_cuota DESC LIMIT 1) AS estado_ultimo_pago
      FROM prestamos p
      WHERE (? = 0 OR (SELECT d.nombre FROM deudores d WHERE d.id_deudor = p.id_deudor) LIKE ?)
      ORDER BY p.fecha_creacion DESC
      LIMIT ? OFFSET ?
    ''',
          variables: [
            Variable<int>(applyFilter ? 1 : 0),
            Variable<String>(searchPattern),
            Variable<int>(limit),
            Variable<int>(offset),
          ],
        )
        .get();

    final hasMore = rows.length > pageSize;
    final items = rows.take(pageSize).map((row) {
      final totalPagado = row.read<double>('total_pagado');
      final monto = row.read<double>('monto');

      return PrestamoResumen(
        idDeudor: row.read<int>('id_deudor'),
        monto: monto,
        plazo: row.read<int>('plazo_meses'),
        cuota: row.read<double>('monto_cuota'),
        saldoPorPagar: (monto - totalPagado).clamp(0, double.infinity),
        nombre: row.read<String>('nombre'),
        idPrestamo: row.read<int>('id_prestamo'),
        estadoUltimoPago: row.read<String>('estado_ultimo_pago'),
        estadoPrestamo: row.read<String>('estado_prestamo'),
        fechaCreacion: row.read<DateTime>('fecha_creacion'),
      );
    }).toList();

    return PagedResult(items: items, hasMore: hasMore);
  }

  @override
  Future<void> updatePrestamo(Prestamo prestamo) {
    // TODO: implement updatePrestamo
    throw UnimplementedError();
  }
}
