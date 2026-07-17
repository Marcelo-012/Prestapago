import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/config/errors/errors.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/providers.dart';

class EditPrestamoState {
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const EditPrestamoState({
    required this.isSubmitting,
    required this.isSuccess,
    this.errorMessage,
  });

  EditPrestamoState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return EditPrestamoState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class EditPrestamoNotifier extends Notifier<EditPrestamoState> {
  @override
  EditPrestamoState build() => const EditPrestamoState(
    isSubmitting: false,
    isSuccess: false,
  );

  Future<void> submit(int idPrestamo) async {
    ref.read(editPrestamoFormProvider.notifier).touchAll();
    final formState = ref.read(editPrestamoFormProvider);
    if (!formState.isFormValid) return;

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final prestamo = Prestamo(
        idPrestamo: idPrestamo,
        idDeudor: int.parse(formState.idDeudor.value),
        monto: double.parse(formState.monto.value),
        plazo: (double.parse(formState.plazo.value)).toInt(),
        tasaInteres: double.parse(formState.tasaInteres.value),
        tasaInteresMoratoria: formState.tasaInteresMoratoria.value.isEmpty
            ? 0
            : double.parse(formState.tasaInteresMoratoria.value),
        montoCuota: double.parse(formState.montoCuota.value),
        fechaCreacion: DateTime.now(),
      );

      await ref.read(prestamoRepositoryProvider).updatePrestamo(prestamo);

      ref.invalidate(prestamoProvider(idPrestamo));
      ref.invalidate(prestamoPaginationProvider);
      ref.read(prestamoPaginationProvider.notifier).refresh();
      state = state.copyWith(isSubmitting: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: mapErrorToMessage(e));
    }
  }

  void reset() {
    state = build();
  }
}

final editPrestamoProvider =
    NotifierProvider<EditPrestamoNotifier, EditPrestamoState>(
  EditPrestamoNotifier.new,
);
