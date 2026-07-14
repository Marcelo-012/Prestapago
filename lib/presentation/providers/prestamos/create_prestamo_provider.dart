import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/config/errors/error_mapper.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/domain/entities/dtos/prestamos/create_prestamo_dto.dart';
import 'package:prestapagos/presentation/providers/prestamos/prestamo_provider.dart';
import 'package:prestapagos/presentation/providers/prestamos/create_prestamo_form_provider.dart';

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
    final formState = ref.read(createPrestamoFormProvider);
    ref.read(createPrestamoFormProvider.notifier).touchAll();
    if (!formState.isFormValid) return;

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final dto = CreatePrestamoDTO(
        idDeudor: int.parse(formState.idDeudor.value),
        monto: double.parse(formState.monto.value),
        plazo: int.parse(formState.plazo.value),
        tasaInteres: double.parse(formState.tasaInteres.value),
        tasaInteresMoratoria: formState.tasaInteresMoratoria.value.isEmpty
            ? 0
            : double.parse(formState.tasaInteresMoratoria.value),
        montoCuota: double.parse(formState.montoCuota.value),
        tipoInteres: formState.tipoInteres,
        estadoMoratorio: formState.estadoMoratorio,
        manejoExcedente: formState.manejoExcedente,
        periodidadIntereses: formState.periodidadIntereses,
      );

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
