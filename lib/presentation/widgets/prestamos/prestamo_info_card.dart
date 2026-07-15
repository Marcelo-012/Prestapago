import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';

class PrestamoInfoCard extends StatelessWidget {
  final PrestamoDetalle detalle;

  const PrestamoInfoCard({super.key, required this.detalle});

  Color _chipColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'activo':
        return Colors.blueAccent;
      case 'pagado':
        return Colors.green;
      case 'atrasado':
        return Colors.orange;
      case 'cancelado':
        return Colors.red;
      case 'finalizado':
        return Colors.green;
      case 'nopagado':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _estadoPagosLabel(String estado) {
    switch (estado) {
      case 'completado':
        return 'Completado';
      case 'en_progreso':
        return 'En progreso';
      case 'pendiente':
        return 'Pendiente';
      case 'sin_amortizaciones':
        return 'Sin amortizaciones';
      default:
        return estado;
    }
  }

  @override
  Widget build(BuildContext context) {
    final det = detalle;
    final prestamo = det.prestamo;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    det.nombreDeudor,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    det.configuracionPrestamo.estadoPrestamo[0].toUpperCase() +
                        det.configuracionPrestamo.estadoPrestamo.substring(1),
                    style: const TextStyle(fontSize: 11, color: Colors.white),
                  ),
                  backgroundColor: _chipColor(
                    det.configuracionPrestamo.estadoPrestamo,
                  ),
                ),
              ],
            ),
            const Divider(),
            ResumenRow(label: 'Monto', value: HumanFormats.monuted(prestamo.monto)),
            ResumenRow(label: 'Plazo', value: '${prestamo.plazo} meses'),
            ResumenRow(
              label: 'Tasa interés',
              value: '${prestamo.tasaInteres}% ${det.configuracionPrestamo.periodidadIntereses == 'mensual' ? 'mensual' : 'anual'}',
            ),
            ResumenRow(
              label: 'Cuota mensual',
              value: HumanFormats.monuted(prestamo.montoCuota),
            ),
            if (prestamo.tasaInteresMoratoria > 0)
              ResumenRow(
                label: 'Tasa moratoria',
                value: '${prestamo.tasaInteresMoratoria}% ${det.configuracionPrestamo.periodidadIntereses == 'mensual' ? 'mensual' : 'anual'}',
              ),
            ResumenRow(
              label: 'Tipo interés',
              value: det.configuracionPrestamo.tipoInteres == 'compuesto' ? 'Compuesto' : 'Simple',
            ),
            ResumenRow(
              label: 'Estado pagos',
              value: _estadoPagosLabel(det.estadoPagos),
            ),
          ],
        ),
      ),
    );
  }
}
