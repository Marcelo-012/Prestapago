import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/presentation/providers/config/theme_provider.dart';

final termsAcceptedProvider = Provider<bool>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return prefs.getBool('terms_accepted') ?? false;
});

final acceptTermsProvider = Provider<void Function()>((ref) {
  return () {
    ref.read(sharedPrefsProvider).setBool('terms_accepted', true);
    ref.invalidate(termsAcceptedProvider);
  };
});
