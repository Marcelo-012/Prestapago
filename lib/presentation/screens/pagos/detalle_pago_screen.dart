import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final esSimple = config.tipoInteres == 'simple';
    final esPagado = amortizacion.estadoAmortizacion == 'pagado';
    final montoCuota = amortizacion.montoCapital + amortizacion.montoInteres;

    final totalAdeudado = detalle.amortizaciones
        .where(
          (a) =>
              a.estadoAmortizacion == 'pendiente' ||
              a.estadoAmortizacion == 'atrasado',
        )
        .fold<double>(0, (sum, a) => sum + a.montoCapital + a.montoInteres);

    double? abonoCapital;
    if (config.manejoExcedente == ManejoExcedente.abonoCapital.value) {
      final excess = amortizacion.montoPagado - montoCuota;
      if (excess > 0.01) abonoCapital = excess;
    }

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
                          label: 'Fecha y hora de pago',
                          value: HumanFormats.dateTime(amortizacion.fechaPagado!),
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
                        value: HumanFormats.monuted(montoCuota),
                        icon: Icons.money,
                        color: colors.primary,
                      ),
                      if (esPagado) ...[
                        const Divider(),
                        InfoRow(
                          label: 'Pago',
                          value: amortizacion.montoPagado == 0
                              ? 'Pagado con saldo a favor'
                              : HumanFormats.monuted(amortizacion.montoPagado),
                          icon: Icons.payment,
                          color: colors.primary,
                        ),
                        if (esSimple && amortizacion.montoMora > 0) ...[
                          const Divider(),
                          InfoRow(
                            label: 'Mora',
                            value: HumanFormats.monuted(amortizacion.montoMora),
                            icon: Icons.warning_amber,
                            color: Colors.red,
                          ),
                        ],
                        if (config.manejoExcedente ==
                                ManejoExcedente.saldoFavor.value &&
                            amortizacion.montoExcedente > 0) ...[
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
                        if (abonoCapital != null) ...[
                          const Divider(),
                          InfoRow(
                            label: 'Abono a capital',
                            value: HumanFormats.monuted(abonoCapital),
                            icon: Icons.trending_down,
                            color: Colors.blue,
                          ),
                        ],
                      ] else ...[
                        const Divider(),
                        const InfoRow(
                          label: 'Pago',
                          value: 'No hay pago registrado todavía',
                          icon: Icons.payment,
                          color: Colors.grey,
                        ),
                      ],
                      if (totalAdeudado > 0) ...[
                        const Divider(),
                        InfoRow(
                          label: 'Total adeudado',
                          value: HumanFormats.monuted(totalAdeudado),
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
