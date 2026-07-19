import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/infrastructure/services/pdf_receipt_service.dart';

final pdfReceiptServiceProvider = Provider<PdfReceiptService>((ref) {
  return PdfReceiptService();
});
