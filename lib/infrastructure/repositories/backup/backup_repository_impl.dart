import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:prestapagos/config/errors/errors.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/database/database.dart';
import 'package:prestapagos/infrastructure/datasources/datasources.dart';

class BackupRepositoryImpl implements BackupRepository {
  final GoogleAuthDatasource _authDatasource;
  final GoogleDriveDatasource _driveDatasource;
  final LocalBackupDatasource _localBackupDatasource;
  final SecureStorageDatasource _secureStorageDatasource;
  final File _databaseFile;
  final AppDatabase? _database;

  final _logger = Logger(level: kReleaseMode ? Level.off : Level.trace);

  BackupRepositoryImpl({
    required this._authDatasource,
    required this._driveDatasource,
    required this._localBackupDatasource,
    required this._secureStorageDatasource,
    required this._databaseFile,
    this._database,
  });

  @override
  Stream<BackupStatus> performBackup() async* {
    try {
      yield BackupStatus(
        status: BackupStatusEnum.authenticating,
        message: 'Verificando requisitos del sistema...',
      );

      if (!await _checkInternetConnection()) throw NoInternetException();
      if (!await _checkBatteryLevel()) throw LowBatteryException();
      if (!await _checkDiskSpace()) throw DiskSpaceException();

      yield BackupStatus(
        status: BackupStatusEnum.authenticating,
        message: 'Sincronizando credenciales...',
      );

      final accessToken = await _authDatasource.silentlyRefreshAccessToken();
      if (accessToken == null ||
          _secureStorageDatasource.getAccessTokenFromMemory() == null) {
        throw AuthenticationFailedException(
          'Sesión de Google expirada o inválida',
        );
      }

      await _driveDatasource.initialize(accessToken);

      yield BackupStatus(
        status: BackupStatusEnum.uploading,
        message: 'Subiendo respaldo a la nube...',
        progress: 0.0,
      );

      await _driveDatasource.uploadBackup(_databaseFile);

      await _driveDatasource.cleanupOldBackups();

      yield BackupStatus(
        status: BackupStatusEnum.validating,
        message: 'Consolidando registros locales...',
        progress: 1.0,
      );

      await _localBackupDatasource.setLastBackupTime(DateTime.now());
      await _localBackupDatasource.setBackupStatus('Exitoso');

      yield BackupStatus(
        status: BackupStatusEnum.success,
        message: 'Respaldo completado exitosamente',
        progress: 1.0,
        lastSuccessfulBackup: DateTime.now(),
      );

      _logger.i('✅ Flujo asíncrono de respaldo finalizado con éxito');
    } on BackupException catch (e, stack) {
      _logger.e('Fallo controlado en operación de copia: ${e.message}', error: e, stackTrace: stack);
      yield BackupStatus(
        status: BackupStatusEnum.failed,
        message: mapErrorToMessage(e),
        errorCode: e.code,
      );
    } catch (e, stack) {
      _logger.e('Fallo crítico no controlado: $e', stackTrace: stack);
      yield BackupStatus(
        status: BackupStatusEnum.failed,
        message: 'Error inesperado durante el procesamiento',
        errorCode: 'UNKNOWN',
      );
    }
  }

  @override
  Stream<BackupStatus> performRestore() async* {
    try {
      yield BackupStatus(
        status: BackupStatusEnum.downloading,
        message: 'Analizando entorno local...',
      );

      if (!await _checkInternetConnection()) throw NoInternetException();

      final backupPath = '${_databaseFile.parent.path}/respaldo_previo_temp.db';
      final backupFile = File(backupPath);
      if (await backupFile.exists()) {
        await backupFile.delete();
      }

      yield BackupStatus(
        status: BackupStatusEnum.authenticating,
        message: 'Validando tokens de seguridad...',
      );

      final accessToken = await _authDatasource.silentlyRefreshAccessToken();
      if (accessToken == null) {
        throw AuthenticationFailedException('Acceso denegado');
      }

      await _driveDatasource.initialize(accessToken);

      yield BackupStatus(
        status: BackupStatusEnum.downloading,
        message: 'Descargando datos desde la nube...',
        progress: 0.2,
      );

      final tempFile = await _driveDatasource.downloadLatestBackup(
        _databaseFile.parent,
      );

      yield BackupStatus(
        status: BackupStatusEnum.validating,
        message: 'Validando estructura e integridad...',
        progress: 0.7,
      );

      final isValid = await _driveDatasource.validateDatabaseIntegrity(
        tempFile,
      );
      if (!isValid) {
        if (await tempFile.exists()) await tempFile.delete();
        throw CorruptedBackupException();
      }

      yield BackupStatus(
        status: BackupStatusEnum.restoring,
        message: 'Reemplazando almacenamiento local...',
        progress: 0.9,
      );

      if (_database != null) {
        await _database.close();
      }

      if (await _databaseFile.exists()) {
        await _databaseFile.rename(backupPath);
      }

      try {
        await tempFile.rename(_databaseFile.path);

        if (await backupFile.exists()) await backupFile.delete();
      } catch (e) {
        if (await backupFile.exists()) {
          await backupFile.rename(_databaseFile.path);
        }
        rethrow;
      }

      await _localBackupDatasource.setLastBackupTime(DateTime.now());
      await _localBackupDatasource.setBackupStatus('Restaurado');

      yield BackupStatus(
        status: BackupStatusEnum.success,
        message: 'Restauración completada. Reiniciando base de datos...',
        progress: 1.0,
      );
      _logger.i('✅ Reemplazo atómico de base de datos finalizado con éxito');
    } on BackupException catch (e, stack) {
      _logger.e('Fallo controlado en restauración de datos: ${e.message}', error: e, stackTrace: stack);
      yield BackupStatus(
        status: BackupStatusEnum.failed,
        message: mapErrorToMessage(e),
        errorCode: e.code,
      );
    } catch (e, stack) {
      _logger.e('Fallo crítico no controlado en restauración: $e', stackTrace: stack);
      yield BackupStatus(
        status: BackupStatusEnum.failed,
        message: 'Error inesperado durante la restauración',
        errorCode: 'UNKNOWN',
      );
    }
  }

  // ============ COMPLEMENTOS DE HARDWARE (MOCKADOS PARA FASE 8) ============

  Future<bool> _checkInternetConnection() async {
    final connectivity = await Connectivity().checkConnectivity();
    return connectivity.contains(ConnectivityResult.wifi) ||
        connectivity.contains(ConnectivityResult.mobile) ||
        connectivity.contains(ConnectivityResult.ethernet);
  }

  Future<bool> _checkBatteryLevel() async => true;
  Future<bool> _checkDiskSpace() async => true;
}
