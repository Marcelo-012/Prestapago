class UltimoPago {
  final int idAmortizacion;
  final int idPrestamo;
  final int idDeudor;
  final String nombreCliente;
  final double montoPagado;
  final DateTime fechaPagado;
  final double montoCapital;
  final double montoInteres;
  final double montoMora;

  UltimoPago({
    required this.idAmortizacion,
    required this.idPrestamo,
    required this.idDeudor,
    required this.nombreCliente,
    required this.montoPagado,
    required this.fechaPagado,
    required this.montoCapital,
    required this.montoInteres,
    required this.montoMora,
  });
}
