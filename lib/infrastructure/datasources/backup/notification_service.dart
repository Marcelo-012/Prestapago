import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:prestapagos/config/constants/constants.dart';

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  static Future<void> _show({
    required int id,
    required String title,
    required String body,
  }) async {
    if (!_initialized) await initialize();
    await _plugin.show(
      id,
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
  }

  static Future<void> showBackupSuccess() => _show(
    id: NotificationConstants.successNotificationId,
    title: 'Respaldo completado',
    body: 'El respaldo se ha realizado correctamente.',
  );

  static Future<void> showBackupFailure(String? reason) => _show(
    id: NotificationConstants.failureNotificationId,
    title: 'Respaldo fallido',
    body: reason ?? 'El respaldo no pudo completarse. Intenta de nuevo.',
  );

  static Future<void> showRestoreSuccess() => _show(
    id: NotificationConstants.successNotificationId,
    title: 'Restauración completada',
    body: 'Los datos se han restaurado correctamente.',
  );

  static Future<void> showRestoreFailure(String? reason) => _show(
    id: NotificationConstants.failureNotificationId,
    title: 'Restauración fallida',
    body: reason ?? 'La restauración no pudo completarse. Intenta de nuevo.',
  );
}
