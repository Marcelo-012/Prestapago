import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:prestapagos/config/helpers/helpers.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:path_provider/path_provider.dart';

class PdfReceiptService {
  static pw.Font? _baseFont;
  static pw.Font? _boldFont;

  static Future<void> _ensureFonts() async {
    if (_baseFont != null) return;
    final base = await rootBundle.load('google_fonts/poppins/Poppins-Regular.ttf');
    final bold = await rootBundle.load('google_fonts/poppins/Poppins-Bold.ttf');
    _baseFont = pw.Font.ttf(base);
    _boldFont = pw.Font.ttf(bold);
  }
  Future<File> generateReceipt({
    required PrestamoDetalle detalle,
    required Amortizacion amortizacion,
    required DetallePagoDto dto,
    required String? acreedorNombre,
  }) async {
    try {
      await _ensureFonts();
      final pdf = pw.Document(
        theme: pw.ThemeData.withFont(
          base: _baseFont!,
          bold: _boldFont!,
        ),
      );

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

      final prestadoMasIntereses = detalle.prestamo.montoCuota * totalCuotas;

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
                if (amortizacion.montoMora > 0)
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
      final file = File(
        '${dir.path}/recibo_${amortizacion.idCuota}_${_sanitizeFileName(detalle.nombreDeudor)}.pdf',
      );
      await file.writeAsBytes(await pdf.save());
      return file;
    } catch (e) {
      throw Exception('Error al generar el recibo PDF: $e');
    }
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

  String _sanitizeFileName(String name) {
    return name
        .replaceAllMapped(RegExp(r'[áéíóúüñ]'), (m) => _sanitizeChar(m.group(0)!))
        .replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
  }

  String _estadoLabel(String estado) {
    switch (estado) {
      case 'completado':
        return 'Completado';
      case 'en_progreso':
        return 'En progreso';
      case 'pendiente':
        return 'Pendiente';
      case 'sin_amortizaciones':
        return 'Sin amortizaciones';
      default:
        return estado;
    }
  }

  Future<File> generateLoanDetailPdf({
    required PrestamoDetalle detalle,
    required int cuotasPagadas,
    required int cuotasTotales,
    required double capitalPagado,
  }) async {
    try {
      await _ensureFonts();
      final pdf = pw.Document(
        theme: pw.ThemeData.withFont(
          base: _baseFont!,
          bold: _boldFont!,
        ),
      );
      final hoy = DateTime.now();
      final esSimple = detalle.configuracionPrestamo.tipoInteres == 'simple';

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.letter,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return [
              pw.Center(
                child: pw.Text(
                  'Detalle de Préstamo',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Text(
                  HumanFormats.date(hoy),
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Header(text: 'Cliente', level: 1),
              _infoRow('Nombre', detalle.nombreDeudor),
              _infoRow('Identificación', detalle.numeroIdentificacion),
              _infoRow('Teléfono', detalle.telefono),
              pw.SizedBox(height: 16),
              pw.Header(text: 'Información del Préstamo', level: 1),
              _infoRow('Monto', HumanFormats.monuted(detalle.prestamo.monto)),
              _infoRow('Plazo', '${detalle.prestamo.plazo} meses'),
              _infoRow('Cuota mensual', HumanFormats.monuted(detalle.prestamo.montoCuota)),
              _infoRow('Tasa interés', '${detalle.prestamo.tasaInteres}%'),
              _infoRow('Tasa moratoria', '${detalle.prestamo.tasaInteresMoratoria}%'),
              _infoRow('Tipo interés', esSimple ? 'Simple' : 'Compuesto'),
              _infoRow('Periodicidad', detalle.configuracionPrestamo.periodidadIntereses[0].toUpperCase() + detalle.configuracionPrestamo.periodidadIntereses.substring(1)),
              _infoRow('Estado', _estadoLabel(detalle.estadoPagos)),
              pw.SizedBox(height: 16),
              pw.Header(text: 'Progreso', level: 1),
              _infoRow('Cuotas pagadas', '$cuotasPagadas / $cuotasTotales'),
              _infoRow('Capital pagado', HumanFormats.monuted(capitalPagado)),
              _infoRow('Capital pendiente', HumanFormats.monuted(
                detalle.prestamo.monto - capitalPagado,
              )),
              pw.SizedBox(height: 16),
              pw.Header(text: 'Amortizaciones', level: 1),
              _buildAmortizacionTable(
                detalle.amortizaciones,
                tasaMoratoria: detalle.prestamo.tasaInteresMoratoria,
                periodicidad: detalle.configuracionPrestamo.periodidadIntereses,
              ),
            ];
          },
        ),
      );

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/detalle_prestamo_${detalle.idPrestamo}_${_sanitizeFileName(detalle.nombreDeudor)}.pdf',
      );
      await file.writeAsBytes(await pdf.save());
      return file;
    } catch (e) {
      throw Exception('Error al generar el detalle PDF: $e');
    }
  }

