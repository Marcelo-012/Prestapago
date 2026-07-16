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

  Amortizacion copyWith({
    int? idAmortizacion,
    int? idPrestamo,
    int? idCuota,
    DateTime? fechaVencimiento,
    DateTime? fechaPagado,
    double? montoInicial,
    double? montoPagado,
    double? montoCapital,
    double? montoInteres,
    int? diasMora,
    double? montoMora,
    double? montoExcedente,
    String? estadoAmortizacion,
    DateTime? fechaActualizacion,
  }) {
    return Amortizacion(
      idAmortizacion: idAmortizacion ?? this.idAmortizacion,
      idPrestamo: idPrestamo ?? this.idPrestamo,
      idCuota: idCuota ?? this.idCuota,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      fechaPagado: fechaPagado ?? this.fechaPagado,
      montoInicial: montoInicial ?? this.montoInicial,
      montoPagado: montoPagado ?? this.montoPagado,
      montoCapital: montoCapital ?? this.montoCapital,
      montoInteres: montoInteres ?? this.montoInteres,
      diasMora: diasMora ?? this.diasMora,
      montoMora: montoMora ?? this.montoMora,
      montoExcedente: montoExcedente ?? this.montoExcedente,
      estadoAmortizacion: estadoAmortizacion ?? this.estadoAmortizacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }
}
