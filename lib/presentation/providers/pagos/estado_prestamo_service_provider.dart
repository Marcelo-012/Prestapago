import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/infrastructure/services/services.dart';
import 'package:prestapagos/presentation/providers/providers.dart';

final estadoPrestamoServiceProvider = Provider<EstadoPrestamoService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return EstadoPrestamoService(db: db);
});
