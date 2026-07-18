import 'package:flutter/foundation.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class SecureStorageDatasource {
  static const String _refreshTokenKey = 'google_refresh_token';

  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      keyCipherAlgorithm:
          KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  final _logger = Logger(level: kReleaseMode ? Level.off : Level.trace);
  String? _accessTokenInMemory;

  // ============ BÓVEDA EN DISCO (REFRESH TOKEN) ============

  Future<void> saveRefreshToken(String token) async {
    try {
      await _secureStorage.write(key: _refreshTokenKey, value: token);
      _logger.i('Refresh Token guardado en bóveda segura');
    } catch (e, stack) {
      _logger.e('Error guardando Refresh Token', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _refreshTokenKey);
    } catch (e, stack) {
      _logger.e('Error leyendo Refresh Token', error: e, stackTrace: stack);
      return null;
    }
  }

  // ============ VOLÁTIL EN RAM (ACCESS TOKEN) ============

  void setAccessTokenInMemory(String token) {
    _accessTokenInMemory = token;
    _logger.i('Access Token cargado en RAM (expira en 60 min)');
  }

  String? getAccessTokenFromMemory() => _accessTokenInMemory;

  void clearAccessTokenFromMemory() {
    _accessTokenInMemory = null;
    _logger.i('Access Token borrado de RAM');
  }

  // ============ LIMPIEZA TOTAL ============

  Future<void> clearAuthTokens() async {
    try {
      await _secureStorage.delete(key: _refreshTokenKey);
      clearAccessTokenFromMemory();
      _logger.i('Tokens de autenticación revocados y eliminados por completo');
    } catch (e, stack) {
      _logger.e('Error limpiando datos de autenticación seguros', error: e, stackTrace: stack);
      rethrow;
    }
  }
}
