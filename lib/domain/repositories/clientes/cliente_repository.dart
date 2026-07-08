import 'package:prestapagos/domain/domain.dart';

abstract class ClienteRepository {
  Future<List<ClienteResumen>> getAll();
  Future<Cliente> getById(int idDeudor);
  Future<ClienteDetalle> getDetalle(int idDeudor);
  Future<void> crearCliente(Cliente cliente);
  Future<void> actualizarCliente(Cliente cliente);
  Future<void> eliminarCliente(int idDeudor);
}
