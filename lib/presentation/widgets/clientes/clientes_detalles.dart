import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Accion {
  final IconData icono;
  final VoidCallback onPressed;
  final String? tooltip;

  const Accion({required this.icono, required this.onPressed, this.tooltip});
}

class ClientesDetalles extends StatelessWidget {
  final String nombre;
  final String? telefono;
  final double score;
  final String? estado;
  final List<Accion> acciones;

  const ClientesDetalles({
    super.key,
    required this.nombre,
    this.telefono,
    required this.score,
    this.estado,
    this.acciones = const [],
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final poppins = GoogleFonts.poppins();

    return Row(
      children: [
        const SizedBox(width: 5),
        CircleAvatar(
          backgroundColor: colors.primary,
          child: Text(
            nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          nombre,
                          style: poppins.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          minFontSize: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (telefono != null && telefono!.isNotEmpty)
                          Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  telefono ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: poppins.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      estado ?? 'Desconocido',
                      style: poppins.copyWith(fontSize: 12),
                    ),
                    backgroundColor: estado?.toLowerCase() == 'activo'
                        ? Colors.blue[100]
                        : Colors.grey[200],
                    labelStyle: TextStyle(
                      color: estado?.toLowerCase() == 'activo'
                          ? Colors.blue
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  _buildStarts(score),
                  const SizedBox(width: 8),
                  AutoSizeText(
                    '${score.toStringAsFixed(0)}/100',
                    style: poppins.copyWith(
                      fontSize: 12,

                      fontWeight: FontWeight.bold,
                      color: _getColorCalificacion(score),
                    ),
                    maxLines: 2,
                    maxFontSize: 12,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: AutoSizeText(
                      _getCalificacion(score),
                      style: poppins.copyWith(
                        fontSize: 12,
                        color: _getColorCalificacion(score),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: score / 100,
                  minHeight: 6,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getColorBarra(score),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: acciones.isEmpty
              ? const Icon(
                  Icons.arrow_forward_ios,
                  size: 24,
                  color: Colors.grey,
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: acciones
                        .map(
                          (accion) => IconButton(
                            onPressed: accion.onPressed,
                            icon: Icon(accion.icono),
                            tooltip: accion.tooltip,
                          ),
                        )
                        .toList(),
                  ),
                ),
        ),
      ],
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
