import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/presentation/providers/prestamos/create_prestamo_form_provider.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';

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
                child: CompactCard(
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
                child: CompactCard(
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
