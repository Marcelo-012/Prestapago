import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/config/helpers/helpers.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';

class PrestamoInfoCard extends StatefulWidget {
  final PrestamoDetalle detalle;

  const PrestamoInfoCard({super.key, required this.detalle});

  @override
  State<PrestamoInfoCard> createState() => _PrestamoInfoCardState();
}

class _PrestamoInfoCardState extends State<PrestamoInfoCard> {
  bool _showMore = false;

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
    final det = widget.detalle;
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
                  child: AutoSizeText(
                    det.nombreDeudor,
                    maxLines: 3,
                    minFontSize: 12,
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
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Más detalles',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                Switch(
                  value: _showMore,
                  onChanged: (v) => setState(() => _showMore = v),
                ),
              ],
            ),
            if (_showMore) ...[
              ResumenRow(
                label: 'Estado moratorio',
                value: widget.detalle.configuracionPrestamo.estadoMoratorio ==
                        'activo'
                    ? 'Activo'
                    : 'Inactivo',
              ),
              ResumenRow(
                label: 'Manejo de excedente',
                value: widget.detalle.configuracionPrestamo.manejoExcedente ==
                        'saldoFavor'
                    ? 'Saldo a favor'
                    : 'Abono a capital',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
