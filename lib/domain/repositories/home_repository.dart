import '../entities/dtos/clientes/cliente_resumen.dart';
import '../entities/dtos/home/proximo_vencimiento.dart';
import '../entities/dtos/home/ultimo_pago.dart';

abstract class HomeRepository {
  Future<List<UltimoPago>> getUltimosPagos();
  Future<List<ProximoVencimiento>> getProximosVencimientos();
  Future<List<ClienteResumen>> getMejoresClientes();
}
