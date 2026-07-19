import 'package:flutter/material.dart';

class ErrorWidgetCustom extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const ErrorWidgetCustom({super.key, required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: colors.error),
            const SizedBox(height: 16),
            Text(
              'Error al cargar datos',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: colors.error),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.tonalIcon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
