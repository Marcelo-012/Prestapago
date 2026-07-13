import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/reportes/reporte_card_provider.dart';
import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/presentation/providers/reportes/reporte_loan_graphic_provider.dart';
import 'package:prestapagos/presentation/providers/reportes/reporte_payments_graphic_provider.dart';

import '../widgets/widgets.dart';

class ReportesView extends ConsumerWidget {
  const ReportesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardAsyncValue = ref.watch(reporteCardProvider);
    final graphicLoanAsyncValue = ref.watch(reporteLoanGraphicProvider);
    final graphicPaymentAsyncValue = ref.watch(reportePaymentsGraphicProvider);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const CustomAppbar(title: 'Reportes'),
            titlePadding: EdgeInsets.zero,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                const SizedBox(height: 20),
                cardAsyncValue.when(
                  loading: () =>
                      const LoadingWidgetCustom(mensaje: 'Cargando resumen...'),
                  error: (error, stackTrace) => ErrorWidgetCustom(
                    error: error,
                    onRetry: () => ref.refresh(reporteCardProvider),
                  ),
                  data: (reporteCard) =>
                      _ResumenCards(reporteCard: reporteCard),
                ),
                graphicLoanAsyncValue.when(
                  loading: () =>
                      const LoadingWidgetCustom(mensaje: 'Cargando gráfica...'),
                  error: (error, stackTrace) => ErrorWidgetCustom(
                    error: error,
                    onRetry: () => ref.refresh(reporteLoanGraphicProvider),
                  ),
                  data: (reporteLoanGraphic) => GraphicItem(
                    nombreGrafica: 'Préstamos otorgados por mes',
                    ejeX: reporteLoanGraphic.nombreMes,
                    ejeY: reporteLoanGraphic.montoMes,
                    contenido: reporteLoanGraphic.montoMes
                        .map((m) => HumanFormats.monuted(m))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 50),
                graphicPaymentAsyncValue.when(
                  loading: () =>
                      const LoadingWidgetCustom(mensaje: 'Cargando gráfica...'),
                  error: (error, stackTrace) => ErrorWidgetCustom(
                    error: error,
                    onRetry: () => ref.refresh(reportePaymentsGraphicProvider),
                  ),
                  data: (reportePaymentGraphic) => GraphicItem(
                    nombreGrafica: 'Pagos recibidos por día',
                    ejeX: reportePaymentGraphic.fechaPago,
                    ejeY: reportePaymentGraphic.montoPago,
                    contenido: reportePaymentGraphic.montoPago
                        .map((m) => HumanFormats.monuted(m))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            );
          }, childCount: 1),
        ),
      ],
    );
  }
}

class _ResumenCards extends StatelessWidget {
  final ReporteCard reporteCard;

  const _ResumenCards({required this.reporteCard});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Wrap(
            spacing: 3,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _MiniCard(
                titulo: 'Total Clientes',
                valor: reporteCard.totalClientes.toString(),
                color: Colors.green[700],
              ),
              _MiniCard(
                titulo: 'Total Préstamos',
                valor: reporteCard.totalPrestamos.toString(),
                color: Theme.of(context).colorScheme.primary,
              ),
              _MiniCard(
                titulo: 'Préstamos activos',
                valor: reporteCard.totalPrestamosActivos.toString(),
                color: Colors.redAccent[700],
              ),
            ],
          ),
        ),
        _SeccionEsteMes(reporteCard: reporteCard),
        _SeccionGeneral(reporteCard: reporteCard),
      ],
    );
  }
}

class _MiniCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final Color? color;

  const _MiniCard({required this.titulo, required this.valor, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 125,
          height: 125,
          child: CardItem(
            onTap: () => Fluttertoast.showToast(
              msg: '$titulo tocado',
              gravity: ToastGravity.TOP,
            ),
            alignment: CrossAxisAlignment.center,
            title: titulo,
            fontSizeTitle: 14,
            subtitle: valor,
            fontSizeSubtitle: 25,
            colortext: color,
          ),
        ),
      ],
    );
  }
}

class _SeccionEsteMes extends StatelessWidget {
  final ReporteCard reporteCard;

  const _SeccionEsteMes({required this.reporteCard});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          'ESTE MES',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: colors.primary),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            SizedBox(
              width: 180,
              height: 140,
              child: CardResumo(
                titulo: 'Total prestado',
                fontSizeTitle: 18,
                valor: reporteCard.totalPrestadoEsteMes ?? 0.00,
                color: Colors.green[700],
              ),
            ),
            SizedBox(
              width: 180,
              height: 140,
              child: CardResumo(
                titulo: 'Total cobrado',
                fontSizeTitle: 18,
                valor: reporteCard.totalCobradoEsteMes ?? 0.00,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        CardResumo(
          titulo: 'Total ganado',
          valor: reporteCard.totalGanadoEsteMes ?? 0.00,
          color: Colors.blue[700],
        ),
      ],
    );
  }
}

class _SeccionGeneral extends StatelessWidget {
  final ReporteCard reporteCard;

  const _SeccionGeneral({required this.reporteCard});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          'REPORTE GENERAL',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: colors.primary),
        ),
        const SizedBox(height: 20),
        CardResumo(
          titulo: 'Total cobrado',
          valor: reporteCard.totalPagado ?? 0.00,
          color: Colors.green[700],
        ),
        const SizedBox(height: 20),
        CardResumo(
          titulo: 'Total pendiente',
          valor: reporteCard.totalPendiente ?? 0.00,
          color: Colors.red,
        ),
        const SizedBox(height: 20),
        CardResumo(
          titulo: 'Total prestado',
          valor: reporteCard.totalPrestado ?? 0.00,
          color: Colors.yellow[700],
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            SizedBox(
              width: 180,
              height: 140,
              child: CardResumo(
                titulo: 'Intereses cobrados',
                fontSizeTitle: 18,
                valor: reporteCard.totalInteresesCobrados ?? 0.00,
                color: Colors.blue[400],
              ),
            ),
            SizedBox(
              width: 180,
              height: 140,
              child: CardResumo(
                titulo: 'Moratorios cobrados',
                fontSizeTitle: 18,
                valor: reporteCard.totalInteresesMoraCobrados ?? 0.00,
                color: Colors.orange[400],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
