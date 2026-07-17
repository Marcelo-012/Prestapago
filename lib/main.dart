import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:path_provider/path_provider.dart';

import 'package:prestapagos/config/constants/constants.dart';
import 'package:prestapagos/config/router/router.dart';
import 'package:prestapagos/config/theme/theme.dart';
import 'package:prestapagos/infrastructure/database/database_index.dart';
import 'package:prestapagos/infrastructure/datasources/datasources.dart';
import 'package:prestapagos/infrastructure/repositories/repositories.dart';
import 'package:prestapagos/presentation/providers/providers.dart';
import 'package:prestapagos/workmanager/workmanager.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load();
  await initializeDateFormatting('es_MX', null);
  await NotificationService.initialize();

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

  try {
    final deudores = await database.select(database.deudores).get();
    if (deudores.isEmpty) {
      await seedDatabase(database);
    }
  } catch (e, st) {
    debugPrint('Error al sembrar datos: $e\n$st');
  }

  final dir = await getApplicationSupportDirectory();
  final databaseFile = File(
    '${dir.path}/${BackupConstants.localDatabaseFilename}',
  );

  final backupRepository = BackupRepositoryImpl(
    authDatasource: authDatasource,
    driveDatasource: driveDatasource,
    localBackupDatasource: localBackup,
    secureStorageDatasource: secureStorage,
    databaseFile: databaseFile,
    database: database,
  );

  await Workmanager().initialize(callbackDispatcher);

  final now = DateTime.now();
  final oneAm = DateTime(now.year, now.month, now.day + 1, 1);
  await Workmanager().registerPeriodicTask(
    'dailyAmortizationUpdate',
    'dailyAmortizationUpdate',
    frequency: const Duration(hours: 24),
    initialDelay: oneAm.difference(now),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );

  final backupFreq = localBackup.getBackupFrequency();
  if (backupFreq != 'Manual') {
    final twoThirtyAm = DateTime(now.year, now.month, now.day + 1, 2, 30);
    final freq = backupFreq == 'weekly'
        ? const Duration(days: 7)
        : const Duration(hours: 24);
    await Workmanager().registerPeriodicTask(
      'autoBackup',
      'autoBackup',
      frequency: freq,
      initialDelay: twoThirtyAm.difference(now),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  }
  FlutterNativeSplash.remove();
  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        localBackupDatasourceProvider.overrideWithValue(localBackup),
        secureStorageDatasourceProvider.overrideWithValue(secureStorage),
        googleAuthDatasourceProvider.overrideWithValue(authDatasource),
        appDatabaseProvider.overrideWithValue(database),
        backupRepositoryProvider.overrideWithValue(backupRepository),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final appTheme = AppTheme();
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: appTheme.getLightTheme(scheme: themeState.flexScheme),
      darkTheme: appTheme.getDarkTheme(scheme: themeState.flexScheme),
      themeMode: themeState.themeMode,
    );
  }
}
