import 'package:prestapagos/config/errors/errors.dart';
import 'package:prestapagos/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CastigarPrestamoState {
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const CastigarPrestamoState({
    required this.isSubmitting,
    required this.isSuccess,
    this.errorMessage,
  });

  CastigarPrestamoState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return CastigarPrestamoState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CastigarPrestamoNotifier extends Notifier<CastigarPrestamoState> {
  @override
  CastigarPrestamoState build() => const CastigarPrestamoState(
    isSubmitting: false,
    isSuccess: false,
  );

  Future<void> castigarPrestamo(int idPrestamo, String motivo) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      await ref.read(prestamoRepositoryProvider).castigarPrestamo(idPrestamo, motivo);
      _invalidateProviders(idPrestamo);
      state = state.copyWith(isSubmitting: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: mapErrorToMessage(e));
    }
  }

  void _invalidateProviders(int idPrestamo) {
    ref.invalidate(prestamoPaginationProvider);
    ref.read(prestamoPaginationProvider.notifier).refresh();
    ref.invalidate(prestamoDetalleProvider(idPrestamo));
    ref.invalidate(prestamoProvider(idPrestamo));
    invalidateAllReportes(ref);
  }
}

final castigarPrestamoProvider =
    NotifierProvider<CastigarPrestamoNotifier, CastigarPrestamoState>(
  CastigarPrestamoNotifier.new,
);
