import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/repositories/repositories.dart';
import 'package:prestapagos/presentation/providers/providers.dart';

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
