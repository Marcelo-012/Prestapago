import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/reportes/reporte_card_provider.dart';
import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/presentation/providers/reportes/reporte_loan_graphic_provider.dart';
import 'package:prestapagos/presentation/providers/reportes/reporte_payments_graphic_provider.dart';
import 'package:prestapagos/presentation/providers/reportes/reporte_estado_prestamos_provider.dart';
import 'package:prestapagos/presentation/providers/reportes/reporte_composicion_pagos_provider.dart';
import 'package:prestapagos/presentation/providers/reportes/reporte_intereses_mensuales_provider.dart';
import 'package:prestapagos/presentation/providers/reportes/reporte_morosidad_provider.dart';
import 'package:prestapagos/presentation/providers/reportes/reporte_saldo_pendiente_provider.dart';

import '../widgets/widgets.dart';

class ReportesView extends ConsumerWidget {
  const ReportesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardAsyncValue = ref.watch(reporteCardProvider);
    final graphicLoanAsyncValue = ref.watch(reporteLoanGraphicProvider);
    final graphicPaymentAsyncValue = ref.watch(reportePaymentsGraphicProvider);
    final estadoPrestamosAsync = ref.watch(reporteEstadoPrestamosProvider);
    final composicionPagosAsync = ref.watch(reporteComposicionPagosProvider);
    final interesesMensualesAsync = ref.watch(reporteInteresesMensualesProvider);
    final morosidadAsync = ref.watch(reporteMorosidadProvider);
    final saldoPendienteAsync = ref.watch(reporteSaldoPendienteProvider);

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
                estadoPrestamosAsync.when(
                  loading: () => const LoadingWidgetCustom(mensaje: 'Cargando gráfica...'),
                  error: (error, stackTrace) => ErrorWidgetCustom(
                    error: error,
                    onRetry: () => ref.refresh(reporteEstadoPrestamosProvider),
                  ),
                  data: (data) {
                    if (data.estados.isEmpty) return const SizedBox.shrink();
                    return PieChartItem(
                      nombreGrafica: 'Estado de préstamos',
                      labels: data.estados,
                      values: data.cantidades,
                      colors: data.estados.map((e) => _colorEstado(e)).toList(),
                    );
                  },
                ),
                const SizedBox(height: 50),
                composicionPagosAsync.when(
                  loading: () => const LoadingWidgetCustom(mensaje: 'Cargando gráfica...'),
                  error: (error, stackTrace) => ErrorWidgetCustom(
                    error: error,
                    onRetry: () => ref.refresh(reporteComposicionPagosProvider),
                  ),
                  data: (data) {
                    final total = data.totalCapital + data.totalInteres + data.totalMora;
                    if (total <= 0) return const SizedBox.shrink();
                    return PieChartItem(
                      nombreGrafica: 'Composición de pagos del mes',
                      labels: ['Capital', 'Interés', 'Mora'],
                      values: [data.totalCapital, data.totalInteres, data.totalMora],
                      colors: [Colors.green, Colors.blue, Colors.red],
                    );
                  },
                ),
                const SizedBox(height: 50),
                interesesMensualesAsync.when(
                  loading: () => const LoadingWidgetCustom(mensaje: 'Cargando gráfica...'),
                  error: (error, stackTrace) => ErrorWidgetCustom(
                    error: error,
                    onRetry: () => ref.refresh(reporteInteresesMensualesProvider),
                  ),
                  data: (data) {
                    if (data.meses.isEmpty) return const SizedBox.shrink();
                    return GraphicItem(
                      nombreGrafica: 'Interés ganado por mes',
                      ejeX: data.meses,
                      ejeY: data.montos,
                      contenido: data.montos
                          .map((m) => HumanFormats.monuted(m))
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: 50),
                morosidadAsync.when(
                  loading: () => const LoadingWidgetCustom(mensaje: 'Cargando gráfica...'),
                  error: (error, stackTrace) => ErrorWidgetCustom(
                    error: error,
                    onRetry: () => ref.refresh(reporteMorosidadProvider),
                  ),
                  data: (data) {
                    if (data.rangos.isEmpty) return const SizedBox.shrink();
                    return BarChartItem(
                      nombreGrafica: 'Morosidad por rango de días',
                      ejeX: data.rangos,
                      ejeY: data.cantidades.map((c) => c.toDouble()).toList(),
                      contenido: data.cantidades.map((c) => '$c cuotas').toList(),
                      barColor: Colors.red,
                    );
                  },
                ),
                const SizedBox(height: 50),
                saldoPendienteAsync.when(
                  loading: () => const LoadingWidgetCustom(mensaje: 'Cargando gráfica...'),
                  error: (error, stackTrace) => ErrorWidgetCustom(
                    error: error,
                    onRetry: () => ref.refresh(reporteSaldoPendienteProvider),
                  ),
                  data: (data) {
                    if (data.meses.isEmpty) return const SizedBox.shrink();
                    return GraphicItem(
                      nombreGrafica: 'Saldo pendiente en el tiempo',
                      ejeX: data.meses,
                      ejeY: data.saldos,
                      contenido: data.saldos
                          .map((s) => HumanFormats.monuted(s))
                          .toList(),
                    );
                  },
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //spacing: 3,
            // runSpacing: 8,
            // alignment: WrapAlignment.center,
            children: [
              _MiniCard(
                titulo: 'Clientes',
                valor: reporteCard.totalClientes.toString(),
                color: Colors.green[700],
              ),
              _MiniCard(
                titulo: 'Préstamos',
                valor: reporteCard.totalPrestamos.toString(),
                color: Theme.of(context).colorScheme.primary,
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
          width: 180,
          height: 120,
          child: CardItem(
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

        SizedBox(
          child: CardResumo(
            titulo: 'Total prestado',
            fontSizeTitle: 20,
            valor: reporteCard.totalPrestadoEsteMes ?? 0.00,
            color: Colors.green[700],
          ),
        ),
        SizedBox(
          child: CardResumo(
            titulo: 'Total cobrado',
            fontSizeTitle: 20,
            valor: reporteCard.totalCobradoEsteMes ?? 0.00,
            color: Colors.red,
          ),
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

        SizedBox(
          child: CardResumo(
            titulo: 'Intereses',
            valor: reporteCard.totalInteresesCobrados ?? 0.00,
            color: Colors.blue[400],
          ),
        ),
        SizedBox(
          child: CardResumo(
            titulo: 'Moratorios',

            valor: reporteCard.totalInteresesMoraCobrados ?? 0.00,
            color: Colors.orange[400],
          ),
        ),
      ],
    );
  }
}

Color _colorEstado(String estado) {
  switch (estado) {
    case 'activo':
      return Colors.blue;
    case 'atrasado':
      return Colors.orange;
    case 'finalizado':
      return Colors.green;
    case 'cancelado':
      return Colors.grey;
    default:
      return Colors.grey;
  }
}
