import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import 'clientes_detalles.dart';

class ClientesListItem extends StatelessWidget {
  final ClienteResumen cliente;
  final GestureTapCallback onTap;

  const ClientesListItem({
    super.key,
    required this.cliente,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isInactive = cliente.estado == 'inactivo';

    return Opacity(
      opacity: isInactive ? 0.45 : 1.0,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          child: ClientesDetalles(
            nombre: cliente.nombre,
            telefono: cliente.telefono,
            score: cliente.score,
            estado: cliente.estado,
          ),
        ),
      ),
    );
  }
}
