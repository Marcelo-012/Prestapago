class CreateAmortizacionDTO {
  final int idCuota;
  final DateTime fechaVencimiento;
  final double montoInicial;
  final double montoCapital;
  final double montoInteres;
  final double montoMora;
  final String estadoAmortizacion;

  CreateAmortizacionDTO({
    required this.idCuota,
    required this.fechaVencimiento,
    required this.montoInicial,
    required this.montoCapital,
    required this.montoInteres,
    required this.montoMora,
    this.estadoAmortizacion = 'noPagado',
  });
}
