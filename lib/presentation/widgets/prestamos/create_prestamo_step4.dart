import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/presentation/providers/prestamos/create_prestamo_form_provider.dart';

class CreatePrestamoStep4 extends ConsumerWidget {
  final VoidCallback onPreview;

  const CreatePrestamoStep4({super.key, required this.onPreview});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createPrestamoFormProvider);
    final notifier = ref.read(createPrestamoFormProvider.notifier);
    final moratorioActivo = formState.estadoMoratorio == 'activo';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Datos del préstamo',
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Completa todos los campos para generar el préstamo',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 24),

          _NumericField(
            label: 'Monto',
            hint: '\$0.00',
            value: formState.monto.value,
            error: formState.monto.displayError != null ? 'Campo inválido' : null,
            onChanged: notifier.onMontoChanged,
            formatAsCurrency: true,
          ),
          const SizedBox(height: 16),

          _NumericField(
            label: 'Tasa de interés ${formState.periodidadIntereses == 'mensual' ? 'mensual' : 'anual'} (%)',
            hint: '0.00',
            value: formState.tasaInteres.value,
            error: formState.tasaInteres.displayError != null ? 'Campo inválido' : null,
            onChanged: notifier.onTasaInteresChanged,
          ),
          const SizedBox(height: 16),

          if (moratorioActivo)
            _NumericField(
              label: 'Tasa de interés moratoria ${formState.periodidadIntereses == 'mensual' ? 'mensual' : 'anual'} (%)',
              hint: '0.00',
              value: formState.tasaInteresMoratoria.value,
              error: formState.tasaInteresMoratoria.displayError != null ? 'Campo inválido' : null,
              onChanged: notifier.onTasaInteresMoratoriaChanged,
            ),
          if (moratorioActivo) const SizedBox(height: 16),

          _NumericField(
            label: 'Plazo (meses)',
            hint: '12',
            value: formState.plazo.value,
            error: formState.plazo.displayError != null ? 'Campo inválido' : null,
            onChanged: notifier.onPlazoChanged,
          ),
          const SizedBox(height: 16),

          // Cuota read-only - auto-calculated
          _ReadOnlyCuota(value: formState.montoCuota.value),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                notifier.touchAll();
                if (ref.read(createPrestamoFormProvider).isFormValid) {
                  onPreview();
                }
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Ver préstamo', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyCuota extends ConsumerWidget {
  final String value;

  const _ReadOnlyCuota({required this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cuota mensual', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            value.isNotEmpty ? HumanFormats.monuted(double.tryParse(value) ?? 0) : '—',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _NumericField extends StatefulWidget {
  final String label;
  final String hint;
  final String value;
  final String? error;
  final void Function(String) onChanged;
  final bool formatAsCurrency;

  const _NumericField({
    required this.label,
    required this.hint,
    required this.value,
    this.error,
    required this.onChanged,
    this.formatAsCurrency = false,
  });

  @override
  State<_NumericField> createState() => _NumericFieldState();
}

class _NumericFieldState extends State<_NumericField> {
  late TextEditingController _controller;
  late String _lastValue;
  late FocusNode _focusNode;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _lastValue = widget.value;
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _isUpdating = true;
    _controller = TextEditingController(text: widget.formatAsCurrency ? _formatRaw(widget.value) : widget.value);
    _isUpdating = false;
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(_NumericField old) {
    super.didUpdateWidget(old);
    if (widget.value != _lastValue && widget.value != _controller.text) {
      _lastValue = widget.value;
      _isUpdating = true;
      if (!_focusNode.hasFocus && widget.formatAsCurrency) {
        _controller.text = _formatRaw(widget.value);
      } else {
        _controller.text = widget.value;
      }
      _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
      _isUpdating = false;
    }
  }

  String _formatRaw(String raw) {
    final parsed = double.tryParse(raw);
    return parsed != null ? HumanFormats.monuted(parsed) : raw;
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && widget.formatAsCurrency) {
      final raw = widget.value;
      if (raw.isNotEmpty) {
        final formatted = _formatRaw(raw);
        if (formatted != _controller.text) {
          _isUpdating = true;
          _controller.text = formatted;
          _controller.selection = TextSelection.collapsed(offset: formatted.length);
          _isUpdating = false;
        }
      }
    }
  }

  void _onControllerChanged() {
    if (_isUpdating) return;
    if (_controller.text != _lastValue) {
      _lastValue = _controller.text;
      widget.onChanged(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.error,
            border: const OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    );
  }
}
