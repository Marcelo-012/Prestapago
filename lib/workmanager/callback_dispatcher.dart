import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:workmanager/workmanager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prestapagos/config/constants/constants.dart';
import 'package:prestapagos/infrastructure/datasources/datasources.dart';
import 'package:prestapagos/infrastructure/repositories/repositories.dart';

const _autoBackupTaskName = 'autoBackup';
const _dailyTaskName = 'dailyAmortizationUpdate';

final _notifications = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == _dailyTaskName) {
      try {
        await dotenv.load();

        const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
        const initSettings = InitializationSettings(android: androidSettings);
        await _notifications.initialize(initSettings);

        final dir = await getApplicationSupportDirectory();
        final db = sqlite3.open('${dir.path}/${BackupConstants.localDatabaseFilename}');

        db.execute("""
          UPDATE amortizaciones SET
            estado_amortizacion = 'atrasado',
            dias_mora = CAST(julianday('now') - julianday(fecha_vencimiento, 'unixepoch') AS INTEGER)
          WHERE estado_amortizacion IN ('pendiente', 'atrasado')
            AND date(fecha_vencimiento, 'unixepoch') < date('now')
        """);

        db.execute("""
          UPDATE configuracion_prestamos SET estado_prestamo = 'atrasado'
          WHERE id_prestamo IN (
            SELECT DISTINCT id_prestamo FROM amortizaciones
            WHERE estado_amortizacion = 'atrasado'
          )
          AND estado_prestamo NOT IN ('finalizado', 'cancelado')
        """);

        db.execute("""
          UPDATE configuracion_prestamos SET
            estado_prestamo = 'finalizado',
            fecha_actualizacion = CAST(strftime('%s', 'now') AS INTEGER)
          WHERE estado_prestamo NOT IN ('finalizado', 'cancelado')
            AND (
              SELECT COUNT(*) FROM amortizaciones a
              WHERE a.id_prestamo = configuracion_prestamos.id_prestamo
                AND a.estado_amortizacion NOT IN ('pagado', 'cancelado')
            ) = 0
            AND (
              SELECT COALESCE(SUM(a.monto_capital), 0) FROM amortizaciones a
              WHERE a.id_prestamo = configuracion_prestamos.id_prestamo
                AND a.estado_amortizacion = 'pagado'
            ) >= (SELECT COALESCE(p.monto, 0) FROM prestamos p WHERE p.id_prestamo = configuracion_prestamos.id_prestamo)
        """);

        db.execute("""
          UPDATE configuracion_prestamos SET
            estado_prestamo = 'atrasado',
            fecha_actualizacion = CAST(strftime('%s', 'now') AS INTEGER)
          WHERE estado_prestamo = 'activo'
            AND EXISTS (
              SELECT 1 FROM amortizaciones a
              WHERE a.id_prestamo = configuracion_prestamos.id_prestamo
                AND a.estado_amortizacion = 'atrasado'
            )
        """);

        db.execute("""
          UPDATE configuracion_prestamos SET
            estado_prestamo = 'activo',
            fecha_actualizacion = CAST(strftime('%s', 'now') AS INTEGER)
          WHERE estado_prestamo = 'atrasado'
            AND NOT EXISTS (
              SELECT 1 FROM amortizaciones a
              WHERE a.id_prestamo = configuracion_prestamos.id_prestamo
                AND a.estado_amortizacion = 'atrasado'
            )
        """);

        final atrasados = db.select("""
          SELECT COUNT(DISTINCT id_prestamo) AS total
          FROM amortizaciones WHERE estado_amortizacion = 'atrasado'
        """);
        final totalAtrasados = atrasados.first['total'] as int;

        final body = totalAtrasados > 0
            ? '$totalAtrasados préstamo(s) con atraso.'
            : 'Sin préstamos con atraso.';

        await _notifications.show(
          NotificationConstants.dailyUpdateNotificationId,
          'Actualización diaria',
          body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              NotificationConstants.channelDailyId,
              NotificationConstants.channelDailyName,
              channelDescription: NotificationConstants.channelDailyDescription,
              importance: Importance.defaultImportance,
              priority: Priority.defaultPriority,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );

        db.close();
        return true;
      } catch (_) {
        return false;
      }
    }

    if (task != _autoBackupTaskName) return false;

    try {
      await dotenv.load();

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidSettings);
      await _notifications.initialize(initSettings);

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

      await localBackup.setLastBackupTime(DateTime.now());
      await localBackup.setBackupStatus('Exitoso');

      await _notifications.show(
        NotificationConstants.successNotificationId,
        'Respaldo completado',
        'El respaldo automático se ha realizado correctamente.',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            NotificationConstants.channelId,
            NotificationConstants.channelName,
            channelDescription: NotificationConstants.channelDescription,
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );

      return true;
    } catch (e) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final localBackup = LocalBackupDatasource(prefs);
        await localBackup.setBackupStatus('Falló');

        final isQuota = e.toString().contains('STORAGE_QUOTA_EXCEEDED');
        final title = isQuota ? 'Almacenamiento lleno' : 'Respaldo fallido';
        final body = isQuota
            ? 'El respaldo automático no pudo completarse porque tu Google Drive está lleno. Libera espacio e intenta de nuevo.'
            : 'El respaldo automático no pudo completarse. Revisa tu conexión e intenta de nuevo.';

        await _notifications.show(
          NotificationConstants.failureNotificationId,
          title,
          body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              NotificationConstants.channelId,
              NotificationConstants.channelName,
              channelDescription: NotificationConstants.channelDescription,
              importance: Importance.defaultImportance,
              priority: Priority.defaultPriority,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      } catch (_) {}

      return false;
    }
  });
}
