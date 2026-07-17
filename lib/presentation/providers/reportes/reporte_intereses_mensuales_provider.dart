import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/repositories/repositories.dart';
import 'package:prestapagos/presentation/providers/providers.dart';

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
