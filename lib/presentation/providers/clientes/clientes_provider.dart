import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/config/errors/errors.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/repositories/repositories.dart';
import 'package:prestapagos/presentation/providers/providers.dart';

final clienteRepositoryProvider = Provider<ClienteRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ClienteRepositoryImpl(db);
});

class ClientePaginationState {
  final List<ClienteResumen> items;
  final bool isLoading;
  final bool hasMore;
  final String? error;

  const ClientePaginationState({
    required this.items,
    required this.isLoading,
    required this.hasMore,
    this.error,
  });

  ClientePaginationState copyWith({
    List<ClienteResumen>? items,
    bool? isLoading,
    bool? hasMore,
    String? error,
  }) {
    return ClientePaginationState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}

class ClientePaginationNotifier extends Notifier<ClientePaginationState> {
  String _search = '';
  int _currentPage = 0;
  static const int _pageSize = 10;

  @override
  ClientePaginationState build() {
    return const ClientePaginationState(
      items: [],
      isLoading: false,
      hasMore: true,
    );
  }

  Future<void> _performLoad() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(clienteRepositoryProvider);
      final result = await repository.getPaged(
        page: _currentPage,
        pageSize: _pageSize,
        search: _search.isEmpty ? null : _search,
      );

      _currentPage++;
      state = state.copyWith(
        items: [...state.items, ...result.items],
        isLoading: false,
        hasMore: result.hasMore,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: mapErrorToMessage(e),
      );
    }
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || !state.hasMore) return;
    await _performLoad();
  }

  Future<void> search(String query) async {
    _search = query;
    _currentPage = 0;
    state = ClientePaginationState(items: [], isLoading: true, hasMore: true);
    await _performLoad();
  }

  Future<void> refresh() async {
    _currentPage = 0;
    state = ClientePaginationState(items: [], isLoading: true, hasMore: true);
    await _performLoad();
  }
}

final clientePaginationProvider =
    NotifierProvider<ClientePaginationNotifier, ClientePaginationState>(
  ClientePaginationNotifier.new,
);

final clienteDetalleProvider = FutureProvider.family<ClienteDetalle, int>((
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
