import 'package:prestapagos/domain/domain.dart';

abstract class ClienteRepository {
  Future<PagedResult<ClienteResumen>> getPaged({
    required int page,
    required int pageSize,
    String? search,
  });
  Future<Cliente> getById(int idDeudor);
  Future<ClienteDetalle> getDetalle(int idDeudor);
  Future<void> createCliente(Cliente cliente);
  Future<void> updateCliente(Cliente cliente);
  Future<void> deleteCliente(int idDeudor);
  Future<int> countRelatedRecords(int idDeudor);
  Future<void> deactivateCliente(int idDeudor);
  Future<void> reactivateCliente(int idDeudor);
}
