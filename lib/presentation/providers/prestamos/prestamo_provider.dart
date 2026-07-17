import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/config/errors/errors.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/repositories/repositories.dart';
import 'package:prestapagos/presentation/providers/providers.dart';

final prestamoRepositoryProvider = Provider<PrestamoRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final estadoPrestamoService = ref.watch(estadoPrestamoServiceProvider);
  return PrestamoRepositoryImpl(
    db: db,
    estadoPrestamoService: estadoPrestamoService,
  );
});

class PrestamoPaginationState {
  final List<PrestamoResumen> items;
  final bool isLoading;
  final bool hasMore;
  final String? error;

  const PrestamoPaginationState({
    required this.items,
    required this.isLoading,
    required this.hasMore,
    this.error,
  });

  PrestamoPaginationState copyWith({
    List<PrestamoResumen>? items,
    bool? isLoading,
    bool? hasMore,
    String? error,
  }) {
    return PrestamoPaginationState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}

class PrestamoPaginationNotifier extends Notifier<PrestamoPaginationState> {
  String _search = '';
  int _currentPage = 0;
  static const int _pageSize = 10;

  @override
  PrestamoPaginationState build() {
    return const PrestamoPaginationState(
      items: [],
      isLoading: false,
      hasMore: true,
    );
  }

  Future<void> _performLoad() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(prestamoRepositoryProvider);
      final filterValue = ref.read(prestamoFilterProvider);
      final result = await repository.getPaged(
        page: _currentPage,
        pageSize: _pageSize,
        search: _search.isEmpty ? null : _search,
        filter: filterValue,
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
    state = PrestamoPaginationState(items: [], isLoading: true, hasMore: true);
    await _performLoad();
  }

  Future<void> refresh() async {
    _currentPage = 0;
    state = PrestamoPaginationState(items: [], isLoading: true, hasMore: true);
    await _performLoad();
  }
}

final prestamoFilterProvider = StateProvider<String>((ref) => 'al_dia');

final prestamoPaginationProvider =
    NotifierProvider<PrestamoPaginationNotifier, PrestamoPaginationState>(
  PrestamoPaginationNotifier.new,
);

final prestamoDetalleProvider = FutureProvider.family<PrestamoDetalle, int>((
  ref,
  idPrestamo,
) async {
  final repository = ref.watch(prestamoRepositoryProvider);
  return repository.getDetalle(idPrestamo);
});

final prestamoProvider = FutureProviderFamily<Prestamo, int>((
  ref,
  idPrestamo,
) async {
  final repository = ref.watch(prestamoRepositoryProvider);
  return repository.getById(idPrestamo);
});
