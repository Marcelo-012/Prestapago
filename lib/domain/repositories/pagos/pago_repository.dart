import 'package:prestapagos/domain/domain.dart';

abstract class PagoRepository {
  Future<void> registrarPago(
    int idPrestamo,
    double monto,
    DateTime fecha, {
    required ManejoExcedente tipoExcedente,
  });

  Future<int> countAmortizaciones(int idPrestamo);
}
