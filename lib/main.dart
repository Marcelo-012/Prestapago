import 'dart:io';
import 'dart:ui';

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

Duration _delayUntil(int hour, int minute) {
  final now = DateTime.now();
  final target = DateTime(now.year, now.month, now.day, hour, minute);
  return target.isAfter(now)
      ? target.difference(now)
      : target.add(const Duration(hours: 24)).difference(now);
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Error no manejado: $error\n$stack');
    return true;
  };
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  try {
    await dotenv.load();
  } catch (e) {
    debugPrint('dotenv: $e');
  }

  try {
    await initializeDateFormatting('es_MX', null);
  } catch (e) {
    debugPrint('DateFormatting: $e');
  }

  try {
    await NotificationService.initialize();
  } catch (e) {
    debugPrint('NotificationService: $e');
  }

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

  try {
    await Workmanager().initialize(callbackDispatcher);
  } catch (e) {
    debugPrint('Workmanager init: $e');
  }

  await Workmanager().registerPeriodicTask(
    'dailyAmortizationUpdate',
    'dailyAmortizationUpdate',
    frequency: const Duration(hours: 24),
    initialDelay: _delayUntil(1, 0),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );

  final backupFreq = localBackup.getBackupFrequency();
  if (backupFreq != 'Manual') {
    final freq = backupFreq == 'weekly'
        ? const Duration(days: 7)
        : const Duration(hours: 24);
    await Workmanager().registerPeriodicTask(
      'autoBackup',
      'autoBackup',
      frequency: freq,
      initialDelay: _delayUntil(2, 30),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  }

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

  WidgetsBinding.instance.addPostFrameCallback((_) {
    FlutterNativeSplash.remove();
  });
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
