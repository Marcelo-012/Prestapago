import 'package:prestapagos/config/errors/error_mapper.dart';
import 'package:prestapagos/presentation/providers/prestamos/prestamo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeletePrestamoState {
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const DeletePrestamoState({
    required this.isSubmitting,
    required this.isSuccess,
    this.errorMessage,
  });

  DeletePrestamoState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return DeletePrestamoState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class DeletePrestamoNotifier extends Notifier<DeletePrestamoState> {
  @override
  DeletePrestamoState build() => const DeletePrestamoState(
    isSubmitting: false,
    isSuccess: false,
  );

  Future<void> deletePrestamo(int idPrestamo) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      await ref.read(prestamoRepositoryProvider).deletePrestamo(idPrestamo);
      _invalidateProviders();
      state = state.copyWith(isSubmitting: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: mapErrorToMessage(e));
    }
  }

  Future<void> cancelarPrestamo(int idPrestamo) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      await ref.read(prestamoRepositoryProvider).cancelarPrestamo(idPrestamo);
      _invalidateProviders();
      state = state.copyWith(isSubmitting: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: mapErrorToMessage(e));
    }
  }

  Future<void> finalizarPrestamo(int idPrestamo) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      await ref.read(prestamoRepositoryProvider).finalizarPrestamo(idPrestamo);
      _invalidateProviders();
      state = state.copyWith(isSubmitting: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: mapErrorToMessage(e));
    }
  }

  void _invalidateProviders() {
    ref.invalidate(prestamoPaginationProvider);
    ref.read(prestamoPaginationProvider.notifier).refresh();
  }
}

final deletePrestamoProvider =
    NotifierProvider<DeletePrestamoNotifier, DeletePrestamoState>(
  DeletePrestamoNotifier.new,
);
