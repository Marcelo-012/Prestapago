import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/domain/repositories/reportes/reporte_estado_prestamos_repository.dart';
import 'package:prestapagos/infrastructure/repositories/reporte/reporte_estado_prestamos_repository_impl.dart';
import 'package:prestapagos/presentation/providers/database/app_database_provider.dart';

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
