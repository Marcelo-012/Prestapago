import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/presentation/providers/prestamos/create_prestamo_form_provider.dart';

class CreatePrestamoStep2 extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const CreatePrestamoStep2({
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
          Text('Periodicidad de intereses',
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Selecciona cómo se calcularán los intereses',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _CompactCard(
                  selected: formState.periodidadIntereses == 'mensual',
                  title: 'Mensual',
                  description: 'Intereses se calculan cada mes sobre el saldo pendiente.',
                  color: scheme.primary,
                  onTap: () {
                    ref.read(createPrestamoFormProvider.notifier).onPeriodidadInteresesChanged('mensual');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CompactCard(
                  selected: formState.periodidadIntereses == 'anual',
                  title: 'Anual',
                  description: 'Intereses se calculan una vez al año sobre el monto total.',
                  color: scheme.primary,
                  onTap: () {
                    ref.read(createPrestamoFormProvider.notifier).onPeriodidadInteresesChanged('anual');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: onSkip,
                  child: const Text('Omitir'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: onNext,
                  child: const Text('Siguiente'),
                ),
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
