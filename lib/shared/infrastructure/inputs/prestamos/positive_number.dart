import 'package:formz/formz.dart';

enum PositiveNumberError { empty, invalid, notPositive }

class PositiveNumber extends FormzInput<String, PositiveNumberError> {
  const PositiveNumber.pure() : super.pure('');
  const PositiveNumber.dirty(super.value) : super.dirty();

  @override
  PositiveNumberError? validator(String value) {
    if (value.trim().isEmpty) return PositiveNumberError.empty;
    final number = double.tryParse(value);
    if (number == null) return PositiveNumberError.invalid;
    if (number <= 0) return PositiveNumberError.notPositive;
    return null;
  }
}
