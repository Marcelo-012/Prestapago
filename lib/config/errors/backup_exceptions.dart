class BackupException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  BackupException({required this.message, this.code, this.originalError});

  @override
  String toString() => 'BackupException: $message (Code: $code)';
}

class NoInternetException extends BackupException {
  NoInternetException()
    : super(
        message: 'Sin conexión a internet. Reintenta cuando tengas conexión.',
        code: 'NO_INTERNET',
      );
}

class LowBatteryException extends BackupException {
  LowBatteryException()
    : super(
        message: 'Batería baja (<10%). Conecta el cargador antes de respaldar.',
        code: 'LOW_BATTERY',
      );
}

class AuthenticationFailedException extends BackupException {
  AuthenticationFailedException(String reason)
    : super(message: 'Error de autenticación: $reason', code: 'AUTH_FAILED');
}

class BackupCancelledException extends BackupException {
  BackupCancelledException()
    : super(message: 'Respaldo cancelado por el usuario.', code: 'CANCELLED');
}

class CorruptedBackupException extends BackupException {
  CorruptedBackupException()
    : super(
        message: 'El archivo de respaldo está corrupto o es inválido.',
        code: 'CORRUPTED',
      );
}

class DiskSpaceException extends BackupException {
  DiskSpaceException()
    : super(
        message: 'Espacio insuficiente en el dispositivo.',
        code: 'NO_SPACE',
      );
}

class UnknownBackupException extends BackupException {
  UnknownBackupException(dynamic error, StackTrace stackTrace)
    : super(
        message: 'Error desconocido durante el respaldo.',
        code: 'UNKNOWN',
        originalError: error,
      );
}
