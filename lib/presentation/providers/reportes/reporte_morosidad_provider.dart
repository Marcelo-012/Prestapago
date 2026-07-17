import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/repositories/repositories.dart';
import 'package:prestapagos/presentation/providers/providers.dart';

final reporteMorosidadRepositoryProvider =
    Provider<ReporteMorosidadRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ReporteMorosidadRepositoryImpl(db: db);
});

class ReporteMorosidadProvider extends AsyncNotifier<ReporteMorosidad> {
  @override
  FutureOr<ReporteMorosidad> build() {
    final repository = ref.read(reporteMorosidadRepositoryProvider);
    return repository.getReporteMorosidad();
  }
}

final reporteMorosidadProvider =
    AsyncNotifierProvider<ReporteMorosidadProvider, ReporteMorosidad>(
  () => ReporteMorosidadProvider(),
);
