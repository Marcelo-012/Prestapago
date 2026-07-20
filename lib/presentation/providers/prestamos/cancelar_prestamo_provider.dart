import 'package:share_plus/share_plus.dart';
import 'package:prestapagos/config/errors/errors.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CancelarPrestamoState {
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const CancelarPrestamoState({
    required this.isSubmitting,
    required this.isSuccess,
    this.errorMessage,
  });

  CancelarPrestamoState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return CancelarPrestamoState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CancelarPrestamoNotifier extends Notifier<CancelarPrestamoState> {
  @override
  CancelarPrestamoState build() => const CancelarPrestamoState(
    isSubmitting: false,
    isSuccess: false,
  );

  Future<void> cancelarPrestamo(int idPrestamo, String motivo, double montoDevuelto, PrestamoDetalle detalle) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      await ref.read(prestamoRepositoryProvider).cancelarPrestamo(idPrestamo, motivo, montoDevuelto);

      await _generateAndSharePdf(detalle, motivo, montoDevuelto);

      _invalidateProviders(idPrestamo, detalle.prestamo.idDeudor);
      state = state.copyWith(isSubmitting: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: mapErrorToMessage(e));
    }
  }

  Future<void> _generateAndSharePdf(PrestamoDetalle detalle, String motivo, double montoDevuelto) async {
    try {
      final service = ref.read(pdfReceiptServiceProvider);
      final acreedorNombre = ref.read(accountProvider).name;
      final file = await service.generateCancelacionPdf(
        detalle: detalle,
        motivo: motivo,
        montoDevuelto: montoDevuelto,
        tipo: 'cancelacion',
        acreedorNombre: acreedorNombre,
      );
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Cancelación de préstamo - ${detalle.nombreDeudor}',
        ),
      );
    } catch (_) {
      // PDF share is best-effort
    }
  }

  void _invalidateProviders(int idPrestamo, int idDeudor) {
    ref.invalidate(prestamoPaginationProvider);
    ref.read(prestamoPaginationProvider.notifier).refresh();
    ref.invalidate(prestamoDetalleProvider(idPrestamo));
    ref.invalidate(prestamoProvider(idPrestamo));
    ref.invalidate(clienteDetalleProvider(idDeudor));
    ref.invalidate(clientePaginationProvider);
    ref.read(clientePaginationProvider.notifier).refresh();
    invalidateAllReportes(ref);
  }
}

final cancelarPrestamoProvider =
    NotifierProvider<CancelarPrestamoNotifier, CancelarPrestamoState>(
  CancelarPrestamoNotifier.new,
);
