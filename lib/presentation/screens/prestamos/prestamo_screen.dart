import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/config/constants/prestamo_constants.dart';
import 'package:prestapagos/config/helpers/helpers.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/services/pdf_receipt_service.dart';
import 'package:prestapagos/presentation/providers/providers.dart';
import 'package:prestapagos/presentation/screens/pagos/pagos.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';
import 'package:prestapagos/shared/shared.dart';
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

  void _goToPagar(PrestamoDetalle detalle, {double? montoInicial}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PagarScreen(detalle: detalle, montoInicial: montoInicial),
      ),
    );
  }

  Future<void> _generarPdf(PrestamoDetalle detalle) async {
    final config = detalle.configuracionPrestamo;
    final service = PdfReceiptService();

    final file = config.estadoPrestamo == 'cancelado'
        ? await service.generateCancelacionPdf(
            detalle: detalle,
            motivo: config.motivoCancelacion ?? 'Cancelación de préstamo',
            montoDevuelto: config.montoDevuelto,
            tipo: 'cancelacion',
          )
        : config.estadoPrestamo == 'incobrable'
            ? await service.generateCancelacionPdf(
                detalle: detalle,
                motivo: '',
                motivoCastigo: config.motivoCastigo ?? 'Castigo de préstamo',
                montoDevuelto: 0,
                montoPerdido: config.montoPerdido,
                tipo: 'castigo',
              )
            : await service.generateLoanDetailPdf(
                detalle: detalle,
                cuotasPagadas: detalle.amortizaciones
                    .where((a) => a.estadoAmortizacion == 'pagado' || a.estadoAmortizacion == 'cancelado')
                    .length,
                cuotasTotales: detalle.amortizaciones.length,
                capitalPagado: detalle.amortizaciones
                    .where((a) => a.estadoAmortizacion == 'pagado' || a.estadoAmortizacion == 'cancelado')
                    .fold<double>(0, (sum, a) => sum + a.montoCapital),
              );

    if (!mounted) return;
    final label = config.estadoPrestamo == 'cancelado'
        ? 'Cancelación de préstamo'
        : config.estadoPrestamo == 'incobrable'
            ? 'Castigo de préstamo'
            : 'Detalle de préstamo';
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: '$label - ${detalle.nombreDeudor}',
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
    final esActivoOAtrasado = detalle.configuracionPrestamo.estadoPrestamo == 'activo' ||
        detalle.configuracionPrestamo.estadoPrestamo == 'atrasado';
    final fechaInicio = detalle.prestamo.fechaCreacion;
    final diasDesdeInicio = DateTime.now().difference(fechaInicio).inDays;
    final estaEnVentanaCancelacion = esActivoOAtrasado &&
        cuotasPagadas <= PrestamoConstants.maxCuotasCancelacion &&
        diasDesdeInicio <= PrestamoConstants.maxDiasCancelacion;
    final puedeCancelar = esActivoOAtrasado;
    final puedeCastigar = esActivoOAtrasado;

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
                if (hayPendientes) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _mostrarDialogoLiquidacion(detalle),
                      icon: const Icon(Icons.account_balance),
                      label: const Text('Liquidación anticipada'),
                    ),
                  ),
                ],
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
                if (puedeCancelar || puedeCastigar) ...[
                  const SizedBox(height: 24),
                  if (puedeCancelar)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _mostrarDialogoCancelar(detalle, estaEnVentanaCancelacion),
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text('Cancelar préstamo'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    ),
                  if (puedeCancelar && puedeCastigar)
                    const SizedBox(height: 8),
                  if (puedeCastigar)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _mostrarDialogoCastigar(detalle),
                        icon: const Icon(Icons.block),
                        label: const Text('Castigar préstamo'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _calcularTotalLiquidacion(PrestamoDetalle detalle) {
    final pendientes = detalle.amortizaciones.where(
      (a) => a.estadoAmortizacion == 'pendiente' || a.estadoAmortizacion == 'atrasado',
    ).toList();
    final tasaMoratoria = detalle.prestamo.tasaInteresMoratoria;
    final periodicidad = detalle.configuracionPrestamo.periodidadIntereses;

    var capitalPendiente = 0.0;
    var moraAcumulada = 0.0;
    for (final a in pendientes) {
      capitalPendiente += a.montoCapital;
      if (a.estadoAmortizacion == 'atrasado' && a.diasMora > 0) {
        moraAcumulada += AmortizationCalculator.calcularMontoMora(
          montoInicial: a.montoCapital + a.montoInteres,
          tasaMoratoria: tasaMoratoria,
          periodicidad: periodicidad,
          diasMora: a.diasMora,
        );
      }
    }

    final primerPendiente = pendientes.isNotEmpty ? pendientes.first : null;
    final interesMesCurso = primerPendiente?.montoInteres ?? 0.0;

    return capitalPendiente + moraAcumulada + interesMesCurso;
  }

  Future<void> _mostrarDialogoLiquidacion(PrestamoDetalle detalle) async {
    final total = _calcularTotalLiquidacion(detalle);

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Liquidación anticipada'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total a liquidar:'),
              const SizedBox(height: 8),
              Text(
                HumanFormats.monuted(total),
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Corresponde al saldo total de todas las cuotas pendientes, '
                'incluyendo intereses y mora calculada al día de hoy.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            icon: const Icon(Icons.payment),
            label: const Text('Ir a pagar'),
          ),
        ],
      ),
    );

    if (result == true) {
      _goToPagar(detalle, montoInicial: total);
    }
  }

  Future<void> _mostrarDialogoCancelar(PrestamoDetalle detalle, bool dentroVentana) async {
    if (!dentroVentana) {
      final excedido = <String>[];
      if (DateTime.now().difference(detalle.prestamo.fechaCreacion).inDays >
          PrestamoConstants.maxDiasCancelacion) {
        excedido.add('${PrestamoConstants.maxDiasCancelacion} días');
      }
      final completadas = <String>['pagado', 'cancelado'];
      final pagadas = detalle.amortizaciones
          .where((a) => completadas.contains(a.estadoAmortizacion))
          .length;
      if (pagadas > PrestamoConstants.maxCuotasCancelacion) {
        excedido.add('${PrestamoConstants.maxCuotasCancelacion} cuotas');
      }

      final mensaje = excedido.join(' y ');

      final hacerLiquidacion = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Cancelar préstamo'),
          content: Text(
            'Este préstamo ya excedió las $mensaje. '
            'Solo se puede realizar una liquidación anticipada.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(ctx, true),
              icon: const Icon(Icons.account_balance),
              label: const Text('Liquidación anticipada'),
            ),
          ],
        ),
      );
      if (hacerLiquidacion == true) {
        await _mostrarDialogoLiquidacion(detalle);
      }
      return;
    }

    final eleccion = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar préstamo'),
        content: const Text('¿Qué desea hacer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'cancelar'),
            child: const Text('Cancelar préstamo'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(ctx, 'liquidacion'),
            icon: const Icon(Icons.account_balance),
            label: const Text('Liquidación anticipada'),
          ),
        ],
      ),
    );

    if (eleccion == 'liquidacion') {
      await _mostrarDialogoLiquidacion(detalle);
      return;
    }

    if (eleccion != 'cancelar') return;

    final motivoController = TextEditingController();
    final montoRController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final cantidadRecibir = detalle.amortizaciones
        .where((a) => a.estadoAmortizacion == 'pendiente' || a.estadoAmortizacion == 'atrasado')
        .fold<double>(0, (sum, a) => sum + a.montoCapital);

    final confirmar = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar préstamo'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Esta acción no se puede deshacer.'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Cantidad a recibir:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      HumanFormats.monuted(cantidadRecibir),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: montoRController,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad recibida',
                    border: OutlineInputBorder(),
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Ingrese la cantidad recibida';
                    }
                    final monto = double.tryParse(v);
                    if (monto == null || monto < 0) {
                      return 'Cantidad inválida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: motivoController,
                  decoration: const InputDecoration(
                    labelText: 'Motivo de cancelación',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Ingrese un motivo'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, true);
              }
            },
            child: const Text('Confirmar cancelación'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _confirmarCancelacion(
        detalle,
        motivoController.text.trim(),
        double.tryParse(montoRController.text.trim()) ?? 0,
      );
    }
  }

  Future<void> _mostrarDialogoCastigar(PrestamoDetalle detalle) async {
    final motivoController = TextEditingController();
    final confirmacionController = TextEditingController();
    final rand = Random();
    final palabraConfirmacion = String.fromCharCodes(
      List.generate(
        5,
        (_) {
          final r = rand.nextInt(36);
          return r < 10 ? r + 48 : r + 55; // 0-9, A-Z
        },
      ),
    );
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Castigar préstamo'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Esta acción no se puede deshacer. '
                  'Se dará de baja el préstamo como incobrable.',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: motivoController,
                  decoration: const InputDecoration(
                    labelText: 'Motivo de castigo',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Ingrese un motivo'
                      : null,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Escriba "$palabraConfirmacion" para confirmar',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: confirmacionController,
                  decoration: InputDecoration(
                    labelText: 'Confirmación',
                    hintText: palabraConfirmacion,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) => v != palabraConfirmacion
                      ? 'Escriba exactamente "$palabraConfirmacion"'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, true);
              }
            },
            child: const Text('Confirmar castigo'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _confirmarCastigo(
        detalle,
        motivoController.text.trim(),
      );
    }
  }

  Future<void> _confirmarCancelacion(
    PrestamoDetalle detalle,
    String motivo,
    double montoDevuelto,
  ) async {
    final cancelState = ref.read(cancelarPrestamoProvider);
    if (cancelState.isSubmitting) return;

    await ref
        .read(cancelarPrestamoProvider.notifier)
        .cancelarPrestamo(detalle.idPrestamo, motivo, montoDevuelto);

    if (!mounted) return;
    final updated = ref.read(cancelarPrestamoProvider);
    if (updated.isSuccess) {
      try {
        final service = PdfReceiptService();
        final file = await service.generateCancelacionPdf(
          detalle: detalle,
          motivo: motivo,
          montoDevuelto: montoDevuelto,
          tipo: 'cancelacion',
        );
        if (!mounted) return;
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path)],
            text: 'Cancelación de préstamo - ${detalle.nombreDeudor}',
          ),
        );
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Préstamo cancelado correctamente')),
        );
      }
      ref.invalidate(prestamoDetalleProvider(_id));
      final idDeudor = detalle.prestamo.idDeudor;
      ref.invalidate(clienteDetalleProvider(idDeudor));
      ref.invalidate(clientePaginationProvider);
      ref.read(clientePaginationProvider.notifier).refresh();
    } else if (updated.errorMessage != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(updated.errorMessage!)),
      );
    }
  }

  Future<void> _confirmarCastigo(
    PrestamoDetalle detalle,
    String motivo,
  ) async {
    final castigoState = ref.read(castigarPrestamoProvider);
    if (castigoState.isSubmitting) return;

    await ref
        .read(castigarPrestamoProvider.notifier)
        .castigarPrestamo(detalle.idPrestamo, motivo);

    if (!mounted) return;
    final updated = ref.read(castigarPrestamoProvider);
    if (updated.isSuccess) {
      try {
        final service = PdfReceiptService();
        final file = await service.generateCancelacionPdf(
          detalle: detalle,
          motivo: motivo,
          montoDevuelto: 0,
          tipo: 'castigo',
        );
        if (!mounted) return;
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path)],
            text: 'Castigo de préstamo - ${detalle.nombreDeudor}',
          ),
        );
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Préstamo castigado correctamente')),
        );
      }
      if (!mounted) return;
      final repo = ref.read(clienteRepositoryProvider);
      final tieneActivos = await repo.hasActiveLoans(detalle.prestamo.idDeudor);
      if (!tieneActivos && mounted) {
        final inactivar = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Cliente'),
            content: const Text(
              'El préstamo ha sido castigado. ¿Desea inactivar al cliente?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('No'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Sí, inactivar'),
              ),
            ],
          ),
        );
        if (inactivar == true) {
          await ref.read(deleteClienteProvider.notifier).deactivateCliente(
            detalle.prestamo.idDeudor,
          );
        }
      }
      ref.invalidate(prestamoDetalleProvider(_id));
      final idDeudor = detalle.prestamo.idDeudor;
      ref.invalidate(clienteDetalleProvider(idDeudor));
      ref.invalidate(clientePaginationProvider);
      ref.read(clientePaginationProvider.notifier).refresh();
    } else if (updated.errorMessage != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(updated.errorMessage!)),
      );
    }
  }
}
