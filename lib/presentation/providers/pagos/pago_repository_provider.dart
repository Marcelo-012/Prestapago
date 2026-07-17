import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/repositories/repositories.dart';
import 'package:prestapagos/presentation/providers/providers.dart';

final pagoRepositoryProvider = Provider<PagoRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final prestamoRepository = ref.watch(prestamoRepositoryProvider);
  final estadoPrestamoService = ref.watch(estadoPrestamoServiceProvider);
  return PagoRepositoryImpl(
    db: db,
    prestamoRepository: prestamoRepository,
    estadoPrestamoService: estadoPrestamoService,
  );
});
