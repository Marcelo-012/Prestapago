import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/shared/shared.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/providers.dart';

final previewPagoProvider = Provider.family<
    ({
      double montoCuota,
      double montoMora,
      int diasMora,
      double saldoAFavor,
      double totalMinimo,
      double montoMaximo,
    }),
    int>(
  (ref, idPrestamo) {
    final detalleAsync = ref.watch(prestamoDetalleProvider(idPrestamo));
    return detalleAsync.when(
      data: (detalle) {
        Amortizacion? prox;
        for (final a in detalle.amortizaciones) {
          if (a.estadoAmortizacion == 'pendiente' || a.estadoAmortizacion == 'atrasado') {
            prox = a;
            break;
          }
        }
        if (prox == null) {
          return (
            montoCuota: 0,
            montoMora: 0,
            diasMora: 0,
            saldoAFavor: 0,
            totalMinimo: 0,
            montoMaximo: 0,
          );
        }
        return AmortizationCalculator.calcularPreviewPago(
          prox: prox,
          prestamo: detalle.prestamo,
          config: detalle.configuracionPrestamo,
          amortizaciones: detalle.amortizaciones,
        );
      },
      loading: () => (
        montoCuota: 0,
        montoMora: 0,
        diasMora: 0,
        saldoAFavor: 0,
        totalMinimo: 0,
        montoMaximo: 0,
      ),
      error: (_, _) => (
        montoCuota: 0,
        montoMora: 0,
        diasMora: 0,
        saldoAFavor: 0,
        totalMinimo: 0,
        montoMaximo: 0,
      ),
    );
  },
);
