import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/presentation/providers/config/theme_provider.dart';

final authSkippedProvider = Provider<bool>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return prefs.getBool('auth_skipped') ?? false;
});

final skipAuthProvider = Provider<void Function()>((ref) {
  return () {
    ref.read(sharedPrefsProvider).setBool('auth_skipped', true);
    ref.invalidate(authSkippedProvider);
  };
});
