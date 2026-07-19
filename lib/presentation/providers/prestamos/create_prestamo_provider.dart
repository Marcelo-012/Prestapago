import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/config/errors/errors.dart';
import 'package:prestapagos/presentation/providers/providers.dart';

class CreatePrestamoState {
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const CreatePrestamoState({
    required this.isSubmitting,
    required this.isSuccess,
    this.errorMessage,
  });

  CreatePrestamoState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return CreatePrestamoState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CreatePrestamoNotifier extends Notifier<CreatePrestamoState> {
  @override
  CreatePrestamoState build() => const CreatePrestamoState(
    isSubmitting: false,
    isSuccess: false,
  );

  Future<void> submit() async {
    ref.read(createPrestamoFormProvider.notifier).touchAll();
    final formState = ref.read(createPrestamoFormProvider);
    if (!formState.isFormValid) return;

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final dto = formState.toDTO(amortizaciones: formState.calcularAmortizaciones());

      await ref.read(prestamoRepositoryProvider).createPrestamo(dto);

      ref.invalidate(prestamoPaginationProvider);
      state = state.copyWith(isSubmitting: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: mapErrorToMessage(e));
    }
  }

  void reset() {
    state = build();
  }
}

final createPrestamoProvider =
    NotifierProvider<CreatePrestamoNotifier, CreatePrestamoState>(
  CreatePrestamoNotifier.new,
);
