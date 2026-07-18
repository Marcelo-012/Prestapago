import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/services/pdf_receipt_service.dart';
import 'package:prestapagos/presentation/providers/providers.dart';
import 'package:prestapagos/presentation/screens/pagos/pagos.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';
import 'package:share_plus/share_plus.dart';

class PrestamoScreen extends ConsumerStatefulWidget {
  static const name = 'prestamo-profile';
  final String prestamoId;
  const PrestamoScreen({super.key, required this.prestamoId});

  @override
  ConsumerState<PrestamoScreen> createState() => _PrestamoScreenState();
}

class _PrestamoScreenState extends ConsumerState<PrestamoScreen> {
  int get _id => int.parse(widget.prestamoId);
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _showContent = true);
    });
  }

  void _goToPagar(PrestamoDetalle detalle) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PagarScreen(detalle: detalle)),
    );
  }

  Future<void> _generarPdf(PrestamoDetalle detalle) async {
    final completadas = <String>['pagado', 'cancelado'];
    final cuotasPagadas = detalle.amortizaciones
        .where((a) => completadas.contains(a.estadoAmortizacion))
        .length;
    final capitalPagado = detalle.amortizaciones
        .where((a) => completadas.contains(a.estadoAmortizacion))
        .fold<double>(0, (sum, a) => sum + a.montoCapital);

    final service = PdfReceiptService();
    final file = await service.generateLoanDetailPdf(
      detalle: detalle,
      cuotasPagadas: cuotasPagadas,
      cuotasTotales: detalle.amortizaciones.length,
      capitalPagado: capitalPagado,
    );

    if (!mounted) return;
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'Detalle de préstamo - ${detalle.nombreDeudor}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detalleAsync = ref.watch(prestamoDetalleProvider(_id));

    return Scaffold(
      body: detalleAsync.when(
        loading: () => const FullScreenLoader(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (detalle) {
          if (!_showContent) return const FullScreenLoader();
          return _buildUI(detalle);
        },
      ),
    );
  }

  Widget _buildUI(PrestamoDetalle detalle) {
    final cuotasTotales = detalle.amortizaciones.length;
    final completadas = <String>['pagado', 'cancelado'];
    final cuotasPagadas = detalle.amortizaciones
        .where((a) => completadas.contains(a.estadoAmortizacion))
        .length;
    final capitalPagado = detalle.amortizaciones
        .where((a) => completadas.contains(a.estadoAmortizacion))
        .fold<double>(0, (sum, a) => sum + a.montoCapital);
    final hayPendientes = detalle.amortizaciones.any(
      (a) =>
          a.estadoAmortizacion == 'pendiente' ||
          a.estadoAmortizacion == 'atrasado',
    );

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
          actions: [
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: 'Generar PDF',
              onPressed: () => _generarPdf(detalle),
            ),
          ],
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
                  capitalPagado: capitalPagado,
                  cuotasPagadas: cuotasPagadas,
                  cuotasTotales: cuotasTotales,
                ),
                const SizedBox(height: 16),
                if (hayPendientes)
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
                  onViewPayment: (a) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReceiptScreen(
                          idPrestamo: detalle.idPrestamo,
                          idCuota: a.idCuota,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _generarPdf(detalle),
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Descargar PDF'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
