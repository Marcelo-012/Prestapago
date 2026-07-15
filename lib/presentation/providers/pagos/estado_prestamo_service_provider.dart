import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/infrastructure/services/estado_prestamo_service.dart';
import 'package:prestapagos/presentation/providers/database/app_database_provider.dart';

final estadoPrestamoServiceProvider = Provider<EstadoPrestamoService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return EstadoPrestamoService(db: db);
});
