import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:path_provider/path_provider.dart';

import 'package:prestapagos/config/constants/backup_constants.dart';
import 'package:prestapagos/config/router/app_router.dart';
import 'package:prestapagos/config/theme/app_theme.dart';
import 'package:prestapagos/infrastructure/database/database.dart';
import 'package:prestapagos/infrastructure/datasources/backup/local_backup_datasource.dart';
import 'package:prestapagos/infrastructure/datasources/backup/secure_storage_datasource.dart';
import 'package:prestapagos/infrastructure/datasources/google_auth_datasource.dart';
import 'package:prestapagos/infrastructure/datasources/google_drive_datasource.dart';
import 'package:prestapagos/infrastructure/repositories/backup/backup_repository_impl.dart';
import 'package:prestapagos/presentation/providers/config/config_providers.dart';
import 'package:prestapagos/presentation/providers/database/app_database_provider.dart';
import 'package:prestapagos/workmanager/callback_dispatcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await initializeDateFormatting('es_MX', null);

  final prefs = await SharedPreferences.getInstance();
  final localBackup = LocalBackupDatasource(prefs);
  final secureStorage = SecureStorageDatasource();
  final authDatasource = GoogleAuthDatasource(
    secureStorage: secureStorage,
    localBackupStorage: localBackup,
    serverClientId: BackupConstants.googleServerClientId,
  );
  final driveDatasource = GoogleDriveDatasource();
  final database = AppDatabase();

  final dir = await getApplicationSupportDirectory();
  final databaseFile = File('${dir.path}/${BackupConstants.localDatabaseFilename}');

  final backupRepository = BackupRepositoryImpl(
    authDatasource: authDatasource,
    driveDatasource: driveDatasource,
    localBackupDatasource: localBackup,
    secureStorageDatasource: secureStorage,
    databaseFile: databaseFile,
    database: database,
  );

  await Workmanager().initialize(callbackDispatcher);

  runApp(ProviderScope(
    overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
      localBackupDatasourceProvider.overrideWithValue(localBackup),
      googleAuthDatasourceProvider.overrideWithValue(authDatasource),
      appDatabaseProvider.overrideWithValue(database),
      backupRepositoryProvider.overrideWithValue(backupRepository),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final appTheme = AppTheme();

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: appTheme.getLightTheme(scheme: themeState.flexScheme),
      darkTheme: appTheme.getDarkTheme(scheme: themeState.flexScheme),
      themeMode: themeState.themeMode,
    );
  }
}
