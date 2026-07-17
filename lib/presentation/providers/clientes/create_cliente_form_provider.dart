import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/shared/shared.dart';

class CreaClienteFormNotifier extends Notifier<CreateClienteFormState> {
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

final createClienteFormProvider =
    NotifierProvider<CreaClienteFormNotifier, CreateClienteFormState>(
      CreaClienteFormNotifier.new,
    );

class CreateClienteFormState {
  final Name name;
  final Age age;
  final Dni dni;
  final Email email;
  final Phone phone;
  final Address address;

  CreateClienteFormState({
    required this.name,
    required this.age,
    required this.dni,
    required this.email,
    required this.phone,
    required this.address,
  });

  bool get isFormValid =>
      name.isValid &&
      age.isValid &&
      dni.isValid &&
      email.isValid &&
      phone.isValid &&
      address.isValid;

  CreateClienteFormState copyWith({
    Name? name,
    Age? age,
    Dni? dni,
    Email? email,
    Phone? phone,
    Address? address,
  }) {
    return CreateClienteFormState(
      name: name ?? this.name,
      age: age ?? this.age,
      dni: dni ?? this.dni,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}
