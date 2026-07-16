import 'package:prestapagos/domain/domain.dart';

abstract class ReporteEstadoPrestamosRepository {
  Future<ReporteEstadoPrestamos> getReporteEstadoPrestamos();
}
