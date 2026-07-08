import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/domain/repositories/reportes/reporte_loan_graphic_repository.dart';
import 'package:prestapagos/infrastructure/repositories/reporte/reporte_loan_graphic_repository_impl.dart';
import 'package:prestapagos/presentation/providers/database/app_database_provider.dart';

final reporteLoanGraphicRepositoryProvider =
    Provider<ReporteLoanGraphicRepository>((ref) {
      final db = ref.watch(appDatabaseProvider);
      return ReporteLoanGraphicRepositoryImpl(db);
    });

class ReporteLoanGraphicProvider extends AsyncNotifier<ReporteLoanGraphic> {
  @override
  Future<ReporteLoanGraphic> build() async {
    final repository = ref.read(reporteLoanGraphicRepositoryProvider);
    return repository.getReporteLoanGraphic();
  }

  Future<void> refreshLoanGraphic() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(reporteLoanGraphicRepositoryProvider);
      return repository.getReporteLoanGraphic();
    });
  }
}

final reporteLoanGraphicProvider =
    AsyncNotifierProvider<ReporteLoanGraphicProvider, ReporteLoanGraphic>(
      () => ReporteLoanGraphicProvider(),
    );
