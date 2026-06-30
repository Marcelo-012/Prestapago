import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:prestapagos/config/constants/backup_constants.dart';
import 'package:prestapagos/config/errors/backup_exceptions.dart';
import 'package:prestapagos/infrastructure/datasource/backup/local_backup_datasource.dart';
import 'package:prestapagos/infrastructure/datasource/backup/secure_storage_datasource.dart';

class GoogleAuthDatasource {
  final SecureStorageDatasource secureStorage;
  final LocalBackupDatasource localBackupStorage;
  bool _initialized = false;

  final _logger = Logger(level: kReleaseMode ? Level.warning : Level.trace);

  GoogleAuthDatasource({
    required this.secureStorage,
    required this.localBackupStorage,
  });

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await GoogleSignIn.instance.initialize();
      _initialized = true;
    }
  }

  Future<void> authenticateWithGoogle() async {
    try {
      _logger.i('Iniciando flujo de autenticación Google...');
      await _ensureInitialized();

      final account = await GoogleSignIn.instance.authenticate(
        scopeHint: [BackupConstants.driveScope],
      );

      _logger.i('Usuario autenticado: ${account.email}');

      final authz = await account.authorizationClient.authorizeScopes(
        [BackupConstants.driveScope],
      );

      secureStorage.setAccessTokenInMemory(authz.accessToken);

      await localBackupStorage.setUserEmail(account.email);
      await localBackupStorage.setAccountLinked(true);

      _logger.i('✅ Autenticación exitosa: ${account.email}');
    } on BackupException {
      rethrow;
    } catch (e, stack) {
      _logger.e('Error en autenticación: $e', stackTrace: stack);
      throw AuthenticationFailedException(e.toString());
    }
  }

  Future<String?> silentlyRefreshAccessToken() async {
    try {
      _logger.i('Renovando Access Token silenciosamente...');
      await _ensureInitialized();

      if (!localBackupStorage.isAccountLinked()) {
        _logger.w('Cuenta no vinculada, saltando renovación');
        return null;
      }

      final account = await GoogleSignIn.instance.attemptLightweightAuthentication();
      if (account == null) {
        _logger.w('No hay sesión previa disponible');
        return null;
      }

      final authz = await account.authorizationClient.authorizationForScopes(
        [BackupConstants.driveScope],
      );

      if (authz != null) {
        secureStorage.setAccessTokenInMemory(authz.accessToken);
        _logger.i('✅ Access Token renovado');
        return authz.accessToken;
      }

      _logger.w('No se pudo renovar el token sin interacción del usuario');
      return null;
    } catch (e) {
      _logger.e('Error renovando Access Token: $e');
      return null;
    }
  }

  Future<void> disconnectFromGoogle() async {
    try {
      await _ensureInitialized();
      await GoogleSignIn.instance.disconnect();
      _logger.i('✅ Desconexión de Google completada');
    } catch (e) {
      _logger.w('Advertencia al desconectar de Google: $e');
    }
  }
}
