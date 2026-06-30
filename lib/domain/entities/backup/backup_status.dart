enum BackupStatusEnum {
  idle('Inactivo'),
  authenticating('Autenticando...'),
  uploading('Subiendo respaldo...'),
  downloading('Descargando respaldo...'),
  validating('Validando integridad...'),
  restoring('Restaurando datos...'),
  success('Éxito'),
  failed('Falló'),
  canceled('Cancelado');

  final String displayName;
  const BackupStatusEnum(this.displayName);
}

class BackupStatus {
  final BackupStatusEnum status;
  final String message;
  final double? progress; // 0.0 a 1.0
  final DateTime? lastSuccessfulBackup;
  final String? errorCode;
  final DateTime timestamp;

  BackupStatus({
    required this.status,
    required this.message,
    this.progress,
    this.lastSuccessfulBackup,
    this.errorCode,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get isLoading =>
      status == BackupStatusEnum.uploading ||
      status == BackupStatusEnum.downloading ||
      status == BackupStatusEnum.validating ||
      status == BackupStatusEnum.restoring ||
      status == BackupStatusEnum.authenticating;

  bool get isSuccess => status == BackupStatusEnum.success;
  bool get isFailed => status == BackupStatusEnum.failed;
}
