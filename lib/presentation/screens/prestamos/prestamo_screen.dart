import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/presentation/providers/prestamos/delete_prestamo_provider.dart';
import 'package:prestapagos/presentation/providers/prestamos/prestamo_provider.dart';
import 'package:prestapagos/presentation/widgets/prestamos/pago_dialog.dart';
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
          final progreso = cuotasTotales > 0
              ? cuotasPagadas / cuotasTotales
              : 0.0;

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
                      // Info card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        detalle.nombreDeudor,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Chip(
                                    label: Text(
                                      detalle
                                              .configuracionPrestamo
                                              .estadoPrestamo[0]
                                              .toUpperCase() +
                                          detalle
                                              .configuracionPrestamo
                                              .estadoPrestamo
                                              .substring(1),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: _chipColor(
                                      detalle
                                          .configuracionPrestamo
                                          .estadoPrestamo,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                              _row(
                                'Monto',
                                HumanFormats.monuted(detalle.prestamo.monto),
                              ),
                              _row('Plazo', '${detalle.prestamo.plazo} meses'),
                              _row(
                                'Tasa interés',
                                '${detalle.prestamo.tasaInteres}% ${detalle.configuracionPrestamo.periodidadIntereses == 'mensual' ? 'mensual' : 'anual'}',
                              ),
                              _row(
                                'Cuota mensual',
                                HumanFormats.monuted(
                                  detalle.prestamo.montoCuota,
                                ),
                              ),
                              if (detalle.prestamo.tasaInteresMoratoria > 0)
                                _row(
                                  'Tasa moratoria',
                                  '${detalle.prestamo.tasaInteresMoratoria}% ${detalle.configuracionPrestamo.periodidadIntereses == 'mensual' ? 'mensual' : 'anual'}',
                                ),
                              _row(
                                'Tipo interés',
                                detalle.configuracionPrestamo.tipoInteres ==
                                        'compuesto'
                                    ? 'Compuesto'
                                    : 'Simple',
                              ),
                              _row(
                                'Estado pagos',
                                _estadoPagosLabel(detalle.estadoPagos),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Progress bar
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cuotas pagadas',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    HumanFormats.monuted(
                                      detalle.prestamo.monto,
                                    ),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '$cuotasPagadas / $cuotasTotales',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progreso,
                                  minHeight: 8,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    progreso >= 1.0
                                        ? Colors.green
                                        : Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Siguiente pago button
                      if (detalle.configuracionPrestamo.estadoPrestamo !=
                              'finalizado' &&
                          detalle.amortizaciones
                              .any((a) => a.estadoAmortizacion == 'noPagado'))
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => PagoDialog(detalle: detalle),
                              );
                            },
                            icon: const Icon(Icons.payment),
                            label: const Text('Siguiente pago'),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Amortizaciones table
                      Text(
                        'Amortizaciones',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 12,
                          columns: const [
                            DataColumn(label: Text('#')),
                            DataColumn(label: Text('Vencimiento')),
                            DataColumn(label: Text('Cuota')),
                            DataColumn(label: Text('Capital')),
                            DataColumn(label: Text('Interés')),
                            DataColumn(label: Text('Pagado')),
                            DataColumn(label: Text('Estado')),
                          ],
                          rows: detalle.amortizaciones
                              .map(
                                (a) => DataRow(
                                  cells: [
                                    DataCell(Text('${a.idCuota}')),
                                    DataCell(
                                      Text(
                                        '${a.fechaVencimiento.day}/${a.fechaVencimiento.month}/${a.fechaVencimiento.year}',
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        HumanFormats.monuted(a.montoInicial),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        HumanFormats.monuted(a.montoCapital),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        HumanFormats.monuted(a.montoInteres),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        a.fechaPagado != null
                                            ? HumanFormats.monuted(
                                                a.montoPagado,
                                              )
                                            : '—',
                                      ),
                                    ),
                                    DataCell(
                                      Chip(
                                        label: Text(
                                          a.estadoAmortizacion[0]
                                                  .toUpperCase() +
                                              a.estadoAmortizacion.substring(1),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: _chipColor(
                                          a.estadoAmortizacion,
                                        ),
                                        padding: EdgeInsets.zero,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
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

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(color: Colors.grey.shade600)),
          Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Color _chipColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'activo':
        return Colors.blueAccent;
      case 'pagado':
        return Colors.green;
      case 'atrasado':
        return Colors.orange;
      case 'cancelado':
        return Colors.red;
      case 'finalizado':
        return Colors.green;
      case 'noPagado':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _estadoPagosLabel(String estado) {
    switch (estado) {
      case 'completado':
        return 'Completado';
      case 'en_progreso':
        return 'En progreso';
      case 'pendiente':
        return 'Pendiente';
      case 'sin_amortizaciones':
        return 'Sin amortizaciones';
      default:
        return estado;
    }
  }

  // ignore: unused_element
  Future<void> _confirmarCancelar(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar préstamo'),
        content: const Text('¿Estás seguro de cancelar este préstamo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await ref.read(deletePrestamoProvider.notifier).cancelarPrestamo(_id);
    if (!context.mounted) return;
    Fluttertoast.showToast(
      msg: 'Préstamo cancelado',
      gravity: ToastGravity.TOP,
    );
    ref.invalidate(prestamoDetalleProvider(_id));
  }

  // ignore: unused_element
  Future<void> _confirmarFinalizar(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Finalizar préstamo'),
        content: const Text('¿Estás seguro de finalizar este préstamo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sí, finalizar'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await ref.read(deletePrestamoProvider.notifier).finalizarPrestamo(_id);
    if (!context.mounted) return;
    Fluttertoast.showToast(
      msg: 'Préstamo finalizado',
      gravity: ToastGravity.TOP,
    );
    ref.invalidate(prestamoDetalleProvider(_id));
  }
}
