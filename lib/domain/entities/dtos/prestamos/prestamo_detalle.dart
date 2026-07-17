import 'package:prestapagos/domain/domain.dart';

class PrestamoDetalle {
  final int idPrestamo;
  final String nombreDeudor;
  final String numeroIdentificacion;
  final String telefono;
  final Prestamo prestamo;
  final ConfiguracionPrestamo configuracionPrestamo;
  final String estadoPagos;
  final List<Amortizacion> amortizaciones;

  PrestamoDetalle({
    required this.nombreDeudor,
    required this.numeroIdentificacion,
    required this.telefono,
    required this.configuracionPrestamo,
    required this.amortizaciones,
    required this.prestamo,
    required this.estadoPagos,
    required this.idPrestamo,
  });
}
