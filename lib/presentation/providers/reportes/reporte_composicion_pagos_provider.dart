import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/repositories/repositories.dart';
import 'package:prestapagos/presentation/providers/providers.dart';

final reporteComposicionPagosRepositoryProvider =
    Provider<ReporteComposicionPagosRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ReporteComposicionPagosRepositoryImpl(db: db);
});

class ReporteComposicionPagosProvider
    extends AsyncNotifier<ReporteComposicionPagos> {
  @override
  FutureOr<ReporteComposicionPagos> build() {
    final repository = ref.read(reporteComposicionPagosRepositoryProvider);
    return repository.getReporteComposicionPagos();
  }
}

final reporteComposicionPagosProvider =
    AsyncNotifierProvider<ReporteComposicionPagosProvider,
        ReporteComposicionPagos>(
  () => ReporteComposicionPagosProvider(),
);
