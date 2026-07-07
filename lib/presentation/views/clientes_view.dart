import 'package:flutter/material.dart';

class ClientesView extends StatelessWidget {
  const ClientesView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'Clientes',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: colors.primary),
            ),
            titlePadding: EdgeInsets.zero,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(children: [const SizedBox(height: 50)]);
          }, childCount: 1),
        ),
      ],
    );
  }
}
