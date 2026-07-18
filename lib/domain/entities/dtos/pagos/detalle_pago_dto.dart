import 'package:prestapagos/domain/domain.dart';

class DetallePagoDto {
  final double montoCuota;
  final double totalCuotaConMora;
  final double? abonoCapital;
  final double totalAdeudado;
  final double saldoUsado;

  const DetallePagoDto({
    required this.montoCuota,
    required this.totalCuotaConMora,
    this.abonoCapital,
    required this.totalAdeudado,
    required this.saldoUsado,
  });

  factory DetallePagoDto.calcular({
    required ConfiguracionPrestamo config,
    required Amortizacion amortizacion,
    required List<Amortizacion> amortizaciones,
  }) {
    final montoCuota = amortizacion.montoCapital + amortizacion.montoInteres;
    final totalCuotaConMora = montoCuota + amortizacion.montoMora;

    double? abonoCapital;
    if (config.manejoExcedente == 'abonoCapital') {
      final excess = amortizacion.montoPagado - totalCuotaConMora;
      if (excess > 0.01) abonoCapital = excess;
    }

    final totalAdeudado = amortizaciones
        .where((a) =>
            a.estadoAmortizacion == 'pendiente' ||
            a.estadoAmortizacion == 'atrasado')
        .fold<double>(0, (sum, a) => sum + a.montoCapital + a.montoInteres);

    final saldoUsado = totalCuotaConMora - amortizacion.montoPagado;

    return DetallePagoDto(
      montoCuota: montoCuota,
      totalCuotaConMora: totalCuotaConMora,
      abonoCapital: abonoCapital,
      totalAdeudado: totalAdeudado,
      saldoUsado: saldoUsado,
    );
  }
}
