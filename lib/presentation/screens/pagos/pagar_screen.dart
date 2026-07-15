import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/pagos/pago_form_provider.dart';
import 'package:prestapagos/presentation/providers/pagos/pago_submit_provider.dart';
import 'package:prestapagos/presentation/providers/pagos/preview_pago_provider.dart';
import 'package:prestapagos/presentation/providers/prestamos/prestamo_provider.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';

class PagarScreen extends ConsumerStatefulWidget {
  static const name = 'pagar';
  final PrestamoDetalle detalle;

  const PagarScreen({super.key, required this.detalle});

  @override
  ConsumerState<PagarScreen> createState() => _PagarScreenState();
}

class _PagarScreenState extends ConsumerState<PagarScreen> {
  late TextEditingController _montoController;
  late double _minimo;

  Amortizacion get _prox => widget.detalle.amortizaciones.firstWhere(
    (a) =>
        a.estadoAmortizacion == 'noPagado' ||
        a.estadoAmortizacion == 'atrasado',
  );

  @override
  void initState() {
    super.initState();
    final preview = ref.read(previewPagoProvider(widget.detalle));
    _minimo = preview.montoCuota;
    _montoController = TextEditingController(text: _minimo.toStringAsFixed(2));
    ref.read(
      pagoFormProvider((minimo: _minimo, maximo: preview.montoMaximo)).notifier,
    );
  }

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  void _onMontoChanged(String value) {
    ref
        .read(
          pagoFormProvider((
            minimo: _minimo,
            maximo: ref.read(previewPagoProvider(widget.detalle)).montoMaximo,
          )).notifier,
        )
        .onMontoChanged(value);
  }

  Future<void> _pagar(double monto) async {
    final submitNotifier = ref.read(pagoSubmitProvider(widget.detalle.idPrestamo).notifier);
    await submitNotifier.submitPago(
      monto: monto,
      fecha: DateTime.now(),
      tipoExcedente: ManejoExcedente.saldoFavor,
    );

    if (!mounted) return;

    final submitState = ref.read(pagoSubmitProvider(widget.detalle.idPrestamo));
    if (submitState.status == PagoSubmitStatus.success) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Pago registrado exitosamente');
      ref.invalidate(prestamoDetalleProvider(widget.detalle.idPrestamo));
      ref.invalidate(prestamoPaginationProvider);
    } else if (submitState.status == PagoSubmitStatus.error) {
      Fluttertoast.showToast(msg: submitState.error ?? 'Error al registrar el pago');
    }
  }

  Future<void> _onPagar() async {
    final arg = (
      minimo: _minimo,
      maximo: ref.read(previewPagoProvider(widget.detalle)).montoMaximo,
    );
    final notifier = ref.read(pagoFormProvider(arg).notifier);
    final formState = ref.read(pagoFormProvider(arg));
    notifier.touchAll();
    if (!formState.isFormValid) return;
    await _pagar(double.tryParse(_montoController.text) ?? 0);
  }

  Future<void> _onPagarCero() async {
    await _pagar(0);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = GoogleFonts.poppins();
    final preview = ref.watch(previewPagoProvider(widget.detalle));
    final minimo = preview.montoCuota;
    if (_minimo != minimo) _minimo = minimo;
    final formState = ref.watch(
      pagoFormProvider((minimo: minimo, maximo: preview.montoMaximo)),
    );
    final cubierto = minimo <= 0;
    final submitState = ref.watch(pagoSubmitProvider(widget.detalle.idPrestamo));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
            floating: true,
            flexibleSpace: const FlexibleSpaceBar(
              title: CustomAppbar(title: 'Pagar'),
              titlePadding: EdgeInsets.only(left: 30.0),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PaymentInfoCard(
                    detalle: widget.detalle,
                    prox: _prox,
                    preview: preview,
                    colors: colors,
                  ),
                  const SizedBox(height: 16),
                  if (cubierto)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Cuota cubierta por saldo a favor',
                              style: textTheme.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (!cubierto) ...[
                    PagoTextField(
                      controller: _montoController,
                      label: 'Monto a pagar',
                      onChanged: _onMontoChanged,
                      errorText: formState.monto.errorMessage,
                    ),
                  ],
                  const SizedBox(height: 16),
                  Card(
                    color: colors.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total a pagar',
                            style: textTheme.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            cubierto
                                ? '\$0.00'
                                : HumanFormats.monuted(preview.montoCuota),
                            style: textTheme.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (submitState.status == PagoSubmitStatus.loading)
                    const Center(child: CircularProgressIndicator())
                  else if (cubierto) ...[
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _onPagarCero,
                            icon: const Icon(Icons.payment),
                            label: const Text(
                              'Pagar \$0',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              final monto =
                                  double.tryParse(_montoController.text) ?? 0;
                              if (monto <= 0) {
                                Fluttertoast.showToast(
                                  msg: 'Ingresa un monto para abonar',
                                );
                                return;
                              }
                              _pagar(monto);
                            },
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text(
                              'Abonar',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    PagoTextField(
                      controller: _montoController,
                      label: 'Abono extra',
                    ),
                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: formState.isFormValid ? _onPagar : null,
                        icon: const Icon(Icons.payment),
                        label: const Text(
                          'Pagar',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
