import 'package:formz/formz.dart';

enum PositiveNumberError { empty, invalid, notPositive }

class PositiveNumber extends FormzInput<String, PositiveNumberError> {
  const PositiveNumber.pure() : super.pure('');
  const PositiveNumber.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == PositiveNumberError.empty) return 'El campo es requerido';
    if (displayError == PositiveNumberError.invalid) return 'Número inválido';
    if (displayError == PositiveNumberError.notPositive) return 'Debe ser mayor a 0';
    return null;
  }

  @override
  PositiveNumberError? validator(String value) {
    if (value.trim().isEmpty) return PositiveNumberError.empty;
    final number = double.tryParse(value);
    if (number == null) return PositiveNumberError.invalid;
    if (number <= 0) return PositiveNumberError.notPositive;
    return null;
  }
}
