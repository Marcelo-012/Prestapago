import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/domain/repositories/reportes/reporte_composicion_pagos_repository.dart';
import 'package:prestapagos/infrastructure/repositories/reporte/reporte_composicion_pagos_repository_impl.dart';
import 'package:prestapagos/presentation/providers/database/app_database_provider.dart';

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
