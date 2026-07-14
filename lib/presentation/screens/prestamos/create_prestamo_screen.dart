import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prestapagos/presentation/providers/prestamos/create_prestamo_form_provider.dart';
import 'package:prestapagos/presentation/widgets/prestamos/create_prestamo_step1.dart';
import 'package:prestapagos/presentation/widgets/prestamos/create_prestamo_step2.dart';
import 'package:prestapagos/presentation/widgets/prestamos/create_prestamo_step3.dart';
import 'package:prestapagos/presentation/widgets/prestamos/create_prestamo_step4.dart';

class CreatePrestamoScreen extends ConsumerStatefulWidget {
  static const name = 'create-prestamo';
  const CreatePrestamoScreen({super.key});

  @override
  ConsumerState<CreatePrestamoScreen> createState() =>
      _CreatePrestamoScreenState();
}

class _CreatePrestamoScreenState extends ConsumerState<CreatePrestamoScreen> {
  late PageController _pageController;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _currentStep = step);
  }

  void _goToPreview() {
    context.push('/prestamo/preview');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_currentStep > 0) {
          _goToStep(_currentStep - 1);
        } else {
          if (context.mounted) context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (_currentStep > 0) {
                _goToStep(_currentStep - 1);
              } else {
                context.pop();
              }
            },
          ),
          title: Text(
            'Nuevo préstamo',
            style: TextStyle(color: colors.primary),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_currentStep + 1) / 4,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Paso ${_currentStep + 1} de 4',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) =>
                      setState(() => _currentStep = index),
                  children: [
                    CreatePrestamoStep1(onNext: () => _goToStep(1)),
                    CreatePrestamoStep2(
                      onNext: () => _goToStep(2),
                      onSkip: () {
                        ref
                            .read(createPrestamoFormProvider.notifier)
                            .onPeriodidadInteresesChanged('mensual');
                        _goToStep(2);
                      },
                    ),
                    CreatePrestamoStep3(
                      onNext: () => _goToStep(3),
                      onSkip: () {
                        ref
                            .read(createPrestamoFormProvider.notifier)
                            .setDefaults();
                        _goToStep(3);
                      },
                    ),
                    CreatePrestamoStep4(onPreview: _goToPreview),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
