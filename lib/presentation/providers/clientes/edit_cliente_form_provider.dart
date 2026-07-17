import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/providers.dart';
import 'package:prestapagos/shared/shared.dart';

class EditClienteFormNotifer extends Notifier<CreateClienteFormState> {
  @override
  CreateClienteFormState build() {
    return CreateClienteFormState(
      name: const Name.pure(),
      age: const Age.pure(),
      dni: const Dni.pure(),
      email: const Email.pure(),
      phone: const Phone.pure(),
      address: const Address.pure(),
    );
  }

  void loadFromCliente(Cliente cliente) {
    state = CreateClienteFormState(
      name: Name.dirty(cliente.nombre),
      age: Age.dirty(cliente.edad.toString()),
      dni: Dni.dirty(cliente.dni),
      email: Email.dirty(cliente.email ?? ''),
      phone: Phone.dirty(cliente.telefono),
      address: Address.dirty(cliente.direccion),
    );
  }

  void onNameChanged(String value) {
    state = state.copyWith(name: Name.dirty(value));
  }

  void onAgeChanged(String value) {
    state = state.copyWith(age: Age.dirty(value));
  }

  void onDniChanged(String value) {
    state = state.copyWith(dni: Dni.dirty(value));
  }

  void onEmailChanged(String value) {
    state = state.copyWith(email: Email.dirty(value));
  }

  void onPhoneChanged(String value) {
    state = state.copyWith(phone: Phone.dirty(value));
  }

  void onAddressChanged(String value) {
    state = state.copyWith(address: Address.dirty(value));
  }

  void touchAll() {
    state = state.copyWith(
      name: Name.dirty(state.name.value),
      age: Age.dirty(state.age.value),
      dni: Dni.dirty(state.dni.value),
      email: Email.dirty(state.email.value),
      phone: Phone.dirty(state.phone.value),
      address: Address.dirty(state.address.value),
    );
  }

  void reset() {
    state = build();
  }
}

final editClienteFormProvider =
    NotifierProvider<EditClienteFormNotifer, CreateClienteFormState>(
      EditClienteFormNotifer.new,
    );
