import 'package:drift/drift.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/domain/repositories/clientes/cliente_repository.dart';
import 'package:prestapagos/infrastructure/database/database.dart';

class ClienteRepositoryImpl implements ClienteRepository {
  final AppDatabase _db;

  ClienteRepositoryImpl(this._db);

  @override
  Future<PagedResult<ClienteResumen>> getPaged({
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
        d.id_deudor,
        d.nombre,
        d.telefono,
        d.estado,
        COALESCE((SELECT AVG(s.score) FROM scores s WHERE s.id_deudor = d.id_deudor), 0) AS score
      FROM deudores d
      WHERE (? = 0 OR d.nombre LIKE ? OR d.telefono LIKE ?)
      ORDER BY d.nombre ASC
      LIMIT ? OFFSET ?
    ''',
          variables: [
            Variable<int>(applyFilter ? 1 : 0),
            Variable<String>(searchPattern),
            Variable<String>(searchPattern),
            Variable<int>(limit),
            Variable<int>(offset),
          ],
        )
        .get();

    final hasMore = rows.length > pageSize;
    final items = rows.take(pageSize).map((row) {
      return ClienteResumen(
        idDeudor: row.read<int>('id_deudor'),
        nombre: row.read<String>('nombre'),
        telefono: row.read<String>('telefono'),
        estado: row.read<String>('estado'),
        score: row.read<double>('score'),
      );
    }).toList();

    return PagedResult(items: items, hasMore: hasMore);
  }

  @override
  Future<Cliente> getById(int idDeudor) async {
    final cliente = await (_db.select(
      _db.deudores,
    )..where((cliente) => cliente.id.equals(idDeudor))).getSingle();

    return Cliente(
      idDeudor: cliente.id,
      nombre: cliente.nombre,
      telefono: cliente.telefono,
      email: cliente.correoElectronico,
      direccion: cliente.direccion,
      dni: cliente.numeroIdentificacion,
      edad: cliente.edad,
      estado: cliente.estado.name,
      fechaCreacion: cliente.fechaCreacion,
      fechaActualizacion: cliente.fechaActualizacion,
    );
  }

  @override
  Future<ClienteDetalle> getDetalle(int idDeudor) async {
    final cliente = await getById(idDeudor);

    final prestamosRows = await _db
        .customSelect(
          '''
      SELECT
        p.id_prestamo,
        p.id_deudor,
        p.tasa_interes,
        p.tasa_interes_moratoria,
        p.monto,
        p.plazo_meses,
        p.monto_cuota,
        p.fecha_creacion,
        COALESCE(cp.estado_prestamo, 'activo') AS estado_prestamo,
        cp.fecha_actualizacion AS fecha_actualizacion,
        COALESCE((SELECT SUM(a.monto_capital) FROM amortizaciones a
         WHERE a.id_prestamo = p.id_prestamo AND a.estado_amortizacion = 'pagado'), 0) AS total_pagado
      FROM prestamos p
      LEFT JOIN configuracion_prestamos cp ON cp.id_prestamo = p.id_prestamo
      WHERE p.id_deudor = ?
      ORDER BY p.fecha_creacion DESC
    ''',
          variables: [Variable<int>(idDeudor)],
        )
        .get();

    final row = await _db
        .customSelect(
          '''
      SELECT
        COALESCE((SELECT AVG(s.score) FROM scores s WHERE s.id_deudor = ?), 0) AS score_promedio,
        (SELECT COUNT(*) FROM prestamos p WHERE p.id_deudor = ?) AS total_prestamos,
        (SELECT COUNT(*) FROM configuracion_prestamos cp
         INNER JOIN prestamos p ON cp.id_prestamo = p.id_prestamo
         WHERE p.id_deudor = ? AND cp.estado_prestamo = 'activo') AS total_prestamos_activos,
        (SELECT COUNT(*) FROM configuracion_prestamos cp
         INNER JOIN prestamos p ON cp.id_prestamo = p.id_prestamo
         WHERE p.id_deudor = ? AND cp.estado_prestamo = 'finalizado') AS total_prestamos_finalizados,
        COALESCE((SELECT SUM(p.monto) FROM prestamos p
         WHERE p.id_deudor = ?), 0) AS total_prestado,
        COALESCE((SELECT SUM(a.monto_capital) FROM amortizaciones a
         INNER JOIN prestamos p ON a.id_prestamo = p.id_prestamo
         WHERE p.id_deudor = ? AND a.estado_amortizacion = 'pagado'), 0) AS total_deuda_pagada
    ''',
          variables: [
            Variable<int>(idDeudor),
            Variable<int>(idDeudor),
            Variable<int>(idDeudor),
            Variable<int>(idDeudor),
            Variable<int>(idDeudor),
            Variable<int>(idDeudor),
          ],
        )
        .getSingle();

    final prestamosDomain = prestamosRows
        .map(
          (p) => Loan(
            idPrestamo: p.read<int>('id_prestamo'),
            idDeudor: p.read<int>('id_deudor'),
            tasaInteres: p.read<double>('tasa_interes'),
            tasaInteresMoratoria: p.read<double>('tasa_interes_moratoria'),
            monto: p.read<double>('monto'),
            plazo: p.read<int>('plazo_meses'),
            montoCuota: p.read<double>('monto_cuota'),
            fechaCreacion: p.read<DateTime>('fecha_creacion'),
            estado: p.read<String>('estado_prestamo'),
            totalPagado: p.read<double>('total_pagado'),
            fechaActualizacion: p.read<DateTime?>('fecha_actualizacion'),
          ),
        )
        .toList();

    return ClienteDetalle(
      cliente: cliente,
      scorePromedio: row.read<double>('score_promedio'),
      prestamos: prestamosDomain,
      totalPrestamos: row.read<int>('total_prestamos'),
      totalPrestamosActivos: row.read<int>('total_prestamos_activos'),
      totalPrestamosFinalizados: row.read<int>('total_prestamos_finalizados'),
      totalPrestado: row.read<double>('total_prestado'),
      totalDeudaPagada: row.read<double>('total_deuda_pagada'),
    );
  }

  @override
  Future<void> createCliente(Cliente cliente) async {
    await _db
        .into(_db.deudores)
        .insert(
          DeudoresCompanion.insert(
            nombre: cliente.nombre,
            telefono: cliente.telefono,
            direccion: cliente.direccion,
            numeroIdentificacion: cliente.dni,
            edad: cliente.edad,
            estado: EstadoCliente.activo,
            fechaCreacion: Value(DateTime.now()),
          ),
        );
  }

  @override
  Future<void> deleteCliente(int idDeudor) async {
    await (_db.delete(_db.deudores)
      ..where((t) => t.id.equals(idDeudor))
    ).go();
  }

  @override
  Future<int> countRelatedRecords(int idDeudor) async {
    final rows = await _db.customSelect(
      '''
      SELECT COUNT(*) AS total FROM prestamos p WHERE p.id_deudor = ?
    ''',
      variables: [Variable<int>(idDeudor)],
    ).getSingle();
    return rows.read<int>('total');
  }

  @override
  Future<void> deactivateCliente(int idDeudor) async {
    await (_db.update(_db.deudores)
      ..where((t) => t.id.equals(idDeudor))
    ).write(DeudoresCompanion(
      estado: Value(EstadoCliente.inactivo),
      fechaActualizacion: Value(DateTime.now()),
    ));
  }

  @override
  Future<void> reactivateCliente(int idDeudor) async {
    await (_db.update(_db.deudores)
      ..where((t) => t.id.equals(idDeudor))
    ).write(DeudoresCompanion(
      estado: Value(EstadoCliente.activo),
      fechaActualizacion: Value(DateTime.now()),
    ));
  }

  @override
  Future<void> updateCliente(Cliente cliente) async {
    await (_db.update(
      _db.deudores,
    )..where((t) => t.id.equals(cliente.idDeudor))).write(
      DeudoresCompanion(
        nombre: Value(cliente.nombre),
        telefono: Value(cliente.telefono),
        correoElectronico: Value(cliente.email),
        direccion: Value(cliente.direccion),
        numeroIdentificacion: Value(cliente.dni),
        edad: Value(cliente.edad),
        estado: Value(EstadoCliente.activo),
        fechaActualizacion: Value(DateTime.now()),
      ),
    );
  }
}
