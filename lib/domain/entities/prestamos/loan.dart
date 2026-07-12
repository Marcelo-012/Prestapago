class Loan {
  final int idPrestamo;
  final int idDeudor;
  final double tasaInteres;
  final double tasaInteresMoratoria;
  final double monto;
  final int plazo;
  final double montoCuota;
  final DateTime fechaCreacion;
  final String estado;
  final double totalPagado;
  final DateTime? fechaActualizacion;

  Loan({
    required this.idPrestamo,
    required this.idDeudor,
    required this.tasaInteres,
    required this.tasaInteresMoratoria,
    required this.monto,
    required this.plazo,
    required this.montoCuota,
    required this.fechaCreacion,
    required this.estado,
    required this.totalPagado,
    this.fechaActualizacion,
  });
}