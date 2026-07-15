import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prestapagos/presentation/providers/prestamos/prestamo_provider.dart';
import 'package:prestapagos/presentation/widgets/prestamos/filtros_prestamos.dart';
import 'package:prestapagos/presentation/widgets/prestamos/prestamo_list_item.dart';

import 'package:prestapagos/presentation/widgets/widgets.dart';

class PrestamosView extends ConsumerStatefulWidget {
  const PrestamosView({super.key});

  @override
  ConsumerState<PrestamosView> createState() => _PrestamosViewState();
}

class _PrestamosViewState extends ConsumerState<PrestamosView> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(prestamoPaginationProvider.notifier).loadNextPage(),
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
      ref.read(prestamoPaginationProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final paginationState = ref.watch(prestamoPaginationProvider);

    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                floating: true,
                flexibleSpace: const FlexibleSpaceBar(
                  title: CustomAppbar(title: 'Prestamos'),
                  titlePadding: EdgeInsets.zero,
                ),
              ),

              // Search bar
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
                          .read(prestamoPaginationProvider.notifier)
                          .search(value);
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Buscar por nombre...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                ref
                                    .read(prestamoPaginationProvider.notifier)
                                    .search('');
                              },
                              icon: const Icon(Icons.clear),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ),

              // Filters below search
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: FiltrosPrestamos(
                    initialFilter: 'al_dia',
                    onFilterChanged: (filter) {
                      ref.read(prestamoFilterProvider.notifier).state = filter;
                      ref.read(prestamoPaginationProvider.notifier).refresh();
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              if (paginationState.error != null)
                SliverFillRemaining(
                  child: ErrorWidgetCustom(
                    error: paginationState.error!,
                    onRetry: () =>
                        ref.read(prestamoPaginationProvider.notifier).refresh(),
                  ),
                )
              else if (paginationState.items.isEmpty &&
                  !paginationState.isLoading)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.credit_card_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Sin préstamos',
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
                    final loan = paginationState.items[index];
                    return PrestamoListItem(
                      prestamo: loan,
                      onTap: () =>
                          context.push('/home/1/prestamo/${loan.idPrestamo}'),
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
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            heroTag: 'fab_prestamos',
            onPressed: () => context.push('/create-prestamo'),
            icon: const Icon(Icons.add_card_outlined),
            label: const Text('Nuevo préstamo'),
          ),
        ),
      ],
    );
  }
}
