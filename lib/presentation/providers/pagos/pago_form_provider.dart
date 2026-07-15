import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/shared/infrastructure/inputs/inputs.dart';

class PagoFormState {
  final PagoMonto monto;

  const PagoFormState({required this.monto});

  PagoFormState copyWith({PagoMonto? monto}) {
    return PagoFormState(monto: monto ?? this.monto);
  }

  bool get isFormValid => monto.isValid;
}

class PagoFormNotifier extends FamilyNotifier<PagoFormState, ({double minimo, double maximo})> {
  @override
  PagoFormState build(({double minimo, double maximo}) arg) {
    final valor = arg.minimo.toStringAsFixed(2);
    return PagoFormState(monto: PagoMonto.dirty(valor, minimo: arg.minimo, maximo: arg.maximo));
  }

  void onMontoChanged(String value) {
    state = state.copyWith(monto: PagoMonto.dirty(value, minimo: arg.minimo, maximo: arg.maximo));
  }

  void touchAll() {
    state = state.copyWith(
      monto: PagoMonto.dirty(state.monto.value, minimo: arg.minimo, maximo: arg.maximo),
    );
  }
}

final pagoFormProvider =
    NotifierProvider.family<PagoFormNotifier, PagoFormState, ({double minimo, double maximo})>(
      PagoFormNotifier.new,
    );
