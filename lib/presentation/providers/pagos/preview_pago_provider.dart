import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/config/helpers/amortization_calculator.dart';
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
    final prox = detalle.amortizaciones.firstWhere(
      (a) => a.estadoAmortizacion == 'noPagado' || a.estadoAmortizacion == 'atrasado',
    );
    return AmortizationCalculator.calcularPreviewPago(
      prox: prox,
      prestamo: detalle.prestamo,
      config: detalle.configuracionPrestamo,
      amortizaciones: detalle.amortizaciones,
    );
  },
);
