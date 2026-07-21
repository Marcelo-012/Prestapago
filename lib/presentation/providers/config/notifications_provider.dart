import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:prestapagos/presentation/providers/config/theme_provider.dart';

enum NotificacionesEstado { neverAsked, declined, enabled }

class NotificacionesNotifier extends Notifier<NotificacionesEstado> {
  static const _key = 'notificaciones_estado';

  @override
  NotificacionesEstado build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final raw = prefs.getString(_key);
    if (raw == null) return NotificacionesEstado.neverAsked;
    return NotificacionesEstado.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => NotificacionesEstado.neverAsked,
    );
  }

  Future<void> aceptar() async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setString(_key, NotificacionesEstado.enabled.name);
    state = NotificacionesEstado.enabled;
  }

  Future<void> rechazar() async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setString(_key, NotificacionesEstado.declined.name);
    state = NotificacionesEstado.declined;
  }
}

final notificacionesProvider =
    NotifierProvider<NotificacionesNotifier, NotificacionesEstado>(
  NotificacionesNotifier.new,
);
