import 'package:formz/formz.dart';

enum DniError { empty, format }

class Dni extends FormzInput<String, DniError> {
  // Alfanumérico, sin espacios, longitud razonable (ajusta el {n,m} a tu caso)
  static final RegExp dniRegExp = RegExp(r'^[a-zA-Z0-9]{3,20}$');

  const Dni.pure() : super.pure('');
  const Dni.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == DniError.empty) return 'El campo es requerido';
    if (displayError == DniError.format) return 'Caracteres no válidos';
    return null;
  }

  @override
  DniError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return DniError.empty;
    if (!dniRegExp.hasMatch(trimmed)) return DniError.format;
    return null;
  }
}
