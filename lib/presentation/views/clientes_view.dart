import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prestapagos/presentation/providers/providers.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';

class ClientesView extends ConsumerStatefulWidget {
  const ClientesView({super.key});

  @override
  ConsumerState<ClientesView> createState() => _ClientesViewState();
}

class _ClientesViewState extends ConsumerState<ClientesView> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(clientePaginationProvider.notifier).loadNextPage(),
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(clientePaginationProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final paginationState = ref.watch(clientePaginationProvider);

    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: const CustomAppbar(title: 'Clientes'),
                  titlePadding: EdgeInsets.zero,
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      ref
                          .read(clientePaginationProvider.notifier)
                          .search(value);
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Buscar por nombre, teléfono...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                ref
                                    .read(clientePaginationProvider.notifier)
                                    .search('');
                              },
                              icon: const Icon(Icons.clear),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colors.outline),
                      ),
                      contentPadding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ),

              if (paginationState.error != null)
                SliverFillRemaining(
                  child: Text(paginationState.error!),
                  // ErrorWidgetCustom(
                  //   error: paginationState.error!,
                  //   onRetry: () =>
                  //       ref.read(clientePaginationProvider.notifier).refresh(),
                  // ),
                )
              else if (paginationState.items.isEmpty &&
                  !paginationState.isLoading)
                SliverFillRemaining(
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
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final cliente = paginationState.items[index];
                    return ClientesListItem(
                      cliente: cliente,
                      onTap: () =>
                          context.push('/home/1/cliente/${cliente.idDeudor}'),
                    );
                  }, childCount: paginationState.items.length),
                ),

              if (paginationState.isLoading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),

              // Espacio para que el FAB no tape el último item
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),

        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            heroTag: 'fab_clientes',
            onPressed: () => context.push('/create-cliente'),
            icon: const Icon(Icons.person_add),
            label: const Text('Nuevo cliente'),
          ),
        ),
      ],
    );
  }
}
