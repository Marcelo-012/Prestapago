import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prestapagos/presentation/providers/pagos/pago_submit_provider.dart';
import 'package:prestapagos/presentation/widgets/pagos/pago_text_field.dart';

class PagoActionButtons extends StatelessWidget {
  final PagoSubmitStatus submitStatus;
  final bool cubierto;
  final bool isFormValid;
  final TextEditingController montoController;
  final VoidCallback onPagarCero;
  final VoidCallback onPagar;

  const PagoActionButtons({
    super.key,
    required this.submitStatus,
    required this.cubierto,
    required this.isFormValid,
    required this.montoController,
    required this.onPagarCero,
    required this.onPagar,
  });

  @override
  Widget build(BuildContext context) {
    if (submitStatus == PagoSubmitStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cubierto) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onPagarCero,
                  icon: const Icon(Icons.payment),
                  label: const Text(
                    'Pagar \$0',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    final monto = double.tryParse(montoController.text) ?? 0;
                    if (monto <= 0) {
                      Fluttertoast.showToast(
                        msg: 'Ingresa un monto para abonar',
                      );
                      return;
                    }
                    onPagar();
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text(
                    'Abonar',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          PagoTextField(
            controller: montoController,
            label: 'Abono extra',
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: isFormValid ? onPagar : null,
        icon: const Icon(Icons.payment),
        label: const Text(
          'Pagar',
          style: TextStyle(fontSize: 16),
        ),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
