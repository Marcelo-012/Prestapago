import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/presentation/providers/clientes/clientes_search_provider.dart';
import 'package:prestapagos/presentation/providers/clientes/clientes_provider.dart';
import 'package:prestapagos/presentation/widgets/clientes/clientes_list_item.dart';

import '../widgets/widgets.dart';

class ClientesView extends ConsumerWidget {
  const ClientesView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;
    final searchQuery = ref.watch(clienteSearchQueryProvider);

    final filtrados = ref.watch(clienteFilteredProvider);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const CustomAppbar(title: 'Clientes'),
            titlePadding: EdgeInsets.zero,
          ),
        ),

        //Campo de busqueda
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsetsGeometry.all(16),
            child: TextField(
              onChanged: (value) {
                ref.read(clienteSearchQueryProvider.notifier).state = value;
              },
              decoration: InputDecoration(
                hintText: 'Buscar pot nombre, telefono...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          ref.read(clienteSearchQueryProvider.notifier).state =
                              '';
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.outline),
                ),
                contentPadding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 16,
                ),
              ),
            ),
          ),

          ///
        ),

        filtrados.when(
          loading: () => SliverFillRemaining(
            child: const Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => SliverFillRemaining(
            child: ErrorWidgetCustom(
              error: error,
              onRetry: () => ref.refresh(clientesProvider),
            ),
          ),
          data: (clientes) {
            if (clientes.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Sin resultados para tu búsqueda',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final cliente = clientes[index];
                return ClientesListItem(
                  cliente: cliente,
                  onTap: () {
                    // Navega al detalle del cliente
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Abriendo ${cliente.nombre}')),
                    );
                  },
                );
              }, childCount: clientes.length),
            );
          },
        ),
      ],
    );
  }
}
