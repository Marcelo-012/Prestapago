import 'package:prestapagos/domain/domain.dart';

abstract class PrestamoRepository {
  Future<PagedResult<PrestamoResumen>> getPaged({
    required int page,
    required int pageSize,
    String? search,
    String? filter,
  });
  Future<Prestamo> getById(int idPrestamo);
  Future<PrestamoDetalle> getDetalle(int idPrestamo);
  Future<int> createPrestamo(CreatePrestamoDTO prestamo);
  Future<void> updatePrestamo(Prestamo prestamo);
  Future<void> deletePrestamo(int idPrestamo);
  Future<int> countAmortizaciones(int idPrestamo);
  Future<void> cancelarPrestamo(int idPrestamo);
  Future<void> finalizarPrestamo(int idPrestamo);
  Future<void> registrarPago(int idPrestamo, double montoPagado, DateTime fechaPago);
}
