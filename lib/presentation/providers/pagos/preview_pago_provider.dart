import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/shared/domain/services/amortization_calculator.dart';
import 'package:prestapagos/domain/domain.dart';

final previewPagoProvider = Provider.family<
    ({
      double montoCuota,
      double montoMora,
      int diasMora,
      double saldoAFavor,
      double totalMinimo,
      double montoMaximo,
    }),
    PrestamoDetalle>(
  (ref, detalle) {
    Amortizacion? prox;
    for (final a in detalle.amortizaciones) {
      if (a.estadoAmortizacion == 'noPagado' || a.estadoAmortizacion == 'atrasado') {
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
);
