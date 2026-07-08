import 'package:prestapagos/domain/entities/clientes/cliente.dart';
import 'package:prestapagos/infrastructure/database/database.dart';

class ClienteDetalle {
  final Cliente cliente;
  final List<Score> scores;
  final List<Prestamo> prestamos;
  final double scorePromedio;

  ClienteDetalle({
    required this.cliente,
    required this.scores,
    required this.prestamos,
    required this.scorePromedio,
  });
}
