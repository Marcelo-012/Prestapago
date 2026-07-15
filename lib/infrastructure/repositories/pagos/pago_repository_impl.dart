import 'package:drift/drift.dart';
import 'package:prestapagos/config/helpers/amortization_calculator.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/domain/repositories/pagos/pago_repository.dart';
import 'package:prestapagos/domain/repositories/prestamos/prestamos_repository.dart';
import 'package:prestapagos/infrastructure/database/database.dart' as drift;
import 'package:prestapagos/infrastructure/services/estado_prestamo_service.dart';

class PagoRepositoryImpl implements PagoRepository {
  final drift.AppDatabase _db;
  final PrestamoRepository _prestamoRepository;
  final EstadoPrestamoService _estadoPrestamoService;

  PagoRepositoryImpl({
    required drift.AppDatabase db,
    required PrestamoRepository prestamoRepository,
    required EstadoPrestamoService estadoPrestamoService,
  })  : _db = db,
        _prestamoRepository = prestamoRepository,
        _estadoPrestamoService = estadoPrestamoService;

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
    });
  }
}
