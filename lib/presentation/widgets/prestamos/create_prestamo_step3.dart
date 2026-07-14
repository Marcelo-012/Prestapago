import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/presentation/providers/prestamos/create_prestamo_form_provider.dart';

class CreatePrestamoStep3 extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const CreatePrestamoStep3({
    super.key,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createPrestamoFormProvider);
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Configuración del préstamo',
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Tipo de interés',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CompactCard(
                  selected: formState.tipoInteres == 'compuesto',
                  title: 'Compuesto',
                  description: 'Interés sobre saldo pendiente. Pagas solo lo que debes.',
                  color: scheme.primary,
                  onTap: () => ref.read(createPrestamoFormProvider.notifier).onTipoInteresChanged('compuesto'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CompactCard(
                  selected: formState.tipoInteres == 'simple',
                  title: 'Simple',
                  description: 'Interés fijo sobre el monto original del préstamo.',
                  color: scheme.primary,
                  onTap: () => ref.read(createPrestamoFormProvider.notifier).onTipoInteresChanged('simple'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Estado moratorio',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _MoratorioToggle(
            activo: formState.estadoMoratorio == 'activo',
            onToggle: () {
              final nuevo = formState.estadoMoratorio == 'activo' ? 'inactivo' : 'activo';
              ref.read(createPrestamoFormProvider.notifier).onEstadoMoratorioChanged(nuevo);
            },
          ),
          const SizedBox(height: 24),
          Text('Manejo de excedente',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CompactCard(
                  selected: formState.manejoExcedente == 'abono_capital',
                  title: 'Abono a capital',
                  description: 'Pagos extra reducen el capital pendiente.',
                  color: scheme.primary,
                  onTap: () => ref.read(createPrestamoFormProvider.notifier).onManejoExcedenteChanged('abono_capital'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CompactCard(
                  selected: formState.manejoExcedente == 'saldo_favor',
                  title: 'Saldo a favor',
                  description: 'Pagos extra quedan para futuras cuotas.',
                  color: scheme.primary,
                  onTap: () => ref.read(createPrestamoFormProvider.notifier).onManejoExcedenteChanged('saldo_favor'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: FilledButton(onPressed: onSkip, child: const Text('Omitir')),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(onPressed: onNext, child: const Text('Siguiente')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactCard extends StatelessWidget {
  final bool selected;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _CompactCard({
    required this.selected,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected ? color : Colors.grey.shade700,
              )),
            const SizedBox(height: 4),
            Text(description,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade600,
              )),
          ],
        ),
      ),
    );
  }
}

class _MoratorioToggle extends StatelessWidget {
  final bool activo;
  final VoidCallback onToggle;

  const _MoratorioToggle({required this.activo, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: activo ? Colors.green.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: activo ? Colors.green : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              activo ? Icons.check_circle : Icons.radio_button_unchecked,
              color: activo ? Colors.green : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text('Activar moratorio',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: activo ? Colors.green.shade800 : Colors.grey.shade700,
              )),
          ],
        ),
      ),
    );
  }
}
