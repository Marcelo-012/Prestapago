import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/repositories/repositories.dart';
import 'package:prestapagos/presentation/providers/providers.dart';

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
