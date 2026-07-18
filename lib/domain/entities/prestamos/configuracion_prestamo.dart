class ConfiguracionPrestamo {
  final int idConfiguracion;
  final int idPrestamo;
  final String tipoInteres;
  final String estadoMoratorio;
  final String manejoExcedente;
  final String periodidadIntereses;
  final String estadoPrestamo;
  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;
  final String? motivoCancelacion;
  final double montoDevuelto;
  final String? motivoCastigo;
  final double montoPerdido;

  ConfiguracionPrestamo({
    required this.idConfiguracion,
    required this.idPrestamo,
    required this.tipoInteres,
    required this.estadoMoratorio,
    required this.manejoExcedente,
    required this.periodidadIntereses,
    required this.estadoPrestamo,
    required this.fechaCreacion,
    required this.fechaActualizacion,
    this.motivoCancelacion,
    this.montoDevuelto = 0,
    this.motivoCastigo,
    this.montoPerdido = 0,
  });
}
