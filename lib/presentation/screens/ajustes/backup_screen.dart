import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:prestapagos/domain/entities/backup/backup_status.dart';
import 'package:prestapagos/presentation/providers/config/config_providers.dart';
import 'package:prestapagos/presentation/widgets/widgets.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  static const name = 'backup-screen';

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(backupProvider, (previous, next) {
      if (next.currentStatus == BackupStatusEnum.success) {
        Fluttertoast.showToast(
          msg: next.currentMessage,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else if (next.currentStatus == BackupStatusEnum.failed) {
        Fluttertoast.showToast(
          msg: next.currentMessage,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final backupState = ref.watch(backupProvider);
    final account = ref.watch(accountProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => context.pop(),
                ),
                floating: true,
                flexibleSpace: const FlexibleSpaceBar(
                  title: CustomAppbar(title: 'Respaldo'),
                  titlePadding: EdgeInsets.only(left: 30.0),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                  const SizedBox(height: 16),
                  if (!account.isLinked) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Vincula tu cuenta de Google en Ajustes > Mi cuenta para poder realizar respaldos.',
                              style: TextStyle(color: Colors.orange.shade900),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  ListTile(
                    title: const Text('Último respaldo'),
                    subtitle: Text(
                      backupState.lastSuccessfulBackup != null
                          ? DateFormat(
                              'dd/MM/yyyy HH:mm',
                            ).format(backupState.lastSuccessfulBackup!)
                          : 'Sin respaldos previos',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: backupState.isRunning
                        ? null
                        : () =>
                              ref.read(backupProvider.notifier).performBackup(),
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Respaldar ahora'),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.tonalIcon(
                    onPressed: backupState.isRunning
                        ? null
                        : () => _confirmRestore(context, ref),
                    icon: const Icon(Icons.cloud_download),
                    label: const Text('Restaurar'),
                  ),
                  const SizedBox(height: 24),
                  SwitchListTile(
                    title: const Text('Respaldos automáticos'),
                    subtitle: Text(
                      backupState.isAutoBackupEnabled
                          ? 'Activado'
                          : 'Desactivado',
                    ),
                    value: backupState.isAutoBackupEnabled,
                    onChanged: (v) =>
                        ref.read(backupProvider.notifier).setAutoBackup(v),
                  ),
                  if (backupState.isAutoBackupEnabled) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Los respaldos automáticos se ejecutan a las 2:30 AM',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RadioGroup<BackupFrequency>(
                      groupValue: backupState.frequency,
                      onChanged: (v) {
                        if (v != null) {
                          ref.read(backupProvider.notifier).setFrequency(v);
                        }
                      },
                      child: Column(
                        children: [
                          RadioListTile<BackupFrequency>(
                            title: const Text('Diario'),
                            value: BackupFrequency.daily,
                          ),
                          RadioListTile<BackupFrequency>(
                            title: const Text('Semanal'),
                            value: BackupFrequency.weekly,
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  ]),
                ),
              ),
            ],
          ),
          if (backupState.isRunning) const FullScreenLoader(),
        ],
      ),
    );
  }

  void _confirmRestore(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restaurar respaldo'),
        content: const Text(
          'Se descargará el respaldo más reciente y se reemplazarán todos los datos locales. '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(backupProvider.notifier).performRestore();
            },
            child: const Text('Restaurar'),
          ),
        ],
      ),
    );
  }
}
