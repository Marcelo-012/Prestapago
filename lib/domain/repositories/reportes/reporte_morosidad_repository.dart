import 'package:prestapagos/domain/domain.dart';

abstract class ReporteMorosidadRepository {
  Future<ReporteMorosidad> getReporteMorosidad();
}
