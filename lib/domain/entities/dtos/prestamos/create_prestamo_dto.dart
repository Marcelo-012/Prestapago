import 'create_amortizacion_dto.dart';

class CreatePrestamoDTO {
  final int idDeudor;
  final double tasaInteres;
  final double tasaInteresMoratoria;
  final double monto;
  final int plazo;
  final double montoCuota;
  final String tipoInteres;
  final String estadoMoratorio;
  final String manejoExcedente;
  final String periodidadIntereses;
  final String estadoPrestamo;
  final List<CreateAmortizacionDTO> amortizaciones;

  CreatePrestamoDTO({
    required this.idDeudor,
    required this.tasaInteres,
    required this.tasaInteresMoratoria,
    required this.monto,
    required this.plazo,
    required this.montoCuota,
    this.tipoInteres = 'compuesto',
    this.estadoMoratorio = 'activo',
    this.manejoExcedente = 'abono_capital',
    this.periodidadIntereses = 'mensual',
    this.estadoPrestamo = 'activo',
    this.amortizaciones = const [],
  });
}
