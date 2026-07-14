import 'package:formz/formz.dart';

enum OptionalNumberError { invalid, negative }

class OptionalNumber extends FormzInput<String, OptionalNumberError> {
  const OptionalNumber.pure() : super.pure('');
  const OptionalNumber.dirty(super.value) : super.dirty();

  @override
  OptionalNumberError? validator(String value) {
    if (value.trim().isEmpty) return null;
    final number = double.tryParse(value);
    if (number == null) return OptionalNumberError.invalid;
    if (number < 0) return OptionalNumberError.negative;
    return null;
  }
}
