import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/providers.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';

class CreatePrestamoStep1 extends ConsumerWidget {
  final VoidCallback onNext;

  const CreatePrestamoStep1({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createPrestamoFormProvider);
    final clientSelected = formState.selectedClient;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Seleccionar cliente',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Busca y selecciona el cliente para el préstamo',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 16),
        Expanded(
          child: _ClienteSearchList(
            onSelected: (client) {
              ref.read(createPrestamoFormProvider.notifier).onClientSelected(client);
            },
          ),
        ),
        if (clientSelected != null) ...[
          const SizedBox(height: 8),
          ClientesDetalles(
            nombre: clientSelected.nombre,
            telefono: clientSelected.telefono,
            estado: clientSelected.estado,
            score: clientSelected.score,
            acciones: const [],
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: formState.selectedClient != null ? onNext : null,
                child: const Text('Siguiente'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ClienteSearchList extends ConsumerStatefulWidget {
  final void Function(ClienteResumen client) onSelected;

  const _ClienteSearchList({required this.onSelected});

  @override
  ConsumerState<_ClienteSearchList> createState() => _ClienteSearchListState();
}

class _ClienteSearchListState extends ConsumerState<_ClienteSearchList> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paginationState = ref.watch(clientePaginationProvider);

    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Buscar cliente...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            ref.read(clientePaginationProvider.notifier).search(value);
          },
        ),
        const SizedBox(height: 8),
        Expanded(
          child: paginationState.isLoading && paginationState.items.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: paginationState.items.length,
                  itemBuilder: (context, index) {
                    final client = paginationState.items[index];
                    final isInactive = client.estado == 'inactivo';
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          client.nombre.isNotEmpty
                              ? client.nombre[0].toUpperCase()
                              : '?',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      title: Text(client.nombre),
                      subtitle: Text(client.telefono),
                      trailing: isInactive
                          ? const Icon(Icons.block, color: Colors.grey)
                          : null,
                      onTap: isInactive ? null : () => widget.onSelected(client),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
