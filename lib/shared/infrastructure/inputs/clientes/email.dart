import 'package:formz/formz.dart';

enum EmailError { empty, format, maxLength }

class Email extends FormzInput<String, EmailError> {
  static final RegExp emailRegExp = RegExp(
    r"^[^\W_]+([._%+-][^\W_]+)*@[^\W_]+([.-][^\W_]+)*\.[a-zA-Z]{2,24}$",
  );

  const Email.pure() : super.pure('');

  const Email.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == EmailError.maxLength) {
      return 'El correo no puede superar los 60 caracteres';
    }
    if (displayError == EmailError.format) return 'Correo eletrónico no valido';

    return null;
  }

  @override
  EmailError? validator(String value) {
    if (value.isEmpty) return null;
    if (value.length > 60) return EmailError.maxLength;
    if (!emailRegExp.hasMatch(value)) return EmailError.format;

    return null;
  }
}
