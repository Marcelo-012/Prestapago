import 'package:formz/formz.dart';

enum AddressError { empty, minLength, maxLength }

class Address extends FormzInput<String, AddressError> {
  const Address.pure() : super.pure('');
  const Address.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == AddressError.empty) return 'El campo es requerido';
    if (displayError == AddressError.minLength) {
      return 'La dirección debe tener al menos 10 caracteres';
    }
    if (displayError == AddressError.maxLength) {
      return 'La dirección no puede superar los 150 caracteres';
    }
    return null;
  }

  @override
  AddressError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return AddressError.empty;
    if (trimmed.length < 10) return AddressError.minLength;
    if (trimmed.length > 150) return AddressError.maxLength;
    return null;
  }
}
