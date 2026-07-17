import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:prestapagos/config/helpers/helpers.dart';
import 'package:prestapagos/domain/domain.dart';

class ProximosVencimientosSection extends StatelessWidget {
  final List<ProximoVencimiento> vencimientos;

  const ProximosVencimientosSection({
    super.key,
    required this.vencimientos,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Próximos vencimientos',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: colors.primary, fontWeight: FontWeight.bold),
          ),
        ),
        if (vencimientos.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No hay cuotas pendientes'),
          )
        else
          ...vencimientos.map((v) {
            final isOverdue = v.diasMora > 0 || v.estado == 'atrasado';
            return ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    isOverdue ? Colors.red[50] : colors.tertiaryContainer,
                child: Icon(
                  isOverdue ? Icons.warning_amber : Icons.schedule,
                  color: isOverdue ? Colors.red : colors.onTertiaryContainer,
                ),
              ),
              title: Text(v.nombreCliente,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                '${HumanFormats.date(v.fechaVencimiento)} — ${HumanFormats.monuted(v.totalCuota)}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isOverdue)
                    Chip(
                      label: Text('${v.diasMora}d',
                          style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.red[50],
                      visualDensity: VisualDensity.compact,
                    ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
              onTap: () =>
                  context.push('/home/0/prestamo/${v.idPrestamo}'),
            );
          }),
        const Divider(),
      ],
    );
  }
}
