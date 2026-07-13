import 'package:flutter_dotenv/flutter_dotenv.dart';

class BackupConstants {
  // Google Drive
  static const String driveScope =
      'https://www.googleapis.com/auth/drive.appdata';

  // Web client ID from Google Cloud Console (OAuth 2.0) - required on Android
  static String get googleServerClientId =>
      dotenv.env['GOOGLE_SERVER_CLIENT_ID'] ?? '';

  // Nombres de archivo
  static const String localDatabaseFilename = 'prestapago_db.sqlite';
  static const String backupFilePrefix = 'app_Prestapago_respaldo_';
  static const String backupFileExtension = '.db';

  // Retención
  static const int maxBackupsToKeep = 5;

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
  static const String keyUserName = 'user_name';
  static const String keyUserPhotoUrl = 'user_photo_url';
  static const String keyLastBackup = 'last_backup_time';
  static const String keyBackupStatus = 'backup_status';
  static const String keyBackupFrequency = 'backup_frequency';
}
