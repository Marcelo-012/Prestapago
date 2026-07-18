import 'package:flutter/material.dart';
import 'package:prestapagos/config/helpers/helpers.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';

class PaymentInfoCard extends StatelessWidget {
  final PrestamoDetalle detalle;
  final Amortizacion prox;
  final ({
    double montoCuota,
    double montoMora,
    int diasMora,
    double saldoAFavor,
    double totalMinimo,
    double montoMaximo,
  }) preview;
  final ColorScheme colors;

  const PaymentInfoCard({
    super.key,
    required this.detalle,
    required this.prox,
    required this.preview,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoRow(
              label: 'Cliente',
              value: detalle.nombreDeudor,
              icon: Icons.person,
              color: colors.primary,
            ),
            const Divider(),
            InfoRow(
              label: 'Cuota #${prox.idCuota}',
              icon: Icons.confirmation_number,
              color: colors.primary,
            ),
            const Divider(),
            InfoRow(
              label: 'Vencimiento',
              value: HumanFormats.date(prox.fechaVencimiento),
              icon: Icons.calendar_today,
              color: colors.primary,
            ),
            const Divider(),
            InfoRow(
              label: 'Fecha de pago',
              value: HumanFormats.date(DateTime.now()),
              icon: Icons.event,
              color: colors.primary,
            ),
            if (preview.diasMora > 0) ...[
              const Divider(),
              InfoRow(
                label: 'Días de mora',
                value: '${preview.diasMora} días',
                icon: Icons.warning_amber,
                color: Colors.orange,
              ),
              const Divider(),
              InfoRow(
                label: 'Cobro por atraso',
                value: HumanFormats.monuted(preview.montoMora),
                icon: Icons.attach_money,
                color: Colors.red,
              ),
            ],
            const Divider(),
            InfoRow(
              label: 'Monto cuota',
              value: HumanFormats.monuted(preview.montoCuota),
              icon: Icons.money,
              color: colors.primary,
            ),
            if (preview.saldoAFavor > 0) ...[
              const Divider(),
              InfoRow(
                label: 'Saldo a favor',
                value: '-${HumanFormats.monuted(preview.saldoAFavor)}',
                icon: Icons.credit_score,
                color: Colors.green,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
