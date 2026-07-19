import 'package:prestapagos/config/errors/errors.dart';
import 'package:prestapagos/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CancelarPrestamoState {
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const CancelarPrestamoState({
    required this.isSubmitting,
    required this.isSuccess,
    this.errorMessage,
  });

  CancelarPrestamoState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return CancelarPrestamoState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CancelarPrestamoNotifier extends Notifier<CancelarPrestamoState> {
  @override
  CancelarPrestamoState build() => const CancelarPrestamoState(
    isSubmitting: false,
    isSuccess: false,
  );

  Future<void> cancelarPrestamo(int idPrestamo, String motivo, double montoDevuelto) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      await ref.read(prestamoRepositoryProvider).cancelarPrestamo(idPrestamo, motivo, montoDevuelto);
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

final cancelarPrestamoProvider =
    NotifierProvider<CancelarPrestamoNotifier, CancelarPrestamoState>(
  CancelarPrestamoNotifier.new,
);
