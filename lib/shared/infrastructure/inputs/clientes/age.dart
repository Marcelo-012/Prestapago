import 'package:formz/formz.dart';

enum AgeError { empty, format, min, max }

class Age extends FormzInput<String, AgeError> {
  const Age.pure() : super.pure('');
  const Age.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == AgeError.empty) return 'El campo es requerido';
    if (displayError == AgeError.min) return 'Debe ser mayor de 18 años';
    if (displayError == AgeError.max) return 'Edad máxima 99 años';
    if (displayError == AgeError.format) return 'Solo se permiten números';
    return null;
  }

  @override
  AgeError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return AgeError.empty;

    final age = int.tryParse(trimmed);
    if (age == null) return AgeError.format;
    if (age < 18) return AgeError.min;
    if (age > 99) return AgeError.max;

    return null;
  }
}
