import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/presentation/providers/providers.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';

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
                child: CompactCard(
                  selected: formState.tipoInteres == 'compuesto',
                  title: 'Compuesto',
                  description: 'Interés sobre saldo pendiente. Pagas solo lo que debes.',
                  color: scheme.primary,
                  onTap: () => ref.read(createPrestamoFormProvider.notifier).onTipoInteresChanged('compuesto'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CompactCard(
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
          MoratorioToggle(
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
                child: CompactCard(
                  selected: formState.manejoExcedente == 'abono_capital',
                  title: 'Abono a capital',
                  description: 'Pagos extra reducen el capital pendiente.',
                  color: scheme.primary,
                  onTap: () => ref.read(createPrestamoFormProvider.notifier).onManejoExcedenteChanged('abono_capital'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CompactCard(
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
