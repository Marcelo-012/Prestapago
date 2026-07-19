import 'package:formz/formz.dart';

enum DniError { empty, format, maxLength }

class Dni extends FormzInput<String, DniError> {
  static final RegExp dniRegExp = RegExp(r'^[a-zA-Z0-9]+$');

  const Dni.pure() : super.pure('');
  const Dni.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == DniError.empty) return 'El campo es requerido';
    if (displayError == DniError.maxLength) {
      return 'El número de identidad no puede superar los 20 caracteres';
    }
    if (displayError == DniError.format) return 'Caracteres no válidos';
    return null;
  }

  @override
  DniError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return DniError.empty;
    if (trimmed.length > 20) return DniError.maxLength;
    if (!dniRegExp.hasMatch(trimmed)) return DniError.format;
    return null;
  }
}
