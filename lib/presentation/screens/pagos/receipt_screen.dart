import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/providers/prestamos/prestamo_provider.dart';

class ReceiptScreen extends ConsumerWidget {
  static const name = 'receipt';

  final int idPrestamo;
  final int idCuota;

  const ReceiptScreen({
    super.key,
    required this.idPrestamo,
    required this.idCuota,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final detalleAsync = ref.watch(prestamoDetalleProvider(idPrestamo));

    return detalleAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (detalle) {
        final amortizacion = detalle.amortizaciones.firstWhere(
          (a) => a.idCuota == idCuota,
        );
        final config = detalle.configuracionPrestamo;
        final esPagado = amortizacion.estadoAmortizacion == 'pagado';
        final esCancelado = amortizacion.estadoAmortizacion == 'cancelado';
        final dto = DetallePagoDto.calcular(
          config: config,
          amortizacion: amortizacion,
          amortizaciones: detalle.amortizaciones,
        );

        return Scaffold(
          backgroundColor: colors.primary,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: PhysicalShape(
                color: Colors.white,
                elevation: 8,
                shadowColor: Colors.black45,
                clipper: _ReceiptClipper(),
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'RECIBO',
                        style: TextStyle(
                          fontSize: 24,
                          letterSpacing: 4,
                          color: const Color(0xFF7A8B99),
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cuota #${amortizacion.idCuota} de ${detalle.amortizaciones.length}',
                        style: const TextStyle(
                          color: Color(0xFF7A8B99),
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 16),
                      const _DashedLine(),
                      const SizedBox(height: 16),
                      if (esPagado) ...[
                        _row(
                          'Fecha',
                          HumanFormats.date(amortizacion.fechaPagado!),
                        ),
                        const SizedBox(height: 4),
                        _row(
                          'Hora',
                          DateFormat(
                            'hh:mm a',
                            'es_MX',
                          ).format(amortizacion.fechaPagado!),
                        ),
                        const SizedBox(height: 4),
                      ],
                      if (esCancelado) ...[
                        _row(
                          'Fecha cancelación',
                          HumanFormats.date(amortizacion.fechaActualizacion),
                        ),
                        const SizedBox(height: 4),
                        _row(
                          'Hora cancelación',
                          DateFormat(
                            'hh:mm a',
                            'es_MX',
                          ).format(amortizacion.fechaActualizacion),
                        ),
                        const SizedBox(height: 4),
                      ],
                      _row(
                        'Vencimiento',
                        HumanFormats.date(amortizacion.fechaVencimiento),
                      ),
                      const SizedBox(height: 12),
                      _row('Cliente', detalle.nombreDeudor),
                      if (esPagado) ...[
                        const SizedBox(height: 12),
                        const _DashedLine(),
                        const SizedBox(height: 12),
                        _row('Monto', HumanFormats.monuted(dto.montoCuota)),
                        if (config.tipoInteres == 'simple' &&
                            amortizacion.montoMora > 0)
                          _row(
                            'Mora (${amortizacion.diasMora}d)',
                            HumanFormats.monuted(amortizacion.montoMora),
                          ),
                        _row(
                          'Total',
                          HumanFormats.monuted(dto.totalCuotaConMora),
                          isBold: true,
                        ),
                        const SizedBox(height: 12),
                        const _DashedLine(),
                        const SizedBox(height: 12),
                        if (amortizacion.montoPagado > 0 &&
                            (dto.saldoUsado <= 0.01 ||
                                config.manejoExcedente == 'abonoCapital'))
                          _row(
                            'Efectivo',
                            HumanFormats.monuted(amortizacion.montoPagado),
                          ),
                        if (amortizacion.montoPagado > 0 &&
                            dto.saldoUsado > 0.01 &&
                            config.manejoExcedente != 'abonoCapital') ...[
                          _row(
                            'Efectivo',
                            HumanFormats.monuted(amortizacion.montoPagado),
                          ),
                          const SizedBox(height: 4),
                          _row(
                            'Saldo a favor usado',
                            HumanFormats.monuted(dto.saldoUsado),
                          ),
                        ],
                        if (amortizacion.montoPagado == 0)
                          _row(
                            'Pagado con saldo a favor',
                            HumanFormats.monuted(dto.totalCuotaConMora),
                          ),
                        if (dto.abonoCapital != null)
                          _row(
                            'Abono a capital',
                            HumanFormats.monuted(dto.abonoCapital),
                          ),
                        if (config.manejoExcedente == 'saldoFavor' &&
                            amortizacion.montoExcedente > 0)
                          _row(
                            'Nuevo saldo a favor',
                            HumanFormats.monuted(amortizacion.montoExcedente),
                          ),
                      ],
                      if (esCancelado) ...[
                        const SizedBox(height: 12),
                        const _DashedLine(),
                        const SizedBox(height: 12),
                        _row('Motivo', 'Abono a capital'),
                      ],
                      if (dto.totalAdeudado > 0) ...[
                        const SizedBox(height: 12),
                        const _DashedLine(),
                        const SizedBox(height: 12),
                        _row(
                          'Total adeudado',
                          HumanFormats.monuted(dto.totalAdeudado),
                          isBold: true,
                        ),
                      ],
                      const SizedBox(height: 16),
                      const _DashedLine(),
                      const SizedBox(height: 24),
                      const Text(
                        'GRACIAS POR SU PAGO',
                        style: TextStyle(
                          color: Color(0xFF7A8B99),
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF7A8B99),
              fontFamily: 'monospace',
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 14 : 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: const Color(0xFF7A8B99),
              fontFamily: 'monospace',
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 14 : 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);

    double x = 0;
    double y = size.height;
    const increment = 10.0;
    bool isUp = true;

    while (x < size.width) {
      x += increment;
      y = isUp ? size.height - 8 : size.height;
      path.lineTo(x, y);
      isUp = !isUp;
    }

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 6.0;
        const dashHeight = 2.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFB0C4DE)),
              ),
            );
          }),
        );
      },
    );
  }
}
