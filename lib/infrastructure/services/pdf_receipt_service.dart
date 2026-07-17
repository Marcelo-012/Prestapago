import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:prestapagos/config/helpers/helpers.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:path_provider/path_provider.dart';

class PdfReceiptService {
  Future<File> generateReceipt({
    required PrestamoDetalle detalle,
    required Amortizacion amortizacion,
    required DetallePagoDto dto,
    required String? acreedorNombre,
  }) async {
    final pdf = pw.Document();

    final config = detalle.configuracionPrestamo;
    final esPagado = amortizacion.estadoAmortizacion == 'pagado';
    final esCancelado = amortizacion.estadoAmortizacion == 'cancelado';
    final esSimple = config.tipoInteres == 'simple';
    final esAbonoCapital = config.manejoExcedente == 'abonoCapital';
    final esSaldoFavor = config.manejoExcedente == 'saldoFavor';

    final totalCuotas = detalle.amortizaciones.length;
    final cuotasPagadas = detalle.amortizaciones
        .where((a) =>
            a.estadoAmortizacion == 'pagado' ||
            a.estadoAmortizacion == 'cancelado')
        .length;
    final cuotasVencidas = detalle.amortizaciones
        .where((a) => a.estadoAmortizacion == 'atrasado')
        .length;

    final proxCuota = detalle.amortizaciones
        .where((a) =>
            a.estadoAmortizacion == 'pendiente' ||
            a.estadoAmortizacion == 'atrasado')
        .firstOrNull;

    final totalIntereses = detalle.amortizaciones.fold<double>(
        0, (sum, a) => sum + a.montoInteres);

    final totalAbonado = detalle.amortizaciones
        .where((a) =>
            a.estadoAmortizacion == 'pagado' ||
            a.estadoAmortizacion == 'cancelado')
        .fold<double>(0, (sum, a) => sum + a.montoCapital + a.montoInteres);

    final deudaCapital = detalle.amortizaciones
        .where((a) =>
            a.estadoAmortizacion == 'pendiente' ||
            a.estadoAmortizacion == 'atrasado')
        .fold<double>(0, (sum, a) => sum + a.montoCapital);

    final interesesPendientes = detalle.amortizaciones
        .where((a) =>
            a.estadoAmortizacion == 'pendiente' ||
            a.estadoAmortizacion == 'atrasado')
        .fold<double>(0, (sum, a) => sum + a.montoInteres);

    final prestadoMasIntereses =
        detalle.prestamo.montoCuota * totalCuotas;

    final hoy = DateTime.now();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                'RECIBO',
                style: pw.TextStyle(
                  fontSize: 24,
                  letterSpacing: 6,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey600,
                ),
              ),
            ),
            pw.SizedBox(height: 6),
            pw.Center(
              child: pw.Text(
                HumanFormats.date(hoy),
                style: pw.TextStyle(
                  fontSize: 11,
                  color: PdfColors.grey600,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Header(text: 'Cliente', level: 1),
            _infoRow('Nombre', detalle.nombreDeudor),
            _infoRow('ID', detalle.numeroIdentificacion),
            pw.SizedBox(height: 16),
            pw.Header(text: 'Información del Préstamo', level: 1),
            _infoRow(
              'Fecha del crédito',
              HumanFormats.date(detalle.prestamo.fechaCreacion),
            ),
            _infoRow(
              'Fecha próxima cuota',
              proxCuota != null
                  ? HumanFormats.date(proxCuota.fechaVencimiento)
                  : 'Completado',
            ),
            _infoRow(
              'Vencimiento del crédito',
              HumanFormats.date(
                detalle.amortizaciones.last.fechaVencimiento,
              ),
            ),
            _infoRow('Cuotas vencidas', cuotasVencidas.toString()),
            _infoRow(
              'Interés',
              '${detalle.prestamo.tasaInteres}% (${esSimple ? 'Simple' : 'Compuesto'})',
            ),
            _infoRow(
              'Valor total intereses',
              HumanFormats.monuted(totalIntereses),
            ),
            _infoRow(
              'Número de cuotas',
              '$cuotasPagadas/$totalCuotas',
            ),
            _infoRow('Frecuencia de Pago', 'Mensual'),
            _infoRow(
              'Valor cuota',
              HumanFormats.monuted(detalle.prestamo.montoCuota),
            ),
            _infoRow(
              'Total prestado',
              HumanFormats.monuted(detalle.prestamo.monto),
            ),
            _infoRow(
              'Prestado + intereses',
              HumanFormats.monuted(prestadoMasIntereses),
            ),
            _infoRow(
              'Total abonado',
              HumanFormats.monuted(totalAbonado),
            ),
            _infoRow(
              'Deuda a Capital',
              HumanFormats.monuted(deudaCapital),
            ),
            _infoRow(
              'Intereses Pendientes',
              HumanFormats.monuted(interesesPendientes),
            ),
            _infoRow(
              'Saldo Total',
              HumanFormats.monuted(dto.totalAdeudado),
            ),
            pw.SizedBox(height: 16),
            pw.Header(text: 'Detalles del Recibo', level: 1),
            if (esPagado) ...[
              _infoRow(
                'Fecha',
                HumanFormats.date(amortizacion.fechaPagado!),
              ),
              _infoRow(
                'Hora',
                HumanFormats.time(amortizacion.fechaPagado!),
              ),
              _infoRow('Abono a', 'Interés y Capital'),
              _infoRow('Método de Pago', 'Efectivo'),
              _infoRow('Monto', HumanFormats.monuted(dto.montoCuota)),
              if (esSimple && amortizacion.montoMora > 0)
                _infoRow(
                  'Mora (${amortizacion.diasMora}d)',
                  HumanFormats.monuted(amortizacion.montoMora),
                ),
              _infoRow(
                'Abonado',
                HumanFormats.monuted(dto.totalCuotaConMora),
                isBold: true,
              ),
              if (amortizacion.montoPagado > 0 &&
                  (dto.saldoUsado <= 0.01 || esAbonoCapital))
                _infoRow(
                  'Efectivo',
                  HumanFormats.monuted(amortizacion.montoPagado),
                ),
              if (amortizacion.montoPagado > 0 &&
                  dto.saldoUsado > 0.01 &&
                  !esAbonoCapital) ...[
                _infoRow(
                  'Efectivo',
                  HumanFormats.monuted(amortizacion.montoPagado),
                ),
                _infoRow(
                  'Saldo a favor usado',
                  HumanFormats.monuted(dto.saldoUsado),
                ),
              ],
              if (amortizacion.montoPagado == 0)
                _infoRow(
                  'Pagado con saldo a favor',
                  HumanFormats.monuted(dto.totalCuotaConMora),
                ),
              if (dto.abonoCapital != null)
                _infoRow(
                  'Abono a capital',
                  HumanFormats.monuted(dto.abonoCapital),
                ),
              if (esSaldoFavor && amortizacion.montoExcedente > 0)
                _infoRow(
                  'Nuevo saldo a favor',
                  HumanFormats.monuted(amortizacion.montoExcedente),
                ),
            ],
            if (esCancelado) ...[
              _infoRow(
                'Fecha cancelación',
                HumanFormats.date(amortizacion.fechaActualizacion),
              ),
              _infoRow('Motivo', 'Abono a capital'),
            ],
            if (dto.totalAdeudado > 0) ...[
              pw.SizedBox(height: 8),
              _infoRow(
                'Total adeudado',
                HumanFormats.monuted(dto.totalAdeudado),
                isBold: true,
              ),
            ],
            pw.SizedBox(height: 32),
            pw.Row(
              children: [
                pw.Expanded(
                  child: _firmaSection('Firma del Cliente', detalle.nombreDeudor),
                ),
                pw.SizedBox(width: 24),
                pw.Expanded(
                  child: _firmaSection('Firma del Acreedor', acreedorNombre ?? ''),
                ),
              ],
            ),
          ];
        },
      ),
    );

    final dir = await getTemporaryDirectory();
    final nombreCliente = detalle.nombreDeudor
        .replaceAllMapped(RegExp(r'[áéíóúüñ]'), (m) => _sanitizeChar(m.group(0)!))
        .replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
    final file = File(
        '${dir.path}/recibo_${amortizacion.idCuota}_$nombreCliente.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  pw.Widget _infoRow(String label, String value, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey700,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _firmaSection(String title, String nombre) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Container(
          height: 1,
          color: PdfColors.grey400,
          margin: const pw.EdgeInsets.only(right: 40),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          nombre,
          style: pw.TextStyle(
            fontSize: 10,
            color: PdfColors.grey700,
          ),
        ),
      ],
    );
  }

  String _sanitizeChar(String c) {
    switch (c) {
      case 'á': return 'a';
      case 'é': return 'e';
      case 'í': return 'i';
      case 'ó': return 'o';
      case 'ú': return 'u';
      case 'ü': return 'u';
      case 'ñ': return 'n';
      default: return c;
    }
  }
}
