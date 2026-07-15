import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/repositories/pagos/pago_repository.dart';
import 'package:prestapagos/infrastructure/repositories/pagos/pago_repository_impl.dart';
import 'package:prestapagos/presentation/providers/database/app_database_provider.dart';
import 'package:prestapagos/presentation/providers/pagos/estado_prestamo_service_provider.dart';
import 'package:prestapagos/presentation/providers/prestamos/prestamo_provider.dart';

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
