import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/prestamos/prestamo_provider.dart';
import 'package:prestapagos/presentation/screens/pagos/pagar_screen.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';

class PrestamoScreen extends ConsumerStatefulWidget {
  static const name = 'prestamo-profile';
  final String prestamoId;
  const PrestamoScreen({super.key, required this.prestamoId});

  @override
  ConsumerState<PrestamoScreen> createState() => _PrestamoScreenState();
}

class _PrestamoScreenState extends ConsumerState<PrestamoScreen> {
  int get _id => int.parse(widget.prestamoId);

  void _goToPagar(PrestamoDetalle detalle) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PagarScreen(detalle: detalle)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detalleAsync = ref.watch(prestamoDetalleProvider(_id));

    return Scaffold(
      body: detalleAsync.when(
        loading: () =>
            const LoadingWidgetCustom(mensaje: 'Cargando detalle...'),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (detalle) {
          final cuotasTotales = detalle.amortizaciones.length;
          final cuotasPagadas = detalle.amortizaciones
              .where((a) => a.estadoAmortizacion == 'pagado')
              .length;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => context.pop(),
                ),
                floating: true,
                flexibleSpace: const FlexibleSpaceBar(
                  title: CustomAppbar(title: 'Detalle préstamo'),
                  titlePadding: EdgeInsets.only(left: 30.0),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrestamoInfoCard(detalle: detalle),
                      const SizedBox(height: 16),
                      ProgressCard(
                        montoPrestamo: detalle.prestamo.monto,
                        cuotasPagadas: cuotasPagadas,
                        cuotasTotales: cuotasTotales,
                      ),
                      const SizedBox(height: 16),
                      if (cuotasPagadas < cuotasTotales)
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => _goToPagar(detalle),
                            icon: const Icon(Icons.payment),
                            label: const Text('Ir a pagar'),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        'Amortizaciones',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AmortizacionTable(
                        amortizaciones: detalle.amortizaciones,
                        montoCuota: detalle.prestamo.montoCuota,
                        onViewPayment: (_) {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
