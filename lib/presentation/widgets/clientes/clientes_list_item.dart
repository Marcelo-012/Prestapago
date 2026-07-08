import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';

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
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        child: Row(
          children: [
            //Avatar
            CircleAvatar(
              backgroundColor: colors.primary,
              child: Text(
                cliente.nombre[0].toUpperCase(),
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cliente.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),

                  //Telefono
                  Row(
                    children: [
                      Icon(Icons.phone, size: 14, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        cliente.telefono,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  //Estrellas, score, calificacion
                  Row(
                    children: [
                      _buildStarts(cliente.score),
                      const SizedBox(width: 8),
                      Text(
                        '${cliente.score.toStringAsFixed(0)}/100',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getCalificacion(cliente.score),
                        style: TextStyle(
                          fontSize: 12,
                          color: _getColorCalificacion(cliente.score),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  //
                  const SizedBox(height: 8),

                  //Barra progreso
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: cliente.score / 100,
                      minHeight: 6,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getColorBarra(cliente.score),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  //Chip de estado
                ],
              ),
            ),
            const SizedBox(width: 16),

            Chip(
              label: Text(cliente.estado, style: const TextStyle(fontSize: 12)),
              backgroundColor: cliente.estado.toLowerCase() == 'activo'
                  ? Colors.blue[100]
                  : Colors.grey[200],
              labelStyle: TextStyle(
                color: cliente.estado.toLowerCase() == 'activo'
                    ? Colors.blue
                    : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 24,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarts(double score) {
    final normalizedScore = score.clamp(0, 100);
    int fullStarts = ((normalizedScore / 20).floor()).clamp(0, 5);
    int halfStarts = ((normalizedScore % 20) >= 10 && fullStarts < 5) ? 1 : 0;
    int emptyStarts = (5 - fullStarts - halfStarts).clamp(0, 5);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(
          fullStarts,
          (_) => Icon(Icons.star, color: Colors.amber.shade600, size: 14),
        ),
        if (halfStarts > 0)
          Icon(Icons.star, color: Colors.amber.shade600, size: 14),
        ...List.generate(
          emptyStarts,
          (_) =>
              Icon(Icons.star_outlined, color: Colors.grey.shade300, size: 14),
        ),
      ],
    );
  }

  String _getCalificacion(double score) {
    if (score >= 80) return 'Excelente';
    if (score >= 60) return 'Bueno';
    if (score >= 40) return 'Regular';
    return 'Malo';
  }

  Color _getColorCalificacion(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    if (score >= 40) return Colors.yellow;
    return Colors.red;
  }

  Color _getColorBarra(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    if (score >= 40) return Colors.yellow;
    return Colors.red;
  }
}
