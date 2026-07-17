import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/providers.dart';

import '../widgets/widgets.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardHomeAsyncValue = ref.watch(reporteCardProvider);
    final homeDataAsyncValue = ref.watch(homeDataProvider);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const CustomAppbar(icon: Icons.monetization_on_outlined),
            titlePadding: EdgeInsets.zero,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Resumen de tu actividad',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () => context.push('/create-prestamo'),
                      icon: const Icon(Icons.add_card_outlined),
                      tooltip: 'Nuevo préstamo',
                    ),
                    const SizedBox(width: 4),
                    IconButton.filledTonal(
                      onPressed: () => context.push('/create-cliente'),
                      icon: const Icon(Icons.person_add),
                      tooltip: 'Nuevo cliente',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                cardHomeAsyncValue.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, s) => const SizedBox.shrink(),
                  data: (cardsHome) => _EsteMesCards(cardsHome: cardsHome),
                ),
                const SizedBox(height: 24),
                homeDataAsyncValue.when(
                  loading: () => const LoadingWidgetCustom(
                    mensaje: 'Cargando actividad...',
                  ),
                  error: (error, stackTrace) => ErrorWidgetCustom(
                    error: error,
                    onRetry: () => ref.refresh(homeDataProvider),
                  ),
                  data: (homeData) => Column(
                    children: [
                      UltimosPagosSection(pagos: homeData.ultimosPagos),
                      const SizedBox(height: 8),
                      ProximosVencimientosSection(
                        vencimientos: homeData.proximosVencimientos,
                      ),
                      const SizedBox(height: 8),
                      MejoresClientesSection(
                        clientes: homeData.mejoresClientes,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }, childCount: 1),
        ),
      ],
    );
  }
}

class _EsteMesCards extends StatelessWidget {
  final ReporteCard cardsHome;

  const _EsteMesCards({required this.cardsHome});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          'ESTE MES',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: colors.primary),
        ),
        const SizedBox(height: 10),
        CardResumo(
          titulo: 'Total prestado',
          valor: cardsHome.totalPrestadoEsteMes ?? 0.00,
          color: Colors.yellow[700],
        ),
        const SizedBox(height: 20),
        CardResumo(
          titulo: 'Total cobrado',
          valor: cardsHome.totalCobradoEsteMes ?? 0.00,
          color: Colors.green[700],
        ),
        const SizedBox(height: 20),
        CardResumo(
          titulo: 'Total ganado',
          valor: cardsHome.totalGanadoEsteMes ?? 0.00,
          color: Colors.blue[700],
        ),
      ],
    );
  }
}
