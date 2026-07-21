import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool?> showNotificationPermissionDialog(
  BuildContext context,
) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('¿Recibir notificaciones?'),
      content: const Text(
        'Te notificaremos cuando tengas cuotas por vencer '
        'para que no olvides ningún pago.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Ahora no'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Sí, notificarme'),
        ),
      ],
    ),
  );
}

Future<void> showGoToSettingsDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Permiso necesario'),
      content: const Text(
        'Para recibir notificaciones, activa el permiso '
        'desde los Ajustes del sistema.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Abrir Ajustes'),
        ),
      ],
    ),
  );

  if (result == true) {
    await openAppSettings();
  }
}
