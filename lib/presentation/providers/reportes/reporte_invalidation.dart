import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/presentation/providers/providers.dart';

void invalidateAllReportes(Ref ref) {
  ref.invalidate(reporteCardProvider);
  ref.invalidate(reporteComposicionPagosProvider);
  ref.invalidate(reporteEstadoPrestamosProvider);
  ref.invalidate(reporteInteresesMensualesProvider);
  ref.invalidate(reporteLoanGraphicProvider);
  ref.invalidate(reporteMorosidadProvider);
  ref.invalidate(reportePaymentsGraphicProvider);
  ref.invalidate(reporteSaldoPendienteProvider);
}
