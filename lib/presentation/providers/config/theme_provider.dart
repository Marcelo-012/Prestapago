import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState {
  final ThemeMode themeMode;
  final FlexScheme flexScheme;

  const ThemeState({
    required this.themeMode,
    required this.flexScheme,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    FlexScheme? flexScheme,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      flexScheme: flexScheme ?? this.flexScheme,
    );
  }
}

class ThemeNotifier extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    final themeModeValue = _prefs.getString('theme_mode') ?? 'system';
    final schemeIndex = _prefs.getInt('flex_scheme') ?? FlexScheme.blumineBlue.index;

    final themeMode = switch (themeModeValue) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    final flexScheme = FlexScheme.values[schemeIndex];

    return ThemeState(themeMode: themeMode, flexScheme: flexScheme);
  }

  SharedPreferences get _prefs => ref.read(sharedPrefsProvider);

  Future<void> setThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setString('theme_mode', value);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setFlexScheme(FlexScheme scheme) async {
    await _prefs.setInt('flex_scheme', scheme.index);
    state = state.copyWith(flexScheme: scheme);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(
  ThemeNotifier.new,
);

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized before use');
});
