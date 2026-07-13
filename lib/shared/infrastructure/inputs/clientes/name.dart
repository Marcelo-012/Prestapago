import 'package:formz/formz.dart';

enum NameError { empty, format, length, maxLength }

class Name extends FormzInput<String, NameError> {
  static final RegExp nameRegExp = RegExp(
    r"^[\p{L}]+(?:[ '\-][\p{L}]+)*$",
    unicode: true,
  );
  const Name.pure() : super.pure('');

  const Name.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == NameError.empty) return 'El campo es requerido';
    if (displayError == NameError.length) return 'Nombre muy corto';
    if (displayError == NameError.maxLength) {
      return 'El nombre no puede superar los 60 caracteres';
    }

    if (displayError == NameError.format) return 'Caracteres no validos ';

    return null;
  }

  @override
  NameError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return NameError.empty;
    if (trimmed.length < 10) return NameError.length;
    if (trimmed.length > 60) return NameError.maxLength;
    if (!nameRegExp.hasMatch(trimmed)) return NameError.format;

    return null;
  }
}
