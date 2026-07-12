import 'package:formz/formz.dart';

enum PhoneError { empty, format, length, maxLength }

class Phone extends FormzInput<String, PhoneError> {
  // Solo dígitos, exactamente 10
  static final RegExp phoneRegExp = RegExp(r"^\d{10}$");

  const Phone.pure() : super.pure('');
  const Phone.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PhoneError.empty) return 'El campo es requerido';
    if (displayError == PhoneError.length) {
      return 'El número debe tener 10 dígitos';
    }
    if (displayError == PhoneError.maxLength) {
      return 'El número no puede tener más de 10 dígitos';
    }
    if (displayError == PhoneError.format) return 'Solo se permiten números';
    return null;
  }

  @override
  PhoneError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return PhoneError.empty;

    if (trimmed.length < 10) return PhoneError.length;
    if (trimmed.length > 10) return PhoneError.maxLength;

    if (!phoneRegExp.hasMatch(trimmed)) return PhoneError.format;

    return null;
  }
}
