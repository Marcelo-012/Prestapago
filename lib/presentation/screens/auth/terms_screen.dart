import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/presentation/providers/providers.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsScreen extends ConsumerStatefulWidget {
  static const name = 'terms';

  const TermsScreen({super.key});

  @override
  ConsumerState<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends ConsumerState<TermsScreen> {
  final _scrollController = ScrollController();
  bool _canAccept = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final accepted = currentScroll >= maxScroll - 10;
    if (accepted != _canAccept) {
      setState(() => _canAccept = accepted);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Icon(
                      Icons.shield_outlined,
                      size: 48,
                      color: colors.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aviso de Privacidad — PRESTAPAGO',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Última actualización: 17 de julio de 2026',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _sectionText(
                      'Este Aviso de Privacidad describe cómo se maneja la información en la '
                      'aplicación, en cumplimiento de los principios generales de protección de '
                      'datos personales reconocidos internacionalmente.',
                    ),
                    _divider(),
                    _title('1. Identidad y domicilio del responsable'),
                    _sectionText(
                      'Responsable: Rivero Martínez Marcelo Emmanuel\n\n'
                      'Domicilio: Oaxaca, México\n\n'
                      'Correo de contacto: dev.merm.support@gmail.com\n\n'
                      'PRESTAPAGO es una aplicación de gestión de préstamos diseñada para uso '
                      'personal del usuario (prestamista), quien a su vez captura datos de sus '
                      'propios clientes (deudores) dentro de la app.\n\n'
                      'Nota importante: El usuario de PRESTAPAGO (el prestamista) actúa como '
                      'responsable de los datos de sus deudores que captura en la app. PRESTAPAGO '
                      'actúa únicamente como proveedor de la herramienta tecnológica, ya que no '
                      'recibe, almacena en servidores propios, ni tiene acceso a dichos datos.',
                    ),
                    _divider(),
                    _title('2. Datos personales que se recopilan'),
                    _sectionText(
                      'Dentro de la app, el usuario (prestamista) puede registrar los siguientes '
                      'datos de sus deudores:\n\n'
                      '• Nombre completo\n'
                      '• Teléfono\n'
                      '• Identificación oficial / DNI o CURP\n'
                      '• Dirección\n'
                      '• Correo electrónico (opcional)\n'
                      '• Información financiera: montos de préstamos, tasas de interés, historial '
                      'de pagos, saldos, moras y adeudos\n\n'
                      'Adicionalmente, si el usuario activa el inicio de sesión con Google, se '
                      'recopila:\n\n'
                      '• Nombre y correo asociado a la cuenta de Google (usado únicamente para '
                      'vincular el respaldo en Drive y personalizar recibos generados por la app)\n\n'
                      'No se recopilan datos financieros sensibles como números de tarjetas '
                      'bancarias, salvo que el propio usuario decida anotarlos manualmente en '
                      'algún campo de texto libre, lo cual no es recomendable.',
                    ),
                    _divider(),
                    _title('3. Dónde se almacenan los datos'),
                    _sectionText(
                      'Todos los datos capturados se almacenan exclusivamente en el dispositivo '
                      'del usuario, en una base de datos local (SQLite). PRESTAPAGO no cuenta con '
                      'servidores propios y no transmite datos a terceros de forma automática.\n\n'
                      'Esto significa que:\n\n'
                      '• Si el usuario desinstala la app o borra sus datos, la información se '
                      'elimina de forma permanente.\n'
                      '• Ningún desarrollador ni tercero tiene acceso remoto a la información '
                      'almacenada localmente.',
                    ),
                    _divider(),
                    _title('4. Respaldo en Google Drive (opcional)'),
                    _sectionText(
                      'PRESTAPAGO ofrece una función opcional de respaldo (backup) de la base de '
                      'datos hacia la cuenta personal de Google Drive del propio usuario.\n\n'
                      '• Esta función no se activa automáticamente; el usuario decide cuándo '
                      'generar un respaldo y cuándo restaurarlo.\n'
                      '• El archivo de respaldo se almacena en el Drive personal del usuario, bajo '
                      'su propio control y cuenta de Google — no en un servidor de PRESTAPAGO.\n'
                      '• El usuario puede eliminar estos respaldos en cualquier momento desde su '
                      'propia cuenta de Google Drive.\n'
                      '• El acceso de la app a Drive puede ser revocado en cualquier momento desde '
                      'la configuración de la cuenta de Google del usuario ',
                    ),
                    _linkText(
                      'myaccount.google.com/permissions',
                      'https://myaccount.google.com/permissions',
                    ),
                    _sectionText('.'),
                    _divider(),
                    _title('5. Uso de Google Sign-In'),
                    _sectionText(
                      'El inicio de sesión con Google se utiliza únicamente para:\n\n'
                      '1. Vincular la cuenta de Google Drive del usuario para la función de '
                      'respaldo.\n'
                      '2. Obtener el nombre asociado a la cuenta para personalizar recibos '
                      'generados dentro de la app.\n\n'
                      'No se utiliza para publicidad, rastreo, análisis de comportamiento ni se '
                      'comparte con terceros con fines comerciales.',
                    ),
                    _divider(),
                    _title('6. Notificaciones'),
                    _sectionText(
                      'La app puede generar notificaciones locales (recordatorios de pago, '
                      'vencimientos, moras). Estas notificaciones se procesan enteramente en el '
                      'dispositivo y no requieren envío de datos a servidores externos.',
                    ),
                    _divider(),
                    _title('7. Seguridad de la información'),
                    _sectionText(
                      'Dado que los datos residen en el dispositivo del usuario:\n\n'
                      '• Los datos no salen del dispositivo, salvo que el usuario active '
                      'manualmente el respaldo en Google Drive.\n'
                      '• Se recomienda al usuario proteger el acceso a su dispositivo (PIN, '
                      'huella, etc.) ya que él es responsable de la seguridad física del equipo '
                      'donde se almacena la información de sus clientes.\n'
                      '• PRESTAPAGO no transmite, vende ni comparte datos con anunciantes, '
                      'brokers de datos ni terceros.',
                    ),
                    _divider(),
                    _title('8. Derechos ARCO y control del usuario'),
                    _sectionText(
                      'El usuario tiene en todo momento la posibilidad de ejercer control directo '
                      'sobre los datos, sin necesidad de intermediarios, mediante:\n\n'
                      '• Acceso y rectificación: editar cualquier dato de un deudor directamente '
                      'en la app.\n'
                      '• Cancelación: eliminar registros individuales o borrar toda la base de '
                      'datos desde Ajustes → Borrar datos, o desinstalando la aplicación.\n'
                      '• Oposición / limitación: desactivar el respaldo en Google Drive o revocar '
                      'el acceso a Google en cualquier momento.\n\n'
                      'Para dudas relacionadas con el tratamiento de datos dentro de la app (no de '
                      'terceros), el usuario puede contactar a: dev.merm.support@gmail.com',
                    ),
                    _divider(),
                    _title('9. Transferencia de datos'),
                    _sectionText(
                      'PRESTAPAGO no realiza transferencias de datos a terceros. La única '
                      '"transferencia" que ocurre es el respaldo voluntario que el propio usuario '
                      'hace a su cuenta personal de Google Drive, bajo los términos de servicio de '
                      'Google, ajenos a PRESTAPAGO.',
                    ),
                    _divider(),
                    _title('10. Cambios al presente Aviso de Privacidad'),
                    _sectionText(
                      'Cualquier modificación a este Aviso será notificada al usuario al abrir la '
                      'aplicación después de una actualización, y estará disponible en todo '
                      'momento dentro de la sección de Ajustes de la app.',
                    ),
                    _divider(),
                    _title('Resumen en lenguaje simple'),
                    _sectionBold(
                      'Todo se queda en tu teléfono. Si activas el respaldo en Google Drive, tú '
                      'decides cuándo y qué se sube, y puedes borrarlo cuando quieras. No vendemos '
                      'ni compartimos nada con nadie.',
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(
                  top: BorderSide(color: colors.outlineVariant),
                ),
              ),
              child: FilledButton(
                onPressed: _canAccept
                    ? () => ref.read(acceptTermsProvider).call()
                    : null,
                child: Text(_canAccept ? 'Aceptar' : 'Desliza hasta abajo para aceptar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _sectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          height: 1.5,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _sectionBold(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.5,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _linkText(String text, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 14,
            height: 1.5,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Divider(color: Colors.grey.shade300),
    );
  }
}
