import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/entities/entities.dart';
import 'package:prestapagos/presentation/providers/reportes/reporte_card_provider.dart';

import '../widgets/widgets.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardHomeAsyncValue = ref.watch(reporteCardProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
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
                Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: Text(
                        'Resumen de tu actividad',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      tooltip: 'Agregar nuevo prestamo',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                cardHomeAsyncValue.when(
                  loading: () =>
                      const LoadingWidgetCustom(mensaje: 'Cargando resumen...'),
                  error: (error, stackTrace) => ErrorWidgetCustom(
                    error: error,
                    onRetry: () => ref.refresh(reporteCardProvider),
                  ),
                  data: (cardsHome) => _HomeCards(cardsHome: cardsHome),
                ),
              ],
            );
          }, childCount: 1),
        ),
      ],
    );
  }
}

class _HomeCards extends StatelessWidget {
  final ReporteCard cardsHome;

  const _HomeCards({required this.cardsHome});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardResumo(
          titulo: 'Total prestado',
          valor: cardsHome.totalPrestado ?? 0.00,
          color: Colors.yellow[700],
        ),
        const SizedBox(height: 20),
        CardResumo(
          titulo: 'Total cobrado',
          valor: cardsHome.totalPagado ?? 0.00,
          color: Colors.green[700],
        ),
        const SizedBox(height: 20),
        CardResumo(
          titulo: 'Total pendiente',
          valor: cardsHome.totalPendiente ?? 0.00,
          color: Colors.red,
        ),
      ],
    );
  }
}
