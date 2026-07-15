import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/config/errors/error_mapper.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/clientes/clientes_provider.dart';
import 'package:prestapagos/presentation/providers/clientes/edit_cliente_form_provider.dart';

String _capitalizeWords(String value) {
  return value
      .split(' ')
      .map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      })
      .join(' ');
}

class EditClienteNotifier extends Notifier<EditClienteState> {
  @override
  EditClienteState build() => EditClienteState(
    //
    isSubmitting: false,
    isSuccess: false,
  );

  Future<void> submit(int clienteId, DateTime fechaCreacion) async {
    ref.read(editClienteFormProvider.notifier).touchAll();
    final formState = ref.read(editClienteFormProvider);

    if (!formState.isFormValid) return;

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      await ref
          .read(clienteRepositoryProvider)
          .updateCliente(
            Cliente(
              idDeudor: clienteId,
              nombre: _capitalizeWords(formState.name.value.trim()),
              telefono: formState.phone.value,
              email: formState.email.value.isEmpty
                  ? null
                  : formState.email.value,
              direccion: formState.address.value,
              dni: formState.dni.value,
              edad: int.tryParse(formState.age.value) ?? 0,
              estado: EstadoCliente.activo.name,
              fechaCreacion: fechaCreacion,
              fechaActualizacion: DateTime.now(),
            ),
          );

      state = state.copyWith(isSubmitting: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: mapErrorToMessage(e));
    }
  }

  void reset() {
    state = build();
  }
}

final editClienteProvider =
    NotifierProvider<EditClienteNotifier, EditClienteState>(
      EditClienteNotifier.new,
    );

class EditClienteState {
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  EditClienteState({
    required this.isSubmitting,
    required this.isSuccess,
    this.errorMessage,
  });

  EditClienteState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return EditClienteState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
