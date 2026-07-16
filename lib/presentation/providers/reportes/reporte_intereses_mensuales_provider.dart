import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/domain/repositories/reportes/reporte_intereses_mensuales_repository.dart';
import 'package:prestapagos/infrastructure/repositories/reporte/reporte_intereses_mensuales_repository_impl.dart';
import 'package:prestapagos/presentation/providers/database/app_database_provider.dart';

final reporteInteresesMensualesRepositoryProvider =
    Provider<ReporteInteresesMensualesRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ReporteInteresesMensualesRepositoryImpl(db: db);
});

class ReporteInteresesMensualesProvider
    extends AsyncNotifier<ReporteInteresesMensuales> {
  @override
  FutureOr<ReporteInteresesMensuales> build() {
    final repository = ref.read(reporteInteresesMensualesRepositoryProvider);
    return repository.getReporteInteresesMensuales();
  }
}

final reporteInteresesMensualesProvider =
    AsyncNotifierProvider<ReporteInteresesMensualesProvider,
        ReporteInteresesMensuales>(
  () => ReporteInteresesMensualesProvider(),
);
