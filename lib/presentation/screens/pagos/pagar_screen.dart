import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/config/helpers/helpers.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/providers.dart';
import 'package:prestapagos/presentation/screens/pagos/pagos.dart';
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

  Amortizacion? get _prox {
    for (final a in widget.detalle.amortizaciones) {
      if (a.estadoAmortizacion == 'pendiente' || a.estadoAmortizacion == 'atrasado') {
        return a;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    final prox = _prox;
    if (prox == null) return;
    final preview = ref.read(previewPagoProvider(widget.detalle));
    _minimo = preview.totalMinimo;
    _montoController = TextEditingController(text: _minimo.toStringAsFixed(2));
    ref.read(
      pagoFormProvider((minimo: _minimo, maximo: preview.montoMaximo)).notifier,
    );
    _checkClienteActivo();
  }

  void _checkClienteActivo() async {
    final repo = ref.read(clienteRepositoryProvider);
    try {
      final cliente = await repo.getById(widget.detalle.prestamo.idDeudor);
      if (cliente.estado == 'inactivo' && mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text('Cliente inactivo'),
            content: const Text(
              'Este cliente está inactivo. No se pueden registrar pagos hasta que sea reactivado.',
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Entendido'),
              ),
            ],
          ),
        );
      }
    } catch (_) {}
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
    final submitNotifier = ref.read(
      pagoSubmitProvider(widget.detalle.idPrestamo).notifier,
    );
    await submitNotifier.submitPago(
      monto: monto,
      fecha: DateTime.now(),
      tipoExcedente: ManejoExcedente.values.byName(
        widget.detalle.configuracionPrestamo.manejoExcedente,
      ),
    );

    if (!mounted) return;

    final submitState = ref.read(pagoSubmitProvider(widget.detalle.idPrestamo));
    if (submitState.status == PagoSubmitStatus.success) {
      ref.invalidate(prestamoDetalleProvider(widget.detalle.idPrestamo));
      ref.invalidate(prestamoPaginationProvider);
      ref.read(prestamoPaginationProvider.notifier).refresh();
      final idDeudor = widget.detalle.prestamo.idDeudor;
      ref.invalidate(clienteDetalleProvider(idDeudor));
      ref.invalidate(clientePaginationProvider);
      ref.read(clientePaginationProvider.notifier).refresh();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ReceiptScreen(
            idPrestamo: widget.detalle.idPrestamo,
            idCuota: _prox!.idCuota,
          ),
        ),
      );
    } else if (submitState.status == PagoSubmitStatus.error) {
      Fluttertoast.showToast(
        msg: submitState.error ?? 'Error al registrar el pago',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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
    final prox = _prox;
    if (prox == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          title: const CustomAppbar(title: 'Pagar'),
        ),
        body: const Center(child: Text('Préstamo liquidado')),
      );
    }

    final colors = Theme.of(context).colorScheme;
    final textTheme = GoogleFonts.poppins();
    final preview = ref.watch(previewPagoProvider(widget.detalle));
    final minimo = preview.totalMinimo;
    if (_minimo != minimo) _minimo = minimo;
    final formState = ref.watch(
      pagoFormProvider((minimo: minimo, maximo: preview.montoMaximo)),
    );
    final cubierto = minimo <= 0;
    final submitState = ref.watch(
      pagoSubmitProvider(widget.detalle.idPrestamo),
    );

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
                    prox: prox,
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
                                : HumanFormats.monuted(preview.totalMinimo),
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
                  PagoActionButtons(
                    submitStatus: submitState.status,
                    cubierto: cubierto,
                    isFormValid: formState.isFormValid,
                    montoController: _montoController,
                    onPagarCero: _onPagarCero,
                    onPagar: _onPagar,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
