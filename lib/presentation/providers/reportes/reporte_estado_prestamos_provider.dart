import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/repositories/repositories.dart';
import 'package:prestapagos/presentation/providers/providers.dart';

final reporteEstadoPrestamosRepositoryProvider =
    Provider<ReporteEstadoPrestamosRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ReporteEstadoPrestamosRepositoryImpl(db: db);
});

class ReporteEstadoPrestamosProvider
    extends AsyncNotifier<ReporteEstadoPrestamos> {
  @override
  FutureOr<ReporteEstadoPrestamos> build() {
    final repository = ref.read(reporteEstadoPrestamosRepositoryProvider);
    return repository.getReporteEstadoPrestamos();
  }
}

final reporteEstadoPrestamosProvider =
    AsyncNotifierProvider<ReporteEstadoPrestamosProvider,
        ReporteEstadoPrestamos>(
  () => ReporteEstadoPrestamosProvider(),
);
