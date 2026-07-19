import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/repositories/repositories.dart';
import 'package:prestapagos/presentation/providers/providers.dart';

final reportePaymentsGraphicRepositoryProvider =
    Provider<ReportePaymentsGraphicRepository>((ref) {
      final db = ref.watch(appDatabaseProvider);
      return ReportePaymentsGraphicRepositoryImpl(db: db);
    });

class ReportePaymentsGraphicProvider
    extends AsyncNotifier<ReportePaymentsGraphic> {
  @override
  FutureOr<ReportePaymentsGraphic> build() {
    final repository = ref.read(reportePaymentsGraphicRepositoryProvider);
    return repository.getReportePaymentsGraphic();
  }
}

final reportePaymentsGraphicProvider =
    AsyncNotifierProvider<ReportePaymentsGraphicProvider, ReportePaymentsGraphic>(
      () => ReportePaymentsGraphicProvider(),
    );
