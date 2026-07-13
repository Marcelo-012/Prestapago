import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:prestapagos/presentation/providers/config/config_providers.dart';

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
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
                    onPressed: () => ref.read(accountProvider.notifier).unlinkAccount(),
                    tooltip: 'Desvincular',
                  )
                : FilledButton.tonal(
                    onPressed: () => ref.read(accountProvider.notifier).linkAccount(),
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
          const SizedBox(height: 24),
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
