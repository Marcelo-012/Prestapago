import 'package:flutter/material.dart';
import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/domain/domain.dart';

class AmortizacionTable extends StatefulWidget {
  final List<Amortizacion> amortizaciones;
  final double montoCuota;
  final void Function(Amortizacion) onViewPayment;

  const AmortizacionTable({
    super.key,
    required this.amortizaciones,
    required this.montoCuota,
    required this.onViewPayment,
  });

  @override
  State<AmortizacionTable> createState() => _AmortizacionTableState();
}

class _AmortizacionTableState extends State<AmortizacionTable> {
  bool _showFull = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tabla completa'),
            Switch(
              value: _showFull,
              onChanged: (v) => setState(() => _showFull = v),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _showFull ? _buildFullTable() : _buildCompactTable(),
        ),
      ],
    );
  }

  Widget _buildCompactTable() {
    return DataTable(
      columnSpacing: 12,
      columns: const [
        DataColumn(label: Text('#')),
        DataColumn(label: Text('Vencimiento')),
        DataColumn(label: Text('Cuota')),
        DataColumn(label: Text('Capital')),
        DataColumn(label: Text('Interés')),
        DataColumn(label: Text('Pagado')),
        DataColumn(label: Text('Excedente')),
        DataColumn(label: Text('Estado')),
        DataColumn(label: Text('')),
      ],
      rows:
          widget.amortizaciones.map((a) => _buildRow(a, full: false)).toList(),
    );
  }

  Widget _buildFullTable() {
    return DataTable(
      columnSpacing: 12,
      columns: const [
        DataColumn(label: Text('#')),
        DataColumn(label: Text('Vencimiento')),
        DataColumn(label: Text('Fecha pago')),
        DataColumn(label: Text('Monto inicial')),
        DataColumn(label: Text('Cuota')),
        DataColumn(label: Text('Capital')),
        DataColumn(label: Text('Interés')),
        DataColumn(label: Text('Pagado')),
        DataColumn(label: Text('Excedente')),
        DataColumn(label: Text('Días mora')),
        DataColumn(label: Text('Estado')),
        DataColumn(label: Text('')),
      ],
      rows: widget.amortizaciones.map((a) => _buildRow(a, full: true)).toList(),
    );
  }

  DataRow _buildRow(Amortizacion a, {required bool full}) {
    return DataRow(cells: [
      DataCell(Text('${a.idCuota}')),
      DataCell(
        Text(
          '${a.fechaVencimiento.day}/${a.fechaVencimiento.month}/${a.fechaVencimiento.year}',
        ),
      ),
      if (full)
        DataCell(
          Text(
            a.fechaPagado != null
                ? '${a.fechaPagado!.day}/${a.fechaPagado!.month}/${a.fechaPagado!.year}'
                : '—',
          ),
        ),
      DataCell(Text(HumanFormats.monuted(a.montoInicial))),
      if (full) DataCell(Text(HumanFormats.monuted(widget.montoCuota))),
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
      if (full) DataCell(Text('${a.diasMora}')),
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
            onPressed: () => widget.onViewPayment(a),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              textStyle: const TextStyle(fontSize: 11),
            ),
            child: const Text('Ver pago'),
          ),
        ),
      ),
    ]);
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
      case 'pendiente':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
