import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prestapagos/config/errors/errors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestapagos/presentation/providers/providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const name = 'login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_balance_rounded,
                size: 80,
                color: colors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'PrestaPagos',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Administra tus préstamos de forma\nsimple y segura',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 48),
              FilledButton.icon(
                onPressed: _isLoading ? null : _loginWithGoogle,
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.login),
                label: Text(
                  _isLoading ? 'Conectando...' : 'Iniciar con Google',
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _isLoading ? null : _skip,
                child: const Text('Omitir'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(accountProvider.notifier).linkAccount();

      final backupInfo =
          await ref.read(backupProvider.notifier).checkExistingBackups();

      if (backupInfo.hasBackup && mounted) {
        final dateStr = _formatBackupDate(backupInfo.lastBackupDate);
        final restore = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('Respaldo encontrado'),
            content: Text(
              'Se encontró un respaldo en tu Google Drive '
              '${dateStr != null ? 'del $dateStr' : ''}.\n\n'
              '¿Deseas restaurarlo? Tus datos locales serán reemplazados.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('No restaurar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Restaurar'),
              ),
            ],
          ),
        );

        if (restore == true && mounted) {
          await ref.read(backupProvider.notifier).performRestore();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Respaldo restaurado correctamente'),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (mounted) {
            SystemNavigator.pop();
            return;
          }
        }
      }

      if (mounted) context.go('/home/0');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mapErrorToMessage(e)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _formatBackupDate(DateTime? date) {
    if (date == null) return null;
    return '${date.day}/${date.month}/${date.year}';
  }

  void _skip() {
    ref.read(skipAuthProvider).call();
    context.go('/home/0');
  }
}
