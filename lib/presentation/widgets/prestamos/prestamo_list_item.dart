import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/domain/domain.dart';

class PrestamoListItem extends StatelessWidget {
  final PrestamoResumen prestamo;
  final VoidCallback onTap;

  const PrestamoListItem({
    super.key,
    required this.prestamo,
    required this.onTap,
  });

  String _estadoLabel(String estado) {
    switch (estado) {
      case 'activo':
        return 'Al día';
      case 'atrasado':
        return 'Atrasado';
      case 'finalizado':
        return 'Finalizado';
      case 'cancelado':
        return 'Cancelado';
      case 'inactivo':
        return 'Inactivo';
      default:
        return estado[0].toUpperCase() + estado.substring(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = GoogleFonts.poppins();
    final isInactive = prestamo.estadoPrestamo == 'inactivo';

    return Opacity(
      opacity: isInactive ? 0.45 : 1.0,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              const SizedBox(width: 5),
              CircleAvatar(
                backgroundColor: colors.primary,
                child: Text(
                  prestamo.nombre.isNotEmpty
                      ? prestamo.nombre[0].toUpperCase()
                      : '?',
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
                          child: Text(
                            prestamo.nombre,
                            style: textTheme.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(
                            _estadoLabel(prestamo.estadoPrestamo),
                            style: textTheme.copyWith(fontSize: 12),
                          ),
                          backgroundColor: prestamo.estadoPrestamo == 'activo'
                              ? Colors.blue[100]
                              : prestamo.estadoPrestamo == 'atrasado'
                              ? Colors.orange[100]
                              : Colors.grey[200],
                          labelStyle: TextStyle(
                            color: prestamo.estadoPrestamo == 'activo'
                                ? Colors.blue
                                : prestamo.estadoPrestamo == 'atrasado'
                                ? Colors.orange
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          HumanFormats.monuted(prestamo.monto),
                          style: textTheme.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.schedule, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${prestamo.plazo} meses',
                          style: textTheme.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${HumanFormats.monuted(prestamo.totalPagado)} pagados de ${HumanFormats.monuted(prestamo.monto)}',
                      style: textTheme.copyWith(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: prestamo.monto > 0
                            ? (prestamo.totalPagado / prestamo.monto).clamp(
                                0.0,
                                1.0,
                              )
                            : 0,
                        minHeight: 6,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          prestamo.totalPagado >= prestamo.monto - 0.001
                              ? Colors.green
                              : Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 24, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
