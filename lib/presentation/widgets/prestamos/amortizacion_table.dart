import 'package:flutter/material.dart';
import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/domain/domain.dart';

class AmortizacionTable extends StatelessWidget {
  final List<Amortizacion> amortizaciones;
  final void Function(Amortizacion) onViewPayment;

  const AmortizacionTable({
    super.key,
    required this.amortizaciones,
    required this.onViewPayment,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 12,
        columns: [
          const DataColumn(label: Text('#')),
          const DataColumn(label: Text('Vencimiento')),
          const DataColumn(label: Text('Cuota')),
          const DataColumn(label: Text('Capital')),
          const DataColumn(label: Text('Interés')),
          const DataColumn(label: Text('Pagado')),
          const DataColumn(label: Text('Excedente')),
          const DataColumn(label: Text('Estado')),
          const DataColumn(label: Text('')),
        ],
        rows: amortizaciones
            .map(
              (a) => DataRow(
                cells: [
                  DataCell(Text('${a.idCuota}')),
                  DataCell(
                    Text(
                      '${a.fechaVencimiento.day}/${a.fechaVencimiento.month}/${a.fechaVencimiento.year}',
                    ),
                  ),
                  DataCell(Text(HumanFormats.monuted(a.montoInicial))),
                  DataCell(Text(HumanFormats.monuted(a.montoCapital))),
                  DataCell(Text(HumanFormats.monuted(a.montoInteres))),
                  DataCell(
                    Text(
                      a.fechaPagado != null
                          ? HumanFormats.monuted(a.montoPagado)
                          : '—',
                    ),
                  ),
                  DataCell(
                    Text(
                      a.fechaPagado != null && a.montoExcedente >= 0.01
                          ? HumanFormats.monuted(a.montoExcedente)
                          : '—',
                    ),
                  ),
                  DataCell(
                    Chip(
                      label: Text(
                        a.estadoAmortizacion[0].toUpperCase() +
                            a.estadoAmortizacion.substring(1),
                        style: const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      backgroundColor: _chipColor(a.estadoAmortizacion),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      height: 28,
                      child: TextButton(
                        onPressed: null,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          textStyle: const TextStyle(fontSize: 11),
                        ),
                        child: const Text('Ver pago'),
                      ),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

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
}
