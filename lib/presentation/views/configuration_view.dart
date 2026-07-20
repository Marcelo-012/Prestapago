import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:prestapagos/config/errors/error_mapper.dart';
import 'package:prestapagos/presentation/providers/providers.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfigurationView extends ConsumerStatefulWidget {
  const ConfigurationView({super.key});

  @override
  ConsumerState<ConfigurationView> createState() => _ConfigurationViewState();
}

class _ConfigurationViewState extends ConsumerState<ConfigurationView> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() => _appVersion = '${info.version}+${info.buildNumber}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final account = ref.watch(accountProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            flexibleSpace: const FlexibleSpaceBar(
              title: CustomAppbar(title: 'Ajustes'),
              titlePadding: EdgeInsets.only(left: 30.0),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
              const SizedBox(height: 16),
              _sectionHeader('MI CUENTA', theme),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: account.photoUrl != null
                      ? NetworkImage(account.photoUrl!)
                      : null,
                  child: account.photoUrl == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(
                  account.isLinked
                      ? (account.name ?? account.email ?? 'Cuenta vinculada')
                      : 'Cuenta no vinculada',
                ),
                subtitle: account.isLinked
                    ? (account.name != null && account.email != null
                          ? Text(account.email!)
                          : null)
                    : const Text('Vincula tu cuenta de Google'),
                trailing: account.isLinked
                    ? IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () =>
                            ref.read(accountProvider.notifier).unlinkAccount(),
                        tooltip: 'Desvincular',
                      )
                    : FilledButton.tonal(
                        onPressed: () async {
                          try {
                            await ref.read(accountProvider.notifier).linkAccount();
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(mapErrorToMessage(e)),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Vincular'),
                      ),
              ),
              const SizedBox(height: 8),
              _sectionHeader('APARIENCIA', theme),
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Tema y color'),
                subtitle: const Text('Modo claro/oscuro, esquema de color'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/ajustes/apariencia'),
              ),
              const SizedBox(height: 8),
              _sectionHeader('RESPALDO', theme),
              ListTile(
                leading: const Icon(Icons.cloud),
                title: const Text('Respaldo en la nube'),
                subtitle: const Text('Google Drive, programación automática'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/ajustes/respaldo'),
              ),
              const SizedBox(height: 16),
              _sectionHeader('ACERCA DE', theme),
              ListTile(
                title: const Text('PrestaPagos'),
                subtitle: Text(
                  'v$_appVersion\nGestión de préstamos personales',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _sectionHeader('SOPORTE', theme),
              ListTile(
                leading: const Icon(Icons.mail_outline),
                title: const Text('dev.merm.support@gmail.com'),
                subtitle: const Text('Dudas, aclaraciones y soporte'),
                onTap: () {
                  final uri = Uri(
                    scheme: 'mailto',
                    path: 'dev.merm.support@gmail.com',
                  );
                  launchUrl(uri);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Aviso de privacidad y términos'),
                subtitle: const Text('Consulta nuestra política de privacidad'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/ajustes/aviso-privacidad'),
              ),
              const SizedBox(height: 16),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
