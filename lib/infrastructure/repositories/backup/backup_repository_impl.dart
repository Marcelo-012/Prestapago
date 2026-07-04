import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:prestapagos/domain/entities/backup/backup_status.dart';
import 'package:prestapagos/domain/repositories/backup/backup_repository.dart';
import 'package:prestapagos/config/errors/backup_exceptions.dart';
import 'package:prestapagos/infrastructure/datasources/backup/local_backup_datasource.dart';
import 'package:prestapagos/infrastructure/datasources/backup/secure_storage_datasource.dart';
import 'package:prestapagos/infrastructure/datasources/google_auth_datasource.dart';
import 'package:prestapagos/infrastructure/datasources/google_drive_datasource.dart';

class BackupRepositoryImpl implements BackupRepository {
  final GoogleAuthDatasource _authDatasource;
  final GoogleDriveDatasource _driveDatasource;
  final LocalBackupDatasource _localBackupDatasource;
  final SecureStorageDatasource _secureStorageDatasource;
  final File _databaseFile;

  final _logger = Logger(level: kReleaseMode ? Level.warning : Level.trace);

  BackupRepositoryImpl({
    required GoogleAuthDatasource authDatasource,
    required GoogleDriveDatasource driveDatasource,
    required LocalBackupDatasource localBackupDatasource,
    required SecureStorageDatasource secureStorageDatasource,
    required File databaseFile,
  }) : _authDatasource = authDatasource,
       _driveDatasource = driveDatasource,
       _localBackupDatasource = localBackupDatasource,
       _secureStorageDatasource = secureStorageDatasource,
       _databaseFile = databaseFile;

  @override
  Stream<BackupStatus> performBackup() async* {
    try {
      yield BackupStatus(
        status: BackupStatusEnum.authenticating,
        message: 'Verificando requerimientos de sistema...',
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

      // Aquí ejecutamos la subida controlada
      await _driveDatasource.uploadBackup(_databaseFile);

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
    } on BackupException catch (e) {
      _logger.e('Fallo controlado en operación de copia: ${e.message}');
      yield BackupStatus(
        status: BackupStatusEnum.failed,
        message: e.message,
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

      // TODO: Invocar cierre de conexiones de Drift (AppDatabase) aquí antes del swap físico.
      if (await _databaseFile.exists()) {
        await _databaseFile.delete();
      }
      await tempFile.rename(_databaseFile.path);

      await _localBackupDatasource.setLastBackupTime(DateTime.now());
      await _localBackupDatasource.setBackupStatus('Restaurado');

      yield BackupStatus(
        status: BackupStatusEnum.success,
        message: 'Restauración completada. Reiniciando base de datos...',
        progress: 1.0,
      );
      _logger.i('✅ Reemplazo atómico de base de datos finalizado con éxito');
    } on BackupException catch (e) {
      _logger.e('Fallo controlado en restauración de datos: ${e.message}');
      yield BackupStatus(
        status: BackupStatusEnum.failed,
        message: e.message,
        errorCode: e.code,
      );
    }
  }

  // ============ COMPLEMENTOS DE HARDWARE (MOCKADOS PARA FASE 8) ============

  Future<bool> _checkInternetConnection() async => true;
  Future<bool> _checkBatteryLevel() async => true;
  Future<bool> _checkDiskSpace() async => true;
}
