import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/domain/repositories/reportes/reporte_card_repository.dart';
import 'package:prestapagos/infrastructure/repositories/reporte/reporte_card_repository_impl.dart';
import 'package:prestapagos/presentation/providers/database/app_database_provider.dart';

final reporteCardRepositoryProvider = Provider<ReporteCardRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ReporteCardRepositoryImpl(db);
});

class ReporteCardProvider extends AsyncNotifier<ReporteCard> {
  @override
  Future<ReporteCard> build() async {
    final repository = ref.read(reporteCardRepositoryProvider);
    return repository.getReporteCard();
  }

  Future<void> refreshCard() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(reporteCardRepositoryProvider);
      return repository.getReporteCard();
    });
  }
}

final reporteCardProvider =
    AsyncNotifierProvider<ReporteCardProvider, ReporteCard>(
      () => ReporteCardProvider(),
    );
