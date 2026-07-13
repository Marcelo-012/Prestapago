import 'package:prestapagos/config/errors/error_mapper.dart';
import 'package:prestapagos/presentation/providers/clientes/clientes_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteClienteState {
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const DeleteClienteState({
    required this.isSubmitting,
    required this.isSuccess,
    this.errorMessage,
  });

  DeleteClienteState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return DeleteClienteState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class DeleteClienteNotifier extends Notifier<DeleteClienteState> {
  @override
  DeleteClienteState build() => const DeleteClienteState(
    isSubmitting: false,
    isSuccess: false,
  );

  Future<void> deleteCliente(int idDeudor) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      await ref.read(clienteRepositoryProvider).deleteCliente(idDeudor);
      _invalidateProviders(idDeudor);
      state = state.copyWith(isSubmitting: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: mapErrorToMessage(e));
    }
  }

  Future<void> deactivateCliente(int idDeudor) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      await ref.read(clienteRepositoryProvider).deactivateCliente(idDeudor);
      _invalidateProviders(idDeudor);
      state = state.copyWith(isSubmitting: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: mapErrorToMessage(e));
    }
  }

  Future<void> reactivateCliente(int idDeudor) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      await ref.read(clienteRepositoryProvider).reactivateCliente(idDeudor);
      _invalidateProviders(idDeudor);
      state = state.copyWith(isSubmitting: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: mapErrorToMessage(e));
    }
  }

  void _invalidateProviders(int idDeudor) {
    ref.invalidate(clienteProvider(idDeudor));
    ref.invalidate(clienteDetalleProvider(idDeudor));
    ref.invalidate(clientePaginationProvider);
    ref.read(clientePaginationProvider.notifier).refresh();
  }
}

final deleteClienteProvider =
    NotifierProvider<DeleteClienteNotifier, DeleteClienteState>(
  DeleteClienteNotifier.new,
);
