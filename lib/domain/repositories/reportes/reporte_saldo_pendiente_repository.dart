import 'package:prestapagos/domain/domain.dart';

abstract class ReporteSaldoPendienteRepository {
  Future<ReporteSaldoPendiente> getReporteSaldoPendiente();
}
