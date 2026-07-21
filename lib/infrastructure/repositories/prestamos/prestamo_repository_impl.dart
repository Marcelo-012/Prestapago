import 'package:drift/drift.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/database/database.dart' as drift;
import 'package:prestapagos/infrastructure/services/services.dart';

class PrestamoRepositoryImpl implements PrestamoRepository {
  final drift.AppDatabase _db;
  final EstadoPrestamoService _estadoPrestamoService;

  PrestamoRepositoryImpl({
    required this._db,
    required this._estadoPrestamoService,
  });

  @override
  Future<Prestamo> getById(int idPrestamo) async {
    final row = await _db
        .customSelect(
          '''
      SELECT
        id_prestamo, id_deudor, tasa_interes, tasa_interes_moratoria,
        monto, plazo_meses, monto_cuota, fecha_creacion
      FROM prestamos
      WHERE id_prestamo = ?
    ''',
          variables: [Variable<int>(idPrestamo)],
        )
        .getSingle();

    return Prestamo(
      idPrestamo: row.read<int>('id_prestamo'),
      idDeudor: row.read<int>('id_deudor'),
      tasaInteres: row.read<double>('tasa_interes'),
      tasaInteresMoratoria: row.read<double>('tasa_interes_moratoria'),
      monto: row.read<double>('monto'),
      plazo: row.read<int>('plazo_meses'),
      montoCuota: row.read<double>('monto_cuota'),
      fechaCreacion: row.read<DateTime>('fecha_creacion'),
    );
  }

  @override
  Future<int> createPrestamo(CreatePrestamoDTO dto) async {
    return _db.transaction(() async {
      final deudor = await (_db.select(_db.deudores)
        ..where((t) => t.id.equals(dto.idDeudor))).getSingleOrNull();
      if (deudor == null) {
        throw Exception('El cliente no existe');
      }
      if (deudor.estado == EstadoCliente.inactivo) {
        throw Exception('No se puede crear un préstamo para un cliente inactivo');
      }

      final idPrestamo = await _db
          .into(_db.prestamos)
          .insert(
            drift.PrestamosCompanion.insert(
              idDeudor: dto.idDeudor,
              tasaInteres: dto.tasaInteres,
              tasaMoratoria: dto.tasaInteresMoratoria,
              monto: dto.monto,
              plazoMeses: dto.plazo,
              montoCuota: dto.montoCuota,
            ),
          );

      await _db
          .into(_db.configuracionPrestamos)
          .insert(
            drift.ConfiguracionPrestamosCompanion.insert(
              idPrestamo: idPrestamo,
              tipoInteres: TipoInteres.values.byName(dto.tipoInteres),
              estadoMoratorio: EstadoMoratorio.values.byName(dto.estadoMoratorio),
              manejoExcedente: ManejoExcedente.values.firstWhere(
                (e) => e.value == dto.manejoExcedente,
              ),
              periodidadIntereses: PeriodicidadInteres.values.byName(
                dto.periodidadIntereses,
              ),
              estadoPrestamo: EstadoPrestamo.values.byName(dto.estadoPrestamo),
            ),
          );

      for (final a in dto.amortizaciones) {
        await _db
            .into(_db.amortizaciones)
            .insert(
              drift.AmortizacionesCompanion.insert(
                idPrestamo: idPrestamo,
                idCuota: a.idCuota,
                fechaVencimiento: a.fechaVencimiento,
                montoInicial: a.montoInicial,
                montoPagado: 0,
                montoACapital: a.montoCapital,
                montoInteres: a.montoInteres,
                montoMora: a.montoMora,
                montoExcedente: 0,
                estadoAmortizacion: EstadoAmortizacion.pendiente,
              ),
            );
      }
      return idPrestamo;
    });
  }

  @override
  Future<void> updatePrestamo(Prestamo prestamo) async {
    await (_db.update(
      _db.prestamos,
    )..where((t) => t.id.equals(prestamo.idPrestamo))).write(
      drift.PrestamosCompanion(
        idDeudor: Value(prestamo.idDeudor),
        tasaInteres: Value(prestamo.tasaInteres),
        tasaMoratoria: Value(prestamo.tasaInteresMoratoria),
        monto: Value(prestamo.monto),
        plazoMeses: Value(prestamo.plazo),
        montoCuota: Value(prestamo.montoCuota),
      ),
    );
  }

