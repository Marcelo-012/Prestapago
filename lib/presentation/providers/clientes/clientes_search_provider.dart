import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/clientes/clientes_provider.dart';

final clienteSearchQueryProvider = StateProvider<String>((ref) => '');

final clienteFilteredProvider = Provider<AsyncValue<List<ClienteResumen>>>((
  ref,
) {
  final query = ref.watch(clienteSearchQueryProvider);
  final clienteAsync = ref.watch(clientesProvider);

  return clienteAsync.whenData((clientes) {
    if (query.isEmpty) return clientes;

    final queryLower = query.toLowerCase();
    return clientes.where((cliente) {
      return cliente.nombre.toLowerCase().contains(queryLower) ||
          cliente.telefono.contains(query);
    }).toList();
  });
});
