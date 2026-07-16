class ProximoVencimiento {
  final int idPrestamo;
  final int idDeudor;
  final String nombreCliente;
  final double montoCapital;
  final double montoInteres;
  final DateTime fechaVencimiento;
  final int diasMora;
  final String estado;

  ProximoVencimiento({
    required this.idPrestamo,
    required this.idDeudor,
    required this.nombreCliente,
    required this.montoCapital,
    required this.montoInteres,
    required this.fechaVencimiento,
    required this.diasMora,
    required this.estado,
  });

  double get totalCuota => montoCapital + montoInteres;
}
