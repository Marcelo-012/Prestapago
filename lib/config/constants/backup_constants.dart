class BackupConstants {
  // Google Drive
  static const String driveScope =
      'https://www.googleapis.com/auth/drive.appdata';
  static const String backupFolder = 'PRESTAPAGO_Backups';
  static const String databaseFilename = 'prestapago_db.db';

  // Timeouts
  static const Duration uploadTimeout = Duration(minutes: 10);
  static const Duration downloadTimeout = Duration(minutes: 10);
  static const Duration authTimeout = Duration(minutes: 2);

  // Battery & Network
  static const int minBatteryPercent = 10;
  static const int mobileDataWarningMb = 50;

  // Reintentos
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 5);

  // SharedPreferences keys
  static const String keyAccountLinked = 'account_linked';
  static const String keyUserEmail = 'user_email';
  static const String keyLastBackup = 'last_backup_time';
  static const String keyBackupStatus = 'backup_status';
  static const String keyBackupFrequency = 'backup_frequency';
}
