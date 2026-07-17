import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/config/errors/errors.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/providers.dart';

enum PagoSubmitStatus { idle, loading, success, error }

class PagoSubmitState {
  final PagoSubmitStatus status;
  final String? error;

  const PagoSubmitState({required this.status, this.error});

  const PagoSubmitState.idle() : status = PagoSubmitStatus.idle, error = null;

  PagoSubmitState copyWith({PagoSubmitStatus? status, String? error}) {
    return PagoSubmitState(status: status ?? this.status, error: error);
  }
}

class PagoSubmitNotifier extends FamilyNotifier<PagoSubmitState, int> {
  @override
  PagoSubmitState build(int arg) => const PagoSubmitState.idle();

  Future<void> submitPago({
    required double monto,
    required DateTime fecha,
    required ManejoExcedente tipoExcedente,
  }) async {
    state = const PagoSubmitState(status: PagoSubmitStatus.loading);
    try {
      final repo = ref.read(pagoRepositoryProvider);
      await repo.registrarPago(arg, monto, fecha, tipoExcedente: tipoExcedente);
      state = const PagoSubmitState(status: PagoSubmitStatus.success);
    } catch (e) {
      state = PagoSubmitState(status: PagoSubmitStatus.error, error: mapErrorToMessage(e));
    }
  }

  void reset() {
    state = const PagoSubmitState.idle();
  }
}

final pagoSubmitProvider =
    NotifierProvider.family<PagoSubmitNotifier, PagoSubmitState, int>(
      PagoSubmitNotifier.new,
    );
