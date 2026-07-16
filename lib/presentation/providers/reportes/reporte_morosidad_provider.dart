import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/domain/repositories/reportes/reporte_morosidad_repository.dart';
import 'package:prestapagos/infrastructure/repositories/reporte/reporte_morosidad_repository_impl.dart';
import 'package:prestapagos/presentation/providers/database/app_database_provider.dart';

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
