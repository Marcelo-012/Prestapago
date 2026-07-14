import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/domain/entities/dtos/prestamos/prestamo_detalle.dart';
import 'package:prestapagos/presentation/providers/prestamos/prestamo_provider.dart';

class PagoDialog extends ConsumerStatefulWidget {
  final PrestamoDetalle detalle;

  const PagoDialog({super.key, required this.detalle});

  @override
  ConsumerState<PagoDialog> createState() => _PagoDialogState();
}

class _PagoDialogState extends ConsumerState<PagoDialog> {
  late TextEditingController _montoController;
  late TextEditingController _fechaController;
  DateTime _fechaPago = DateTime.now();

  @override
  void initState() {
    super.initState();
    _montoController = TextEditingController(
      text: widget.detalle.amortizaciones
          .firstWhere((a) => a.estadoAmortizacion == 'noPagado')
          .montoInicial
          .toStringAsFixed(2),
    );
    _fechaController = TextEditingController(
      text: '${_fechaPago.day}/${_fechaPago.month}/${_fechaPago.year}',
    );
  }

  @override
  void dispose() {
    _montoController.dispose();
    _fechaController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _fechaPago,
      firstDate: widget.detalle.amortizaciones
          .firstWhere((a) => a.estadoAmortizacion == 'noPagado')
          .fechaVencimiento,
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _fechaPago = date;
        _fechaController.text = '${date.day}/${date.month}/${date.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final prox = widget.detalle.amortizaciones
        .firstWhere((a) => a.estadoAmortizacion == 'noPagado');

    return AlertDialog(
      title: Text('Registrar pago', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cuota #${prox.idCuota}', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 8),
            Text('Vencimiento: ${prox.fechaVencimiento.day}/${prox.fechaVencimiento.month}/${prox.fechaVencimiento.year}',
              style: GoogleFonts.poppins()),
            if (prox.diasMora > 0) ...[
              const SizedBox(height: 4),
              Text('Días de mora: ${prox.diasMora}',
                style: GoogleFonts.poppins(color: Colors.orange)),
              Text('Monto mora: ${HumanFormats.monuted(prox.montoMora)}',
                style: GoogleFonts.poppins(color: Colors.orange)),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: _montoController,
              decoration: const InputDecoration(
                labelText: 'Monto a pagar',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _fechaController,
              decoration: const InputDecoration(
                labelText: 'Fecha de pago',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: _selectDate,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () async {
            final monto = double.tryParse(_montoController.text);
            if (monto == null || monto <= 0) {
              Fluttertoast.showToast(msg: 'Ingresa un monto válido', gravity: ToastGravity.TOP);
              return;
            }
            try {
              await ref.read(prestamoRepositoryProvider).registrarPago(
                widget.detalle.idPrestamo, monto, _fechaPago,
              );
              if (!context.mounted) return;
              Navigator.pop(context);
              Fluttertoast.showToast(msg: 'Pago registrado exitosamente', gravity: ToastGravity.TOP);
              ref.invalidate(prestamoDetalleProvider(widget.detalle.idPrestamo));
              ref.invalidate(prestamoPaginationProvider);
            } catch (e) {
              if (!context.mounted) return;
              Fluttertoast.showToast(msg: 'Error al registrar el pago', gravity: ToastGravity.TOP);
            }
          },
          child: const Text('Registrar pago'),
        ),
      ],
    );
  }
}
