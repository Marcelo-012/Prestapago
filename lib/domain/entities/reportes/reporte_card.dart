class ReporteCard {
  final double? totalPrestado;
  final double? totalPagado;
  final double? totalPendiente;

  final double? totalInteresesCobrados;
  final double? totalInteresesMoraCobrados;

  final double? totalPrestadoEsteMes;
  final double? totalCobradoEsteMes;
  final double? totalGanadoEsteMes;

  final int? totalPrestamos;
  final int? totalPrestamosActivos;
  final int? totalClientes;

  ReporteCard({
    required this.totalPrestado,
    required this.totalPagado,
    required this.totalPendiente,
    required this.totalInteresesCobrados,
    required this.totalInteresesMoraCobrados,
    required this.totalPrestadoEsteMes,
    required this.totalCobradoEsteMes,
    required this.totalGanadoEsteMes,
    required this.totalPrestamos,
    required this.totalPrestamosActivos,
    required this.totalClientes,
  });
}
