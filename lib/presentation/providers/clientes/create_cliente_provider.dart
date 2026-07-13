import 'package:prestapagos/config/errors/error_mapper.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/clientes/clientes_provider.dart';
import 'package:prestapagos/presentation/providers/clientes/create_cliente_form_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String _capitalizeWords(String value) {
  return value.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

class CreateClienteNotifier extends Notifier<CreateClienteState> {
  @override
  CreateClienteState build() => CreateClienteState(
    //
    isSubmitting: false,
    isSuccess: false,
  );

  Future<void> submit() async {
    final formState = ref.read(createClienteFormProvider);
    ref.read(createClienteFormProvider.notifier).touchAll();

    if (!formState.isFormValid) return;

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      await ref
          .read(clienteRepositoryProvider)
          .createCliente(
            Cliente(
              idDeudor: 0,
              nombre: _capitalizeWords(formState.name.value.trim()),
              telefono: formState.phone.value,
              email: formState.email.value.isEmpty
                  ? null
                  : formState.email.value,
              direccion: formState.address.value,
              dni: formState.dni.value,
              edad: int.tryParse(formState.age.value) ?? 0,
              estado: EstadoCliente.activo.toString(),
              fechaCreacion: DateTime.now(),
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

final createClienteProvider =
    NotifierProvider<CreateClienteNotifier, CreateClienteState>(
      CreateClienteNotifier.new,
    );

class CreateClienteState {
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  CreateClienteState({
    required this.isSubmitting,
    required this.isSuccess,
    this.errorMessage,
  });

  CreateClienteState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return CreateClienteState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
