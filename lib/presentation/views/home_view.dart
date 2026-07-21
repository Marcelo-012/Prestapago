import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/providers.dart';
import 'package:prestapagos/presentation/widgets/shared/notification_permission_dialog.dart';

import '../widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  bool _asked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeAskNotification();
  }

  void _maybeAskNotification() {
    if (_asked) return;
    final estado = ref.read(notificacionesProvider);
    if (estado != NotificacionesEstado.neverAsked) return;
    _asked = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final acepto = await showNotificationPermissionDialog(context);
      if (!mounted) return;
      if (acepto == true) {
        final status = await Permission.notification.request();
        if (status.isGranted) {
          await ref.read(notificacionesProvider.notifier).aceptar();
        } else if (status.isPermanentlyDenied) {
          await ref.read(notificacionesProvider.notifier).rechazar();
          if (mounted) {
            await showGoToSettingsDialog(context);
          }
        } else {
          await ref.read(notificacionesProvider.notifier).rechazar();
        }
      } else {
        await ref.read(notificacionesProvider.notifier).rechazar();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  error: (error, stackTrace) => ErrorWidgetCustom(
                    error: error,
                    onRetry: () => ref.refresh(reporteCardProvider),
                  ),
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
