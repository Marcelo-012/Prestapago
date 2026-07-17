import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';

class MejoresClientesSection extends StatelessWidget {
  final List<ClienteResumen> clientes;

  const MejoresClientesSection({super.key, required this.clientes});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Mejores clientes',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: colors.primary, fontWeight: FontWeight.bold),
          ),
        ),
        if (clientes.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No hay clientes registrados'),
          )
        else
          ...clientes.map((c) => ClientesListItem(
                cliente: c,
                onTap: () =>
                    context.push('/home/0/cliente/${c.idDeudor}'),
              )),
        const Divider(),
      ],
    );
  }
}
