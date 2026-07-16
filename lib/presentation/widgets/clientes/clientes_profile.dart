import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/config/helpers/human_formats.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientesProfile extends StatelessWidget {
  final ClienteDetalle detalle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onReactivate;

  const ClientesProfile({
    super.key,
    required this.detalle,
    required this.onEdit,
    required this.onDelete,
    this.onReactivate,
  });

  @override
  Widget build(BuildContext context) {
    final client = detalle.cliente;
    final style = GoogleFonts.poppins();

    return Column(
      children: [
        const SizedBox(height: 8),
        ClientesDetalles(
          nombre: client.nombre,
          score: detalle.scorePromedio,
          estado: client.estado,
          acciones: [
            Accion(icono: Icons.edit, onPressed: onEdit, tooltip: 'Editar'),
            Accion(
              icono: Icons.delete,
              onPressed: onDelete,
              tooltip: 'Eliminar',
            ),
          ],
        ),
        if (onReactivate != null) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onReactivate,
                icon: const Icon(Icons.refresh),
                label: Text('Reactivar cliente', style: GoogleFonts.poppins()),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.orange[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ],
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person_outline_outlined),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AutoSizeText(
                      'Información de ${client.nombre}',
                      style: style.copyWith(fontWeight: FontWeight.bold),
                      minFontSize: 12,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text('Fecha de activación', style: style),
              Row(
                children: [
                  const Icon(Icons.calendar_month_outlined),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      HumanFormats.date(client.fechaCreacion),
                      style: style,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text('Teléfono', style: style),
              Row(
                children: [
                  const Icon(Icons.phone_outlined),
                  const SizedBox(width: 8),
                  Flexible(child: Text(client.telefono, style: style)),
                ],
              ),
              const SizedBox(height: 15),
              Text('Dirección', style: style),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AutoSizeText(
                      client.direccion,
                      style: style,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text('Número de identificación', style: style),
              Row(
                children: [
                  const Icon(Icons.fingerprint_outlined),
                  const SizedBox(width: 8),
                  Flexible(child: Text(client.dni, style: style)),
                ],
              ),
              const SizedBox(height: 15),
              Text('Edad', style: style),
              Row(
                children: [
                  const Icon(Icons.calendar_month_outlined),
                  const SizedBox(width: 8),
                  Flexible(child: Text('${client.edad}', style: style)),
                ],
              ),
              const SizedBox(height: 15),
              Text('Contacto', style: style.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tooltip(
                    message: 'Llamar',
                    child: IconButton(
                      icon: const Icon(Icons.phone),
                      color: Colors.blue,
                      onPressed: () =>
                          launchUrl(Uri.parse('tel:${client.telefono}')),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Tooltip(
                    message: 'Enviar mensaje',
                    child: IconButton(
                      icon: const Icon(Icons.sms),
                      color: Colors.green,
                      onPressed: () =>
                          launchUrl(Uri.parse('sms:${client.telefono}')),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Tooltip(
                    message: 'WhatsApp',
                    child: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.whatsapp),
                      color: const Color(0xFF25D366),
                      onPressed: () => launchUrl(
                        Uri.parse(
                            'https://wa.me/${client.telefono.replaceAll(RegExp(r'[^0-9]'), '')}'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.credit_card_rounded),
                  const SizedBox(width: 8),
                  Text(
                    'Perfil crediticio',
                    style: style.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text('Préstamos', style: style),
              ClienteStatsSection(
                totalPrestamos: detalle.totalPrestamos,
                totalPrestamosActivos: detalle.totalPrestamosActivos,
                totalPrestamosFinalizados: detalle.totalPrestamosFinalizados,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total prestado:', style: style),
                  Flexible(
                    child: Text(
                      HumanFormats.monuted(detalle.totalPrestado),
                      style: style.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total pagado:', style: style),
                  Flexible(
                    child: Text(
                      HumanFormats.monuted(detalle.totalDeudaPagada),
                      style: style.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Saldo vigente:', style: style),
                  Flexible(
                    child: Text(
                      HumanFormats.monuted(
                        (detalle.totalPrestado - detalle.totalDeudaPagada)
                            .clamp(0, double.infinity),
                      ),
                      style: style.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(),
        ClientePrestamosList(
          prestamos: detalle.prestamos,
          idDeudor: detalle.cliente.idDeudor,
          nombreDeudor: detalle.cliente.nombre,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
