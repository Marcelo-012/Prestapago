import 'package:share_plus/share_plus.dart';
import 'package:prestapagos/config/errors/errors.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CastigarPrestamoState {
  final bool isSubmitting;
  final bool isSuccess;
  final bool puedeInactivar;
  final String? errorMessage;

  const CastigarPrestamoState({
    required this.isSubmitting,
    required this.isSuccess,
    this.puedeInactivar = false,
    this.errorMessage,
  });

  CastigarPrestamoState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    bool? puedeInactivar,
    String? errorMessage,
  }) {
    return CastigarPrestamoState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      puedeInactivar: puedeInactivar ?? this.puedeInactivar,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CastigarPrestamoNotifier extends Notifier<CastigarPrestamoState> {
  @override
  CastigarPrestamoState build() => const CastigarPrestamoState(
    isSubmitting: false,
    isSuccess: false,
  );

  Future<void> castigarPrestamo(int idPrestamo, String motivo, PrestamoDetalle detalle) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null, puedeInactivar: false);

    try {
      await ref.read(prestamoRepositoryProvider).castigarPrestamo(idPrestamo, motivo);

      await _generateAndSharePdf(detalle, motivo);

      final repo = ref.read(clienteRepositoryProvider);
      final tieneActivos = await repo.hasActiveLoans(detalle.prestamo.idDeudor);

      _invalidateProviders(idPrestamo, detalle.prestamo.idDeudor);
      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        puedeInactivar: !tieneActivos,
      );
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: mapErrorToMessage(e));
    }
  }

  Future<void> _generateAndSharePdf(PrestamoDetalle detalle, String motivo) async {
    try {
      final service = ref.read(pdfReceiptServiceProvider);
      final acreedorNombre = ref.read(accountProvider).name;
      final file = await service.generateCancelacionPdf(
        detalle: detalle,
        motivo: motivo,
        montoDevuelto: 0,
        tipo: 'castigo',
        acreedorNombre: acreedorNombre,
      );
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Castigo de préstamo - ${detalle.nombreDeudor}',
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

final castigarPrestamoProvider =
    NotifierProvider<CastigarPrestamoNotifier, CastigarPrestamoState>(
  CastigarPrestamoNotifier.new,
);
