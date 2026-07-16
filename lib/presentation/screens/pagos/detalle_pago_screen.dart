import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';

class DetallePagoScreen extends StatelessWidget {
  static const name = 'detalle-pago';

  final PrestamoDetalle detalle;
  final Amortizacion amortizacion;

  const DetallePagoScreen({
    super.key,
    required this.detalle,
    required this.amortizacion,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final config = detalle.configuracionPrestamo;
    final esPagado = amortizacion.estadoAmortizacion == 'pagado';
    final esCancelado = amortizacion.estadoAmortizacion == 'cancelado';
    final dto = DetallePagoDto.calcular(
      config: config,
      amortizacion: amortizacion,
      amortizaciones: detalle.amortizaciones,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
            floating: true,
            flexibleSpace: const FlexibleSpaceBar(
              title: CustomAppbar(title: 'Detalle de pago'),
              titlePadding: EdgeInsets.only(left: 30.0),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cuota #${amortizacion.idCuota}',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InfoRow(
                        label: 'Cliente',
                        value: detalle.nombreDeudor,
                        icon: Icons.person,
                        color: colors.primary,
                      ),
                      const Divider(),
                      if (esPagado) ...[
                        InfoRow(
                          label: 'Fecha de pago',
                          value: HumanFormats.date(amortizacion.fechaPagado!),
                          icon: Icons.calendar_today,
                          color: colors.primary,
                        ),
                        const SizedBox(height: 4),
                        InfoRow(
                          label: 'Hora de pago',
                          value: DateFormat('hh:mm a', 'es_MX')
                              .format(amortizacion.fechaPagado!),
                          icon: Icons.access_time,
                          color: colors.primary,
                        ),
                        const Divider(),
                      ],
                      InfoRow(
                        label: 'Fecha de vencimiento',
                        value: HumanFormats.date(amortizacion.fechaVencimiento),
                        icon: Icons.calendar_today,
                        color: colors.primary,
                      ),
                      const Divider(),
                      InfoRow(
                        label: 'Monto',
                        value: HumanFormats.monuted(dto.montoCuota),
                        icon: Icons.money,
                        color: colors.primary,
                      ),
                      if (esPagado) ...[
                        if (config.tipoInteres == 'simple' &&
                            amortizacion.montoMora > 0) ...[
                          const Divider(),
                          InfoRow(
                            label: 'Mora (${amortizacion.diasMora} días)',
                            value: HumanFormats.monuted(amortizacion.montoMora),
                            icon: Icons.warning_amber,
                            color: Colors.red,
                          ),
                        ],
                        const Divider(),
                        InfoRow(
                          label: 'Total',
                          value: HumanFormats.monuted(dto.totalCuotaConMora),
                          icon: Icons.request_quote,
                          color: colors.primary,
                        ),
                        if (config.manejoExcedente == 'abonoCapital') ...[
                          const Divider(),
                          if (amortizacion.montoPagado > 0)
                            InfoRow(
                              label: 'Efectivo',
                              value: HumanFormats.monuted(
                                amortizacion.montoPagado,
                              ),
                              icon: Icons.payment,
                              color: colors.primary,
                            ),
                          if (dto.abonoCapital != null) ...[
                            const SizedBox(height: 4),
                            InfoRow(
                              label: 'Abono a capital',
                              value: HumanFormats.monuted(dto.abonoCapital),
                              icon: Icons.trending_down,
                              color: Colors.blue,
                            ),
                          ],
                        ] else ...[
                          const Divider(),
                          if (amortizacion.montoPagado > 0 &&
                              dto.saldoUsado <= 0.01)
                            InfoRow(
                              label: 'Efectivo',
                              value: HumanFormats.monuted(
                                amortizacion.montoPagado,
                              ),
                              icon: Icons.payment,
                              color: colors.primary,
                            ),
                          if (amortizacion.montoPagado > 0 &&
                              dto.saldoUsado > 0.01) ...[
                            InfoRow(
                              label: 'Efectivo',
                              value: HumanFormats.monuted(
                                amortizacion.montoPagado,
                              ),
                              icon: Icons.payment,
                              color: colors.primary,
                            ),
                            const SizedBox(height: 4),
                            InfoRow(
                              label: 'Saldo a favor usado',
                              value: HumanFormats.monuted(dto.saldoUsado),
                              icon: Icons.credit_score,
                              color: Colors.orange,
                            ),
                          ],
                          if (amortizacion.montoPagado == 0)
                            InfoRow(
                              label: 'Pagado con saldo a favor',
                              value: HumanFormats.monuted(dto.totalCuotaConMora),
                              icon: Icons.credit_score,
                              color: Colors.orange,
                            ),
                          if (amortizacion.montoExcedente > 0) ...[
                            const Divider(),
                            InfoRow(
                              label: 'Nuevo saldo a favor',
                              value: HumanFormats.monuted(
                                amortizacion.montoExcedente,
                              ),
                              icon: Icons.credit_score,
                              color: Colors.green,
                            ),
                          ],
                        ],
                      ] else if (esCancelado) ...[
                        const Divider(),
                        InfoRow(
                          label: 'Fecha de cancelación',
                          value:
                              HumanFormats.date(amortizacion.fechaActualizacion),
                          icon: Icons.cancel,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 4),
                        InfoRow(
                          label: 'Hora de cancelación',
                          value: DateFormat('hh:mm a', 'es_MX')
                              .format(amortizacion.fechaActualizacion),
                          icon: Icons.access_time,
                          color: Colors.red,
                        ),
                        const Divider(),
                        InfoRow(
                          label: 'Motivo',
                          value: 'Abono a capital',
                          icon: Icons.info_outline,
                          color: Colors.red,
                        ),
                      ] else ...[
                        const Divider(),
                        const InfoRow(
                          label: 'Pago',
                          value: 'No hay pago registrado todavía',
                          icon: Icons.payment,
                          color: Colors.grey,
                        ),
                      ],
                      if (dto.totalAdeudado > 0) ...[
                        const Divider(),
                        InfoRow(
                          label: 'Total adeudado',
                          value: HumanFormats.monuted(dto.totalAdeudado),
                          icon: Icons.account_balance,
                          color: Colors.red,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
