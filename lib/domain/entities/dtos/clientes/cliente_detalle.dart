import 'package:prestapagos/domain/domain.dart';

class ClienteDetalle {
  final Cliente cliente;
  final double scorePromedio;
  final List<Prestamo> prestamos;
  final int totalPrestamos;
  final int totalPrestamosActivos;
  final int totalPrestamosFinalizados;
  final double totalPrestado;
  final double totalDeudaPagada;

  ClienteDetalle({
    required this.cliente,
    required this.scorePromedio,
    required this.prestamos,
    required this.totalPrestamos,
    required this.totalPrestamosActivos,
    required this.totalPrestamosFinalizados,
    required this.totalPrestado,
    required this.totalDeudaPagada,
  });
}
