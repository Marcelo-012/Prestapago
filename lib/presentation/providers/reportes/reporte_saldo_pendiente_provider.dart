import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/domain/repositories/reportes/reporte_saldo_pendiente_repository.dart';
import 'package:prestapagos/infrastructure/repositories/reporte/reporte_saldo_pendiente_repository_impl.dart';
import 'package:prestapagos/presentation/providers/database/app_database_provider.dart';

final reporteSaldoPendienteRepositoryProvider =
    Provider<ReporteSaldoPendienteRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ReporteSaldoPendienteRepositoryImpl(db: db);
});

class ReporteSaldoPendienteProvider
    extends AsyncNotifier<ReporteSaldoPendiente> {
  @override
  FutureOr<ReporteSaldoPendiente> build() {
    final repository = ref.read(reporteSaldoPendienteRepositoryProvider);
    return repository.getReporteSaldoPendiente();
  }
}

final reporteSaldoPendienteProvider =
    AsyncNotifierProvider<ReporteSaldoPendienteProvider, ReporteSaldoPendiente>(
  () => ReporteSaldoPendienteProvider(),
);