  @override
  Future<void> deletePrestamo(int idPrestamo) async {
    await _db.transaction(() async {
      final exists = await _db.customSelect(
        'SELECT 1 FROM prestamos WHERE id_prestamo = ?',
        variables: [Variable<int>(idPrestamo)],
      ).get();
      if (exists.isEmpty) return;

      await (_db.delete(
        _db.amortizaciones,
      )..where((t) => t.idPrestamo.equals(idPrestamo))).go();
      await (_db.delete(
        _db.configuracionPrestamos,
      )..where((t) => t.idPrestamo.equals(idPrestamo))).go();
      await (_db.delete(
        _db.prestamos,
      )..where((t) => t.id.equals(idPrestamo))).go();
    });
  }

  @override
  Future<void> cancelarPrestamo(int idPrestamo, String motivo, double montoDevuelto) async {
    await _db.transaction(() async {
      final prestamo = await (_db.select(_db.prestamos)
        ..where((t) => t.id.equals(idPrestamo))).getSingleOrNull();
      if (prestamo == null) return;

      await (_db.update(
        _db.configuracionPrestamos,
      )..where((t) => t.idPrestamo.equals(idPrestamo))).write(
        drift.ConfiguracionPrestamosCompanion(
          estadoPrestamo: Value(EstadoPrestamo.cancelado),
          motivoCancelacion: Value(motivo),
          montoDevuelto: Value(montoDevuelto),
          fechaActualizacion: Value(DateTime.now()),
        ),
      );

      await (_db.update(
        _db.amortizaciones,
      )..where((t) => t.idPrestamo.equals(idPrestamo))
        ..where((t) => t.estadoAmortizacion.isIn([
          'pendiente',
          'atrasado',
        ]))
      ).write(
        drift.AmortizacionesCompanion(
          estadoAmortizacion: Value(EstadoAmortizacion.cancelado),
          diasMora: const Value(0),
          montoMora: const Value(0),
          fechaActualizacion: Value(DateTime.now()),
        ),
      );

      await _db.into(_db.scores).insertOnConflictUpdate(
        drift.ScoresCompanion(
          idPrestamo: Value(idPrestamo),
          idDeudor: Value(prestamo.idDeudor),
          score: const Value(50),
        ),
      );
    });
  }

  @override
  Future<void> castigarPrestamo(int idPrestamo, String motivo) async {
    await _db.transaction(() async {
      final amortRows = await (_db.select(_db.amortizaciones)
        ..where((t) => t.idPrestamo.equals(idPrestamo))
        ..where((t) => t.estadoAmortizacion.isIn([
          'pendiente',
          'atrasado',
        ]))
      ).get();

      final montoPerdido = amortRows.fold<double>(
        0,
        (sum, a) => sum + a.montoACapital + a.montoInteres + a.montoMora,
      );

      final prestamo = await (_db.select(_db.prestamos)
        ..where((t) => t.id.equals(idPrestamo))).getSingle();

      await (_db.update(
        _db.configuracionPrestamos,
      )..where((t) => t.idPrestamo.equals(idPrestamo))).write(
        drift.ConfiguracionPrestamosCompanion(
          estadoPrestamo: Value(EstadoPrestamo.incobrable),
          motivoCastigo: Value(motivo),
          montoPerdido: Value(montoPerdido),
          fechaActualizacion: Value(DateTime.now()),
        ),
      );

      await (_db.update(
        _db.amortizaciones,
      )..where((t) => t.idPrestamo.equals(idPrestamo))
        ..where((t) => t.estadoAmortizacion.isIn([
          'pendiente',
          'atrasado',
        ]))
      ).write(
        drift.AmortizacionesCompanion(
          estadoAmortizacion: Value(EstadoAmortizacion.cancelado),
          montoMora: const Value(0),
          fechaActualizacion: Value(DateTime.now()),
        ),
      );

      await _db.into(_db.scores).insertOnConflictUpdate(
        drift.ScoresCompanion(
          idPrestamo: Value(idPrestamo),
          idDeudor: Value(prestamo.idDeudor),
          score: const Value(0),
        ),
      );
    });
  }

