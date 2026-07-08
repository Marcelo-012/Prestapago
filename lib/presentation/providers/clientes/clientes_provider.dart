import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/repositories/clientes/cliente_repository.dart';
import 'package:prestapagos/infrastructure/repositories/cliente/cliente_repository_impl.dart';
import 'package:prestapagos/presentation/providers/database/app_database_provider.dart';

import '../../../domain/entities/entities.dart';

final clienteRepositoryProvider = Provider<ClienteRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ClienteRepositoryImpl(db);
});

final clientesProvider = FutureProvider<List<ClienteResumen>>((ref) async {
  final repository = ref.watch(clienteRepositoryProvider);
  return repository.getAll();
});

final clienteDellateProvider = FutureProvider.family<ClienteDetalle, int>((
  ref,
  idDeudor,
) async {
  final repository = ref.watch(clienteRepositoryProvider);
  return repository.getDetalle(idDeudor);
});

final clienteProvider = FutureProviderFamily<Cliente, int>((
  ref,
  idDeudor,
) async {
  final repository = ref.watch(clienteRepositoryProvider);
  return repository.getById(idDeudor);
});
