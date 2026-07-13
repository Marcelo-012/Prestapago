import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prestapagos/config/constants/backup_constants.dart';
import 'package:prestapagos/infrastructure/datasources/backup/local_backup_datasource.dart';
import 'package:prestapagos/infrastructure/datasources/backup/secure_storage_datasource.dart';
import 'package:prestapagos/infrastructure/datasources/google_auth_datasource.dart';
import 'package:prestapagos/infrastructure/datasources/google_drive_datasource.dart';
import 'package:prestapagos/infrastructure/repositories/backup/backup_repository_impl.dart';

const _autoBackupTaskName = 'autoBackup';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task != _autoBackupTaskName) return false;

    try {
      await dotenv.load();
      final prefs = await SharedPreferences.getInstance();
      final localBackup = LocalBackupDatasource(prefs);

      final frequency = localBackup.getBackupFrequency();
      if (frequency == 'Manual') return true;

      final secureStorage = SecureStorageDatasource();
      final accessToken = secureStorage.getAccessTokenFromMemory();
      if (accessToken == null) return false;

      final authDatasource = GoogleAuthDatasource(
        secureStorage: secureStorage,
        localBackupStorage: localBackup,
        serverClientId: BackupConstants.googleServerClientId,
      );

      final freshToken = await authDatasource.silentlyRefreshAccessToken();
      if (freshToken == null) return false;

      final driveDatasource = GoogleDriveDatasource();
      await driveDatasource.initialize(freshToken);

      final dir = await getApplicationSupportDirectory();
      final databaseFile = File('${dir.path}/${BackupConstants.localDatabaseFilename}');

      final repository = BackupRepositoryImpl(
        authDatasource: authDatasource,
        driveDatasource: driveDatasource,
        localBackupDatasource: localBackup,
        secureStorageDatasource: secureStorage,
        databaseFile: databaseFile,
      );

      await for (final _ in repository.performBackup()) {}

      return true;
    } catch (_) {
      return false;
    }
  });
}
