import 'package:formz/formz.dart';

enum PercentageError { empty, invalid, negative, outOfRange }

class Percentage extends FormzInput<String, PercentageError> {
  const Percentage.pure() : super.pure('');
  const Percentage.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == PercentageError.empty) return 'El campo es requerido';
    if (displayError == PercentageError.invalid) return 'Porcentaje inválido';
    if (displayError == PercentageError.negative) return 'No puede ser negativo';
    if (displayError == PercentageError.outOfRange) return 'No puede exceder 100%';
    return null;
  }

  @override
  PercentageError? validator(String value) {
    if (value.trim().isEmpty) return PercentageError.empty;
    final number = double.tryParse(value);
    if (number == null) return PercentageError.invalid;
    if (number < 0) return PercentageError.negative;
    if (number > 100) return PercentageError.outOfRange;
    return null;
  }
}
