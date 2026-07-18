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
  Future<void> cancelarPrestamo(int idPrestamo, String motivo, double montoDevuelto);
  Future<void> castigarPrestamo(int idPrestamo, String motivo);
  Future<void> finalizarPrestamo(int idPrestamo);
}