  pw.Widget _buildAmortizacionTable(
    List<Amortizacion> amortizaciones, {
    required double tasaMoratoria,
    required String periodicidad,
  }) {
    final tasaDiaria = periodicidad == 'anual'
        ? tasaMoratoria / 100 / 360
        : tasaMoratoria / 100 / 30;

    final headers = <String>[
      '#', 'Vencimiento', 'Fecha pago', 'Monto inicial', 'Cuota',
      'Capital', 'Interés', 'Monto pagado', 'Excedente', 'Días mora',
      'Mora',
      'Estado',
    ];

    final rows = amortizaciones.map((a) {
      final montoMoraCalculado = a.diasMora > 0
          ? (a.montoCapital + a.montoInteres) * tasaDiaria * a.diasMora
          : 0.0;

      final cells = <String>[
        a.idCuota.toString(),
        HumanFormats.date(a.fechaVencimiento),
        a.fechaPagado != null ? HumanFormats.date(a.fechaPagado!) : '-',
        HumanFormats.monuted(a.montoInicial),
        HumanFormats.monuted(a.montoCapital + a.montoInteres),
        HumanFormats.monuted(a.montoCapital),
        HumanFormats.monuted(a.montoInteres),
        HumanFormats.monuted(a.montoPagado),
        HumanFormats.monuted(a.montoExcedente),
        a.diasMora.toString(),
      ];
      cells.add(HumanFormats.monuted(montoMoraCalculado));
      cells.add(a.estadoAmortizacion[0].toUpperCase() + a.estadoAmortizacion.substring(1));
      return cells;
    }).toList();

    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
      cellStyle: pw.TextStyle(fontSize: 7),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
      headers: headers,
      data: rows,
    );
  }

  Future<File> generateCancelacionPdf({
    required PrestamoDetalle detalle,
    required String motivo,
    required double montoDevuelto,
    required String tipo,
    String? motivoCastigo,
    double? montoPerdido,
    String? acreedorNombre,
  }) async {
    try {
      await _ensureFonts();
      final pdf = pw.Document(
        theme: pw.ThemeData.withFont(
          base: _baseFont!,
          bold: _boldFont!,
        ),
      );
      final hoy = DateTime.now();
      final esCancelacion = tipo == 'cancelacion';
  
      final totalCuotas = detalle.amortizaciones.length;
      final cuotasPagadas = detalle.amortizaciones
          .where((a) => a.estadoAmortizacion == 'pagado').length;
  
      final totalAbonado = detalle.amortizaciones
          .where((a) => a.estadoAmortizacion == 'pagado' || a.estadoAmortizacion == 'cancelado')
          .fold<double>(0, (sum, a) => sum + a.montoPagado);
  
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.letter,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return [
              pw.Center(
                child: pw.Text(
                  esCancelacion ? 'CANCELACIÓN DE PRÉSTAMO' : 'CASTIGO DE PRÉSTAMO',
                  style: pw.TextStyle(
                    fontSize: 20,
                    letterSpacing: 2,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Text(
                  HumanFormats.date(hoy),
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Header(text: 'Cliente', level: 1),
              _infoRow('Nombre', detalle.nombreDeudor),
              _infoRow('Identificación', detalle.numeroIdentificacion),
              _infoRow('Teléfono', detalle.telefono),
              pw.SizedBox(height: 16),
              pw.Header(text: 'Información del Préstamo', level: 1),
              _infoRow('Monto', HumanFormats.monuted(detalle.prestamo.monto)),
              _infoRow('Plazo', '${detalle.prestamo.plazo} meses'),
              _infoRow('Cuotas pagadas', '$cuotasPagadas / $totalCuotas'),
              _infoRow('Total abonado', HumanFormats.monuted(totalAbonado)),
              pw.SizedBox(height: 16),
              if (esCancelacion) ...[
                pw.RichText(
                  text: pw.TextSpan(
                    style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.5),
                    children: [
                      pw.TextSpan(text: 'Por este medio, se hace constar que el(la) señor(a) '),
                      pw.TextSpan(text: detalle.nombreDeudor, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.TextSpan(text: ', con identificación '),
                      pw.TextSpan(text: detalle.numeroIdentificacion, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.TextSpan(text: ' y número de teléfono '),
                      pw.TextSpan(text: detalle.telefono, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.TextSpan(text: ', y el acreedor suscrito, llegaron a un acuerdo mutuo para la cancelación del préstamo otorgado por un monto de '),
                      pw.TextSpan(text: HumanFormats.monuted(detalle.prestamo.monto), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.TextSpan(text: ' ('),
                      pw.TextSpan(text: _montoALetras(detalle.prestamo.monto), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.TextSpan(text: '), por motivo de: '),
                      pw.TextSpan(text: motivo, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.TextSpan(text: ', con un plazo original de '),
                      pw.TextSpan(text: '${detalle.prestamo.plazo} meses', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.TextSpan(text: ', del cual se llevaban '),
                      pw.TextSpan(text: '$cuotasPagadas de $totalCuotas', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.TextSpan(text: ' cuotas pagadas, con un total abonado de '),
                      pw.TextSpan(text: HumanFormats.monuted(totalAbonado), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.TextSpan(text: '.'),
                    ],
                  ),
                  textAlign: pw.TextAlign.justify,
                ),
                pw.SizedBox(height: 12),
                if (montoDevuelto > 0)
                  pw.RichText(
                    text: pw.TextSpan(
                      style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.5),
                      children: [
                        pw.TextSpan(text: 'En virtud de dicho acuerdo, ambas partes convienen en dar por terminado y sin efecto el préstamo antes mencionado y siendo el día '),
                        pw.TextSpan(text: '${HumanFormats.date(hoy)} a las ${HumanFormats.time(hoy)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.TextSpan(text: ', comprometiéndose el cliente a devolver al acreedor la cantidad de '),
                        pw.TextSpan(text: HumanFormats.monuted(montoDevuelto), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.TextSpan(text: ' ('),
                        pw.TextSpan(text: _montoALetras(montoDevuelto), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.TextSpan(text: '), correspondiente al saldo neto resultante de la cancelación.'),
                      ],
                    ),
                    textAlign: pw.TextAlign.justify,
                  )
                else
                  pw.RichText(
                    text: pw.TextSpan(
                      style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.5),
                      children: [
                        pw.TextSpan(text: 'En virtud de dicho acuerdo, ambas partes convienen en dar por terminado y sin efecto el préstamo antes mencionado, siendo el día '),
                        pw.TextSpan(text: '${HumanFormats.date(hoy)} a las ${HumanFormats.time(hoy)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.TextSpan(text: ', declarando que no existen saldos pendientes entre las partes, quedando el cliente libre de toda obligación derivada del préstamo referido.'),
                      ],
                    ),
                    textAlign: pw.TextAlign.justify,
                  ),
                pw.SizedBox(height: 12),
                pw.RichText(
                  text: pw.TextSpan(
                    style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.5),
                    children: [
                      pw.TextSpan(text: 'Con la firma del presente documento, ambas partes manifiestan su plena conformidad con los términos aquí establecidos, dando por concluida cualquier obligación derivada del préstamo referido.'),
                    ],
                  ),
                  textAlign: pw.TextAlign.justify,
                ),
              ] else ...[
                pw.Header(text: 'Detalles de Castigo', level: 1),
                _infoRow('Motivo de castigo', motivoCastigo ?? motivo),
                if (montoPerdido != null)
                  _infoRow('Monto perdido', HumanFormats.monuted(montoPerdido)),
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
      final prefix = esCancelacion ? 'cancelacion' : 'castigo';
      final file = File(
        '${dir.path}/${prefix}_${detalle.idPrestamo}_${_sanitizeFileName(detalle.nombreDeudor)}.pdf',
      );
      await file.writeAsBytes(await pdf.save());
      return file;
    } catch (e) {
      throw Exception('Error al generar el PDF de cancelación: $e');
    }
  }

  static const List<String> _unidades = [
    'cero', 'un', 'dos', 'tres', 'cuatro', 'cinco', 'seis', 'siete', 'ocho', 'nueve'
  ];
  static const List<String> _decenas = [
    '', '', 'veinte', 'treinta', 'cuarenta', 'cincuenta', 'sesenta', 'setenta', 'ochenta', 'noventa'
  ];
  static const List<String> _dieces = [
    'diez', 'once', 'doce', 'trece', 'catorce', 'quince', 'dieciséis', 'diecisiete', 'dieciocho', 'diecinueve'
  ];
  static const List<String> _centenas = [
    '', 'ciento', 'doscientos', 'trescientos', 'cuatrocientos', 'quinientos',
    'seiscientos', 'setecientos', 'ochocientos', 'novecientos'
  ];

  String _numeroALetras(int n) {
    if (n < 0) return 'menos ${_numeroALetras(-n)}';
    if (n == 0) return 'cero';
    if (n == 100) return 'cien';

    String result = '';

    if (n >= 1000000) {
      final millones = n ~/ 1000000;
      if (millones == 1) {
        result += 'un millón';
      } else {
        result += '${_numeroALetras(millones)} millones';
      }
      n %= 1000000;
      if (n > 0) result += ' ';
    }

    if (n >= 1000) {
      final miles = n ~/ 1000;
      if (miles == 1) {
        result += 'mil';
      } else {
        result += '${_numeroALetras(miles)} mil';
      }
      n %= 1000;
      if (n > 0) result += ' ';
    }

    if (n >= 100) {
      result += _centenas[n ~/ 100];
      n %= 100;
      if (n > 0) result += ' ';
    }

    if (n >= 10 && n < 20) {
      result += _dieces[n - 10];
      n = 0;
    }

    if (n >= 20) {
      result += _decenas[n ~/ 10];
      n %= 10;
      if (n > 0) result += ' y ';
    }

    if (n > 0) {
      result += _unidades[n];
    }

    return result;
  }

  String _montoALetras(double monto) {
    if (monto < 0) return 'menos ${_montoALetras(-monto)}';
    final pesos = monto.floor();
    final centavos = ((monto - pesos) * 100).round();
    if (pesos == 0 && centavos > 0) {
      return '$centavos/100 centavos';
    }
    final pesosLetras = _numeroALetras(pesos);
    return '$pesosLetras pesos $centavos/100';
  }
}
