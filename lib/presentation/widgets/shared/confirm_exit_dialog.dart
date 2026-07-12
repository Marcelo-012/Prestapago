import 'package:flutter/material.dart';

Future<bool> confirmarAccion(
  BuildContext context, {
  required String mensaje,
  String titulo = 'Confirmar acción',
  String textoConfirmar = 'Aceptar',
  String textoCancelar = 'Cancelar',
  bool esDestructivo = false,
}) async {
  final colors = Theme.of(context).colorScheme;

  final confirmado = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            textoCancelar,
            style: TextStyle(
              color: esDestructivo ? colors.error : null,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            textoConfirmar,
            style: TextStyle(
              color: esDestructivo ? colors.error : colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );

  return confirmado ?? false;
}
