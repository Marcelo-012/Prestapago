import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          //
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
            titlePadding: EdgeInsets.zero,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                Text('Resumen de tu actividad'),

                SizedBox(height: 20),

                CardItem(
                  onTap: () {
                    // Acción al hacer clic en la tarjeta
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: const Text('Card tocado')),
                    );
                  },
                  title: 'Total prestado',
                  subtitle: '10,000',
                  text: 'Card Prestamos activos',
                  colortext: Colors.yellow[700],
                ),
                const SizedBox(height: 20),
                CardItem(
                  onTap: () {
                    // Acción al hacer clic en la tarjeta
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: const Text('Card tocado')),
                    );
                  },
                  title: 'Total cobrado',
                  subtitle: '5,000',
                  text: 'Card Prestamos cobrados',
                  colortext: Colors.green[700],
                ),
                const SizedBox(height: 20),
                CardItem(
                  onTap: () {
                    // Acción al hacer clic en la tarjeta
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: const Text('Card tocado')),
                    );
                  },
                  title: 'Total pendiente',
                  subtitle: '5,000',
                  text: 'Card Prestamos pendientes',
                  colortext: Colors.red,
                ),
              ],
            );
          }, childCount: 1),
        ),
      ],
    );
  }
}
