class Amortizacion {
  final int idAmortizacion;
  final int idPrestamo;
  final int idCuota;
  final DateTime fechaVencimiento;
  final DateTime? fechaPagado;
  final double montoInicial;
  final double montoPagado;
  final double montoCapital;
  final double montoInteres;
  final int diasMora;
  final double montoMora;
  final double montoExcedente;
  final String estadoAmortizacion;
  final DateTime fechaActualizacion;

  Amortizacion({
    required this.idAmortizacion,
    required this.idPrestamo,
    required this.idCuota,
    required this.fechaVencimiento,
    this.fechaPagado,
    required this.montoInicial,
    required this.montoPagado,
    required this.montoCapital,
    required this.montoInteres,
    required this.diasMora,
    required this.montoMora,
    required this.montoExcedente,
    required this.estadoAmortizacion,
    required this.fechaActualizacion,
  });
}
