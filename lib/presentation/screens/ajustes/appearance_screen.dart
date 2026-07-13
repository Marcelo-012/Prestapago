import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/presentation/providers/config/config_providers.dart';

final _flexSchemes = [
  (FlexScheme.blumineBlue, 'Azul', const Color(0xFF3D5AFE)),
  (FlexScheme.tealM3, 'Teal', const Color(0xFF00897B)),
  (FlexScheme.verdunHemlock, 'Verde', const Color(0xFF43A047)),
  (FlexScheme.mango, 'Naranja', const Color(0xFFFF6D00)),
  (FlexScheme.mandyRed, 'Rojo', const Color(0xFFE53935)),
];

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  static const name = 'appearance-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Apariencia')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Modo de tema', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _ThemeModeSelector(current: themeState.themeMode),
          const SizedBox(height: 32),
          Text('Esquema de color', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          ..._flexSchemes.map(
            (s) => _SchemeCard(
              scheme: s.$1,
              name: s.$2,
              color: s.$3,
              isSelected: themeState.flexScheme == s.$1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeModeSelector extends ConsumerWidget {
  final ThemeMode current;

  const _ThemeModeSelector({required this.current});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RadioGroup<ThemeMode>(
      groupValue: current,
      onChanged: (v) {
        if (v != null) {
          ref.read(themeProvider.notifier).setThemeMode(v);
        }
      },
      child: Column(
        children: [
          _ModeRadio(
            value: ThemeMode.light,
            label: 'Claro',
            icon: Icons.light_mode,
          ),
          _ModeRadio(
            value: ThemeMode.dark,
            label: 'Oscuro',
            icon: Icons.dark_mode,
          ),
          _ModeRadio(
            value: ThemeMode.system,
            label: 'Automático',
            icon: Icons.settings_brightness,
          ),
        ],
      ),
    );
  }
}

class _ModeRadio extends StatelessWidget {
  final ThemeMode value;
  final String label;
  final IconData icon;

  const _ModeRadio({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<ThemeMode>(
      value: value,
      title: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }
}

class _SchemeCard extends ConsumerWidget {
  final FlexScheme scheme;
  final String name;
  final Color color;
  final bool isSelected;

  const _SchemeCard({
    required this.scheme,
    required this.name,
    required this.color,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      title: Text(name),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: color)
          : const Icon(Icons.circle_outlined),
      selected: isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? color : Colors.transparent,
          width: 2,
        ),
      ),
      onTap: () => ref.read(themeProvider.notifier).setFlexScheme(scheme),
    );
  }
}
