import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/config/helpers/human_formats.dart';

class ProgressCard extends StatelessWidget {
  final double montoPrestamo;
  final double capitalPagado;
  final int cuotasPagadas;
  final int cuotasTotales;

  const ProgressCard({
    super.key,
    required this.montoPrestamo,
    required this.capitalPagado,
    required this.cuotasPagadas,
    required this.cuotasTotales,
  });

  @override
  Widget build(BuildContext context) {
    final progreso = cuotasTotales > 0 ? cuotasPagadas / cuotasTotales : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cuotas pagadas',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  HumanFormats.monuted(montoPrestamo),
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                Text(
                  '$cuotasPagadas / $cuotasTotales',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${HumanFormats.monuted(capitalPagado)} pagados de ${HumanFormats.monuted(montoPrestamo)}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progreso,
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  progreso >= 1.0 ? Colors.green : Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
