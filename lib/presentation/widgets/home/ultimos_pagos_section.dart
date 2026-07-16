import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/domain/domain.dart';

class UltimosPagosSection extends StatelessWidget {
  final List<UltimoPago> pagos;

  const UltimosPagosSection({super.key, required this.pagos});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Últimos pagos',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: colors.primary, fontWeight: FontWeight.bold),
          ),
        ),
        if (pagos.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No hay pagos registrados'),
          )
        else
          ...pagos.map((p) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: colors.primaryContainer,
                  child: Icon(Icons.payments, color: colors.onPrimaryContainer),
                ),
                title: Text(p.nombreCliente,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  '${HumanFormats.monuted(p.montoPagado)} — ${HumanFormats.date(p.fechaPagado)}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      HumanFormats.monuted(p.montoCapital),
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
                onTap: () =>
                    context.push('/home/0/prestamo/${p.idPrestamo}'),
              )),
        const Divider(),
      ],
    );
  }
}
