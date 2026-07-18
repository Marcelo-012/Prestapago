import 'package:drift/drift.dart';
import 'package:prestapagos/shared/shared.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/database/database.dart' as drift;
import 'package:prestapagos/infrastructure/services/services.dart';

class PagoRepositoryImpl implements PagoRepository {
  final drift.AppDatabase _db;
  final PrestamoRepository _prestamoRepository;
  final EstadoPrestamoService _estadoPrestamoService;

  PagoRepositoryImpl({
    required this._db,
    required this._prestamoRepository,
    required this._estadoPrestamoService,
  });

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
  Future<void> registrarPago(
    int idPrestamo,
    double montoPagado,
    DateTime fechaPago, {
    required ManejoExcedente tipoExcedente,
  }) async {
    await _db.transaction(() async {
      final completo = await _prestamoRepository.getDetalle(idPrestamo);
      final config = completo.configuracionPrestamo;
      final prestamo = completo.prestamo;

      final deudor = await (_db.select(_db.deudores)
        ..where((t) => t.id.equals(prestamo.idDeudor))).getSingleOrNull();
      if (deudor != null && deudor.estado == EstadoCliente.inactivo) {
        throw Exception('No se puede registrar un pago para un cliente inactivo');
      }

      final prox = completo.amortizaciones.firstWhere(
        (a) =>
            a.estadoAmortizacion == 'atrasado' ||
            a.estadoAmortizacion == 'pendiente',
      );

      final saldoPreCargado = prox.montoExcedente;
      final diasMora = prox.diasMora;
      final montoMora = AmortizationCalculator.calcularMontoMora(
        montoInicial: prox.montoCapital + prox.montoInteres,
        tasaMoratoria: prestamo.tasaInteresMoratoria,
        periodicidad: config.periodidadIntereses,
        diasMora: diasMora,
      );

      final totalDebido = prox.montoCapital + prox.montoInteres + montoMora;
      double excedente = montoPagado + saldoPreCargado - totalDebido;

      double abonoACapital = 0;
      if (tipoExcedente == ManejoExcedente.abonoCapital && excedente > 0.01) {
        abonoACapital = excedente;
        excedente = 0;
      }

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
                    (a.estadoAmortizacion == 'pendiente' ||
                        a.estadoAmortizacion == 'atrasado'),
              )
              .toList()
            ..sort((a, b) => a.idCuota.compareTo(b.idCuota));

      if (tipoExcedente == ManejoExcedente.saldoFavor && excedente > 0.01) {
        final pendientesActualizados =
            await (_db.select(_db.amortizaciones)
                  ..where((t) => t.idPrestamo.equals(idPrestamo))
                  ..where(
                    (t) => t.estadoAmortizacion.isIn([
                      EstadoAmortizacion.pendiente.name,
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
                  montoInicial: sig.montoACapital + sig.montoInteres,
                  tasaMoratoria: prestamo.tasaInteresMoratoria,
                  periodicidad: config.periodidadIntereses,
                  diasMora: sig.diasMora,
                )
              : 0.0;
          final sigTotal = sig.montoACapital + sig.montoInteres + sigMora;

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

      await _estadoPrestamoService.recalcularEstadoPrestamo();

      final configActual = await (_db.select(_db.configuracionPrestamos)
        ..where((t) => t.idPrestamo.equals(idPrestamo))).getSingle();
      if (configActual.estadoPrestamo == EstadoPrestamo.finalizado) {
        await _calcularYGuardarScore(idPrestamo);
      }
    });
  }

  Future<void> _calcularYGuardarScore(int idPrestamo) async {
    final prestamo = await (_db.select(_db.prestamos)
      ..where((t) => t.id.equals(idPrestamo))).getSingle();

    final cuotas = await (_db.select(_db.amortizaciones)
      ..where((t) => t.idPrestamo.equals(idPrestamo))).get();

    final total = cuotas.length;
    final sinMora = cuotas.where((a) => a.diasMora == 0).length;
    final score = total > 0 ? (sinMora / total * 100).round() : 0;

    await _db.into(_db.scores).insertOnConflictUpdate(
      drift.ScoresCompanion(
        idPrestamo: Value(idPrestamo),
        idDeudor: Value(prestamo.idDeudor),
        score: Value(score.toDouble()),
      ),
    );
  }
}
