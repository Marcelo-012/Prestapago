import 'package:formz/formz.dart';

enum PagoMontoError { empty, invalid, notPositive, belowMinimum, aboveMaximum }

class PagoMonto extends FormzInput<String, PagoMontoError> {
  final double minimo;
  final double maximo;

  const PagoMonto.pure({this.minimo = 0, this.maximo = 1e12}) : super.pure('');
  const PagoMonto.dirty(super.value, {this.minimo = 0, this.maximo = 1e12}) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == PagoMontoError.empty) return 'El monto es requerido';
    if (displayError == PagoMontoError.invalid) return 'Monto inválido';
    if (displayError == PagoMontoError.notPositive) return 'Debe ser mayor a 0';
    if (displayError == PagoMontoError.belowMinimum) {
      return 'Debe ser mayor o igual a \$${minimo.toStringAsFixed(2)}';
    }
    if (displayError == PagoMontoError.aboveMaximum) {
      return 'No puede exceder \$${maximo.toStringAsFixed(2)}';
    }
    return null;
  }

  @override
  PagoMontoError? validator(String value) {
    if (value.trim().isEmpty) return PagoMontoError.empty;
    final number = double.tryParse(value);
    if (number == null) return PagoMontoError.invalid;
    if (number <= 0) return PagoMontoError.notPositive;
    if ((number * 100).round() < (minimo * 100).round()) return PagoMontoError.belowMinimum;
    if ((number * 100).round() > (maximo * 100).round()) return PagoMontoError.aboveMaximum;
    return null;
  }
}
