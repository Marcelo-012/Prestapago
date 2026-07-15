import 'package:drift/drift.dart';
import 'package:prestapagos/config/helpers/amortization_calculator.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/domain/repositories/prestamos/prestamos_repository.dart';
import 'package:prestapagos/infrastructure/database/database.dart' as drift;

class PrestamoRepositoryImpl implements PrestamoRepository {
  final drift.AppDatabase _db;

  PrestamoRepositoryImpl({required this._db});

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
              estadoMoratorio: EstadoCliente.values.byName(dto.estadoMoratorio),
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
                estadoAmortizacion: EstadoAmortizacion.noPagado,
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
    await (_db.delete(
      _db.amortizaciones,
    )..where((t) => t.idPrestamo.equals(idPrestamo))).go();
    await (_db.delete(
      _db.configuracionPrestamos,
    )..where((t) => t.idPrestamo.equals(idPrestamo))).go();
    await (_db.delete(
      _db.prestamos,
    )..where((t) => t.id.equals(idPrestamo))).go();
  }

  @override
  Future<int> countAmortizaciones(int idPrestamo) async {
    final row = await _db
        .customSelect(
          '''
      SELECT COUNT(*) AS total FROM amortizaciones WHERE id_prestamo = ?
    ''',
          variables: [Variable<int>(idPrestamo)],
        )
        .getSingle();
    return row.read<int>('total');
  }

  @override
  Future<void> cancelarPrestamo(int idPrestamo) async {
    await (_db.update(
      _db.configuracionPrestamos,
    )..where((t) => t.idPrestamo.equals(idPrestamo))).write(
      drift.ConfiguracionPrestamosCompanion(
        estadoPrestamo: Value(EstadoPrestamo.cancelado),
        fechaActualizacion: Value(DateTime.now()),
      ),
    );

    await (_db.update(
      _db.amortizaciones,
    )..where((t) => t.idPrestamo.equals(idPrestamo))).write(
      drift.AmortizacionesCompanion(
        estadoAmortizacion: Value(EstadoAmortizacion.cancelado),
        fechaActualizacion: Value(DateTime.now()),
      ),
    );
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

  Future<void> _actualizarMorosidad() async {
    // FIX: ahora también corre sobre filas ya marcadas 'atrasado',
    // para que dias_mora siga subiendo día con día en vez de congelarse.
    await _db.customStatement("""
    UPDATE amortizaciones SET
      estado_amortizacion = 'atrasado',
      dias_mora = CAST(julianday('now') - julianday(fecha_vencimiento, 'unixepoch') AS INTEGER)
    WHERE estado_amortizacion IN ('noPagado', 'atrasado')
      AND date(fecha_vencimiento, 'unixepoch') < date('now')
  """);

    // FIX: se quitó "AND monto_mora = 0" -- ese guard congelaba
    // monto_mora en el valor del primer cálculo para siempre.
    await _db.customStatement("""
    UPDATE amortizaciones SET monto_mora = ROUND(
      monto_inicial * (SELECT tasa_interes_moratoria FROM prestamos
       WHERE id_prestamo = amortizaciones.id_prestamo) / 100.0 /
      CASE WHEN (SELECT periodidad_intereses FROM configuracion_prestamos
       WHERE id_prestamo = amortizaciones.id_prestamo) = 'mensual' THEN 30 ELSE 360 END
      * dias_mora, 2)
    WHERE estado_amortizacion = 'atrasado'
      AND (SELECT tipo_interes FROM configuracion_prestamos
       WHERE id_prestamo = amortizaciones.id_prestamo) = 'compuesto'
  """);

    await _db.customStatement("""
    UPDATE configuracion_prestamos SET estado_prestamo = 'atrasado'
    WHERE id_prestamo IN (
      SELECT DISTINCT id_prestamo FROM amortizaciones
      WHERE estado_amortizacion = 'atrasado'
    )
    AND estado_prestamo NOT IN ('finalizado', 'cancelado')
  """);
  }

  @override
  Future<void> registrarPago(
    int idPrestamo,
    double montoPagado,
    DateTime fechaPago, {
    required ManejoExcedente tipoExcedente,
  }) async {
    await _db.transaction(() async {
      final completo = await getDetalle(idPrestamo);
      final config = completo.configuracionPrestamo;
      final prestamo = completo.prestamo;
      final esSimple = config.tipoInteres == 'simple';

      final prox = completo.amortizaciones.firstWhere(
        (a) =>
            a.estadoAmortizacion == 'atrasado' ||
            a.estadoAmortizacion == 'noPagado',
      );

      final saldoPreCargado = prox.montoExcedente;
      final diasMora = prox.diasMora;
      final montoMora = AmortizationCalculator.calcularMontoMora(
        montoInicial: prox.montoInicial,
        tasaMoratoria: prestamo.tasaInteresMoratoria,
        periodicidad: config.periodidadIntereses,
        diasMora: diasMora,
      );

      final totalDebido = prox.montoInicial + (esSimple ? montoMora : 0);
      double excedente = montoPagado + saldoPreCargado - totalDebido;

      double abonoACapital = 0;
      if (tipoExcedente == ManejoExcedente.abonoCapital && excedente > 0.01) {
        abonoACapital = excedente;
        excedente = 0;
      }

      // 1. Marcar cuota actual pagada
      await (_db.update(
        _db.amortizaciones,
      )..where((t) => t.id.equals(prox.idAmortizacion))).write(
        drift.AmortizacionesCompanion(
          estadoAmortizacion: const Value(EstadoAmortizacion.pagado),
          fechaPagado: Value(fechaPago),
          montoPagado: Value(montoPagado),
          diasMora: Value(diasMora),
          montoMora: Value(montoMora),
          montoExcedente: Value(excedente > 0.01 ? excedente : 0),
        ),
      );

      final pendientes =
          completo.amortizaciones
              .where(
                (a) =>
                    a.idAmortizacion != prox.idAmortizacion &&
                    (a.estadoAmortizacion == 'noPagado' ||
                        a.estadoAmortizacion == 'atrasado'),
              )
              .toList()
            ..sort((a, b) => a.idCuota.compareTo(b.idCuota));

      // 2. Mora compuesta (solo cuota original, no tocar)
      if (diasMora > 0 &&
          config.tipoInteres == 'compuesto' &&
          pendientes.isNotEmpty) {
        final recalculadas = AmortizationCalculator.recalcularPorMora(
          pendientes: pendientes,
          montoMora: montoMora,
          tasaInteres: prestamo.tasaInteres,
          periodicidadIntereses: config.periodidadIntereses,
          cuotaMensual: prestamo.montoCuota,
        );
        for (final r in recalculadas) {
          await (_db.update(
            _db.amortizaciones,
          )..where((t) => t.id.equals(r.idAmortizacion))).write(
            drift.AmortizacionesCompanion(
              montoInicial: Value(r.montoInicial),
              montoACapital: Value(r.montoCapital),
              montoInteres: Value(r.montoInteres),
            ),
          );
        }
      }

      // 3. Auto-pagar siguientes cuotas (solo saldoFavor)
      if (tipoExcedente == ManejoExcedente.saldoFavor && excedente > 0.01) {
        final pendientesActualizados =
            await (_db.select(_db.amortizaciones)
                  ..where((t) => t.idPrestamo.equals(idPrestamo))
                  ..where(
                    (t) => t.estadoAmortizacion.isIn([
                      EstadoAmortizacion.noPagado.name,
                      EstadoAmortizacion.atrasado.name,
                    ]),
                  )
                  ..where((t) => t.id.equals(prox.idAmortizacion).not())
                  ..orderBy([
                    (t) => OrderingTerm(expression: t.idCuota),
                  ]))
                .get();

        for (final sig in pendientesActualizados) {
          if (excedente <= 0.01) break;

          final sigMora = sig.diasMora > 0
              ? AmortizationCalculator.calcularMontoMora(
                  montoInicial: sig.montoInicial,
                  tasaMoratoria: prestamo.tasaInteresMoratoria,
                  periodicidad: config.periodidadIntereses,
                  diasMora: sig.diasMora,
                )
              : 0.0;
          final sigTotal = sig.montoInicial + (esSimple ? sigMora : 0);

          if (excedente < sigTotal) {
            await (_db.update(
              _db.amortizaciones,
            )..where((t) => t.id.equals(sig.id))).write(
              drift.AmortizacionesCompanion(
                montoExcedente: Value(excedente),
              ),
            );
            break;
          }

          excedente -= sigTotal;
          await (_db.update(
            _db.amortizaciones,
          )..where((t) => t.id.equals(sig.id))).write(
            drift.AmortizacionesCompanion(
              estadoAmortizacion: const Value(EstadoAmortizacion.pagado),
              fechaPagado: Value(fechaPago),
              montoPagado: const Value(0),
              montoExcedente: Value(excedente > 0.01 ? excedente : 0),
              montoMora: Value(sigMora),
            ),
          );
        }
      }

      // 4. Abono a capital
      if (abonoACapital > 0 && pendientes.isNotEmpty) {
        final result = AmortizationCalculator.recalcularPorAbonoCapital(
          pendientes: pendientes,
          abono: abonoACapital,
          tasaInteres: prestamo.tasaInteres,
          periodicidadIntereses: config.periodidadIntereses,
          cuotaMensual: prestamo.montoCuota,
        );
        for (final r in result.actualizadas) {
          await (_db.update(
            _db.amortizaciones,
          )..where((t) => t.id.equals(r.idAmortizacion))).write(
            drift.AmortizacionesCompanion(
              montoInicial: Value(r.montoInicial),
              montoACapital: Value(r.montoCapital),
              montoInteres: Value(r.montoInteres),
            ),
          );
        }
        for (final idCancel in result.idsCanceladas) {
          await (_db.update(
            _db.amortizaciones,
          )..where((t) => t.id.equals(idCancel))).write(
            const drift.AmortizacionesCompanion(
              estadoAmortizacion: Value(EstadoAmortizacion.cancelado),
            ),
          );
        }
      }

      await _recalcularEstadoPrestamo();
    });
  }

  @override
  Future<PrestamoDetalle> getDetalle(int idPrestamo) async {
    await _actualizarMorosidad();
    await _recalcularEstadoPrestamo();

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
      configuracionPrestamo: configuracion,
      amortizaciones: amortizaciones,
      prestamo: prestamo,
      estadoPagos: estadoPagosRow.read<String>('estado_pagos'),
      idPrestamo: idPrestamo,
    );
  }

  Future<void> _recalcularEstadoPrestamo() async {
    await _db.customStatement("""
      UPDATE configuracion_prestamos SET
        estado_prestamo = 'finalizado',
        fecha_actualizacion = CAST(strftime('%s', 'now') AS INTEGER)
      WHERE estado_prestamo NOT IN ('finalizado', 'cancelado')
        AND (
          SELECT COUNT(*) FROM amortizaciones a
          WHERE a.id_prestamo = configuracion_prestamos.id_prestamo
            AND a.estado_amortizacion NOT IN ('pagado', 'cancelado')
        ) = 0
       AND (
  SELECT COALESCE(SUM(a.monto_pagado), 0) FROM amortizaciones a
  WHERE a.id_prestamo = configuracion_prestamos.id_prestamo
    AND a.estado_amortizacion = 'pagado'
) >= (SELECT COALESCE(p.monto, 0) FROM prestamos p WHERE p.id_prestamo = configuracion_prestamos.id_prestamo)
    """);

    await _db.customStatement("""
      UPDATE configuracion_prestamos SET
        estado_prestamo = 'atrasado',
        fecha_actualizacion = CAST(strftime('%s', 'now') AS INTEGER)
      WHERE estado_prestamo = 'activo'
        AND EXISTS (
          SELECT 1 FROM amortizaciones a
          WHERE a.id_prestamo = configuracion_prestamos.id_prestamo
            AND a.estado_amortizacion = 'atrasado'
        )
    """);

    await _db.customStatement("""
      UPDATE configuracion_prestamos SET
        estado_prestamo = 'activo',
        fecha_actualizacion = CAST(strftime('%s', 'now') AS INTEGER)
      WHERE estado_prestamo = 'atrasado'
        AND NOT EXISTS (
          SELECT 1 FROM amortizaciones a
          WHERE a.id_prestamo = configuracion_prestamos.id_prestamo
            AND a.estado_amortizacion = 'atrasado'
        )
    """);
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
    await _actualizarMorosidad();
    await _recalcularEstadoPrestamo();

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
