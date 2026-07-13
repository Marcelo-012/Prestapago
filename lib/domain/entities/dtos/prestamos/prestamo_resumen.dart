class PrestamoResumen {
  final int idPrestamo;
  final int idDeudor;
  final String nombre;
  final double monto;
  final int plazo;
  final double cuota;
  final double saldoPorPagar;
  final String estadoUltimoPago;
  final String estadoPrestamo;
  final DateTime fechaCreacion;

  PrestamoResumen({
    required this.idDeudor,
    required this.monto,
    required this.plazo,
    required this.cuota,
    required this.saldoPorPagar,
    required this.nombre,
    required this.idPrestamo,
    required this.estadoUltimoPago,
    required this.estadoPrestamo,
    required this.fechaCreacion,
  });
}
