import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/infrastructure/datasources/datasources.dart';

class AccountState {
  final bool isLinked;
  final String? name;
  final String? email;
  final String? photoUrl;

  const AccountState({
    required this.isLinked,
    this.name,
    this.email,
    this.photoUrl,
  });
}

class AccountNotifier extends Notifier<AccountState> {
  @override
  AccountState build() {
    final localBackup = ref.read(localBackupDatasourceProvider);
    return _fromLocalBackup(localBackup);
  }

  Future<void> linkAccount() async {
    final auth = ref.read(googleAuthDatasourceProvider);
    await auth.authenticateWithGoogle();
    _refresh();
  }

  Future<void> unlinkAccount() async {
    try {
      final auth = ref.read(googleAuthDatasourceProvider);
      final localBackup = ref.read(localBackupDatasourceProvider);
      await auth.disconnectFromGoogle();
      await localBackup.clearLocalBackupData();
      _refresh();
    } catch (e) {
      debugPrint('Error al desvincular cuenta: $e');
    }
  }

  void _refresh() {
    final localBackup = ref.read(localBackupDatasourceProvider);
    state = _fromLocalBackup(localBackup);
  }

  AccountState _fromLocalBackup(LocalBackupDatasource localBackup) {
    return AccountState(
      isLinked: localBackup.isAccountLinked(),
      name: localBackup.getUserName(),
      email: localBackup.getUserEmail(),
      photoUrl: localBackup.getUserPhotoUrl(),
    );
  }
}

final accountProvider = NotifierProvider<AccountNotifier, AccountState>(
  AccountNotifier.new,
);

final googleAuthDatasourceProvider = Provider<GoogleAuthDatasource>((ref) {
  throw UnimplementedError('GoogleAuthDatasource must be initialized');
});

final localBackupDatasourceProvider = Provider<LocalBackupDatasource>((ref) {
  throw UnimplementedError('LocalBackupDatasource must be initialized');
});

final secureStorageDatasourceProvider = Provider<SecureStorageDatasource>((ref) {
  throw UnimplementedError('SecureStorageDatasource must be initialized');
});
