import 'package:formz/formz.dart';

enum RequiredStringError { empty }

class RequiredString extends FormzInput<String, RequiredStringError> {
  const RequiredString.pure() : super.pure('');
  const RequiredString.dirty(super.value) : super.dirty();

  @override
  RequiredStringError? validator(String value) {
    if (value.trim().isEmpty) return RequiredStringError.empty;
    return null;
  }
}