  @override
  Future<void> finalizarPrestamo(int idPrestamo) async {
    await (_db.update(
      _db.configuracionPrestamos,
    )..where((t) => t.idPrestamo.equals(idPrestamo))).write(
      drift.ConfiguracionPrestamosCompanion(
        estadoPrestamo: Value(EstadoPrestamo.finalizado),
        fechaActualizacion: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<PrestamoDetalle> getDetalle(int idPrestamo) async {
    await _estadoPrestamoService.actualizarMorosidad(idPrestamo: idPrestamo);
    await _estadoPrestamoService.recalcularEstadoPrestamo(idPrestamo: idPrestamo);

    final results = await Future.wait([
      _db
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
          d.nombre AS nombre_deudor,
          d.numero_identificacion,
          d.telefono,
          COALESCE((SELECT SUM(a.monto_capital) FROM amortizaciones a
           WHERE a.id_prestamo = p.id_prestamo AND a.estado_amortizacion = 'pagado'), 0) AS total_pagado
        FROM prestamos p
        INNER JOIN deudores d ON d.id_deudor = p.id_deudor
        WHERE p.id_prestamo = ?
      ''',
            variables: [Variable<int>(idPrestamo)],
          )
          .getSingle(),
      _db
          .customSelect(
            '''
        SELECT
          id_configuracion,
          id_prestamo,
          tipo_interes,
          estado_moratorio,
          manejo_excedente,
          periodidad_intereses,
          estado_prestamo,
          motivo_cancelacion,
          monto_devuelto,
          motivo_castigo,
          monto_perdido,
          fecha_creacion,
          fecha_actualizacion
        FROM configuracion_prestamos
        WHERE id_prestamo = ?
      ''',
            variables: [Variable<int>(idPrestamo)],
          )
          .getSingle(),
      _db
          .customSelect(
            '''
        SELECT
          id_amortizacion,
          id_prestamo,
          id_cuota,
          fecha_vencimiento,
          fecha_pagado,
          monto_inicial,
          monto_pagado,
          monto_capital,
          monto_interes,
          dias_mora,
          monto_mora,
          monto_excedente,
          estado_amortizacion,
          fecha_actualizacion
        FROM amortizaciones
        WHERE id_prestamo = ?
        ORDER BY id_cuota ASC
      ''',
            variables: [Variable<int>(idPrestamo)],
          )
          .get(),
      _db
          .customSelect(
            '''
        SELECT
          CASE
            WHEN COUNT(*) = 0 THEN 'sin_amortizaciones'
            WHEN SUM(CASE WHEN a.estado_amortizacion = 'pagado' THEN 1 ELSE 0 END) = COUNT(*) THEN 'completado'
            WHEN SUM(CASE WHEN a.estado_amortizacion = 'pagado' THEN 1 ELSE 0 END) > 0 THEN 'en_progreso'
            ELSE 'pendiente'
          END AS estado_pagos
        FROM amortizaciones a
        WHERE a.id_prestamo = ?
      ''',
            variables: [Variable<int>(idPrestamo)],
          )
          .getSingle(),
    ]);

    final prestamoRow = results[0] as QueryRow;
    final configRow = results[1] as QueryRow;
    final amortizacionesRows = results[2] as List<QueryRow>;
    final estadoPagosRow = results[3] as QueryRow;

    final prestamo = Prestamo(
      idPrestamo: prestamoRow.read<int>('id_prestamo'),
      idDeudor: prestamoRow.read<int>('id_deudor'),
      tasaInteres: prestamoRow.read<double>('tasa_interes'),
      tasaInteresMoratoria: prestamoRow.read<double>('tasa_interes_moratoria'),
      monto: prestamoRow.read<double>('monto'),
      plazo: prestamoRow.read<int>('plazo_meses'),
      montoCuota: prestamoRow.read<double>('monto_cuota'),
      fechaCreacion: prestamoRow.read<DateTime>('fecha_creacion'),
    );

    final configuracion = ConfiguracionPrestamo(
      idConfiguracion: configRow.read<int>('id_configuracion'),
      idPrestamo: configRow.read<int>('id_prestamo'),
      tipoInteres: configRow.read<String>('tipo_interes'),
      estadoMoratorio: configRow.read<String>('estado_moratorio'),
      manejoExcedente: configRow.read<String>('manejo_excedente'),
      periodidadIntereses: configRow.read<String>('periodidad_intereses'),
      estadoPrestamo: configRow.read<String>('estado_prestamo'),
      motivoCancelacion: configRow.read<String?>('motivo_cancelacion'),
      montoDevuelto: configRow.read<double>('monto_devuelto'),
      motivoCastigo: configRow.read<String?>('motivo_castigo'),
      montoPerdido: configRow.read<double>('monto_perdido'),
      fechaCreacion: configRow.read<DateTime>('fecha_creacion'),
      fechaActualizacion: configRow.read<DateTime>('fecha_actualizacion'),
    );

    final amortizaciones = amortizacionesRows
        .map(
          (row) => Amortizacion(
            idAmortizacion: row.read<int>('id_amortizacion'),
            idPrestamo: row.read<int>('id_prestamo'),
            idCuota: row.read<int>('id_cuota'),
            fechaVencimiento: row.read<DateTime>('fecha_vencimiento'),
            fechaPagado: row.read<DateTime?>('fecha_pagado'),
            montoInicial: row.read<double>('monto_inicial'),
            montoPagado: row.read<double>('monto_pagado'),
            montoCapital: row.read<double>('monto_capital'),
            montoInteres: row.read<double>('monto_interes'),
            diasMora: row.read<int>('dias_mora'),
            montoMora: row.read<double>('monto_mora'),
            montoExcedente: row.read<double>('monto_excedente'),
            estadoAmortizacion: row.read<String>('estado_amortizacion'),
            fechaActualizacion: row.read<DateTime>('fecha_actualizacion'),
          ),
        )
        .toList();

    return PrestamoDetalle(
      nombreDeudor: prestamoRow.read<String>('nombre_deudor'),
      numeroIdentificacion: prestamoRow.read<String>('numero_identificacion'),
      telefono: prestamoRow.read<String>('telefono'),
      configuracionPrestamo: configuracion,
      amortizaciones: amortizaciones,
      prestamo: prestamo,
      estadoPagos: estadoPagosRow.read<String>('estado_pagos'),
      idPrestamo: idPrestamo,
    );
  }

  String _buildFilterCondition(String? filter) {
    if (filter == null || filter == 'todos') {
      return '1 = 1';
    }
    if (filter == 'al_dia') {
      return '''
        (SELECT cp.estado_prestamo FROM configuracion_prestamos cp
         WHERE cp.id_prestamo = p.id_prestamo) = 'activo'
      ''';
    }
    if (filter == 'atrasados') {
      return '''
        (SELECT cp.estado_prestamo FROM configuracion_prestamos cp
         WHERE cp.id_prestamo = p.id_prestamo) = 'atrasado'
      ''';
    }
    if (filter == 'liquidados') {
      return '''
        (SELECT cp.estado_prestamo FROM configuracion_prestamos cp
         WHERE cp.id_prestamo = p.id_prestamo) IN ('finalizado', 'cancelado')
      ''';
    }
    return '1 = 1';
  }

  @override
  Future<PagedResult<PrestamoResumen>> getPaged({
    required int page,
    required int pageSize,
    String? search,
    String? filter,
  }) async {
    final limit = pageSize + 1;
    final offset = page * pageSize;

    final searchPattern = (search != null && search.isNotEmpty)
        ? '%$search%'
        : '';

    final applySearch = searchPattern.isNotEmpty;
    final filterCondition = _buildFilterCondition(filter);

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
        p.tasa_interes,
        COALESCE((SELECT d.nombre FROM deudores d WHERE d.id_deudor = p.id_deudor), '—') AS nombre,
        (SELECT COALESCE(SUM(a.monto_capital), 0) FROM amortizaciones a
         WHERE a.id_prestamo = p.id_prestamo AND a.estado_amortizacion = 'pagado') AS total_pagado,
        COALESCE((SELECT cp.estado_prestamo FROM configuracion_prestamos cp
         WHERE cp.id_prestamo = p.id_prestamo), 'activo') AS estado_prestamo,
        (SELECT cp.fecha_actualizacion FROM configuracion_prestamos cp
         WHERE cp.id_prestamo = p.id_prestamo) AS fecha_actualizacion,
        COALESCE((SELECT cp.periodidad_intereses FROM configuracion_prestamos cp
         WHERE cp.id_prestamo = p.id_prestamo), 'mensual') AS periodidad_intereses
      FROM prestamos p
      WHERE (? = 0 OR (SELECT d.nombre FROM deudores d WHERE d.id_deudor = p.id_deudor) LIKE ?)
        AND $filterCondition
      ORDER BY p.fecha_creacion DESC
      LIMIT ? OFFSET ?
    ''',
          variables: [
            Variable<int>(applySearch ? 1 : 0),
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
        estadoUltimoPago: row.read<String>('estado_prestamo'),
        estadoPrestamo: row.read<String>('estado_prestamo'),
        fechaCreacion: row.read<DateTime>('fecha_creacion'),
        tasaInteres: row.read<double>('tasa_interes'),
        totalPagado: totalPagado,
        fechaActualizacion: row.read<DateTime?>('fecha_actualizacion'),
        periodidadIntereses: row.read<String>('periodidad_intereses'),
      );
    }).toList();

    return PagedResult(items: items, hasMore: hasMore);
  }
}
