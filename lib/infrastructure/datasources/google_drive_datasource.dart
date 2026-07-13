import 'dart:io';
import 'package:prestapagos/config/constants/backup_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:prestapagos/config/errors/backup_exceptions.dart';

class GoogleDriveDatasource {
  late drive.DriveApi _driveApi;
  final _logger = Logger(
    level: kReleaseMode ? Level.warning : Level.trace,
  );

  GoogleDriveDatasource();

  Future<void> initialize(String accessToken) async {
    try {
      final httpClient = _createHttpClient(accessToken);
      _driveApi = drive.DriveApi(httpClient);
      _logger.i('GoogleDriveDatasource inicializado');
    } catch (e) {
      _logger.e('Error inicializando GoogleDriveDatasource: $e');
      rethrow;
    }
  }

  Client _createHttpClient(String accessToken) {
    final client = Client();
    return _AuthenticatedClient(client, accessToken);
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  String _generateBackupFilename() {
    final now = DateTime.now();
    final fecha = '${now.year}-${_pad(now.month)}-${_pad(now.day)}';
    final hora = '${_pad(now.hour)}-${_pad(now.minute)}-${_pad(now.second)}';
    return '${BackupConstants.backupFilePrefix}${fecha}_$hora${BackupConstants.backupFileExtension}';
  }

  // ============ OPERACIONES DE ENTRADA / SALIDA ============

  Future<String> uploadBackup(
    File databaseFile, {
    void Function(double)? onProgress,
  }) async {
    try {
      _logger.i('Iniciando subida de respaldo...');

      if (!await databaseFile.exists()) {
        throw BackupException(
          message: 'Archivo de base de datos no encontrado',
          code: 'FILE_NOT_FOUND',
        );
      }

      final fileSize = await databaseFile.length();
      _logger.i('Tamaño del archivo: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB');

      final tempFile = File('${databaseFile.parent.path}/temp_backup_${DateTime.now().millisecondsSinceEpoch}.db');
      await databaseFile.copy(tempFile.path);
      _logger.i('Copia temporal creada en: ${tempFile.path}');

      try {
        final media = drive.Media(
          tempFile.openRead(),
          fileSize,
        );

        final driveFile = drive.File()
          ..name = _generateBackupFilename()
          ..mimeType = 'application/octet-stream'
          ..description = 'Respaldo automático PRESTAPAGO - ${DateTime.now()}'
          ..parents = ['appDataFolder'];

        final result = await _driveApi.files.create(
          driveFile,
          uploadMedia: media,
          $fields: 'id',
        );

        _logger.i('✅ Respaldo subido exitosamente a Drive ID: ${result.id}');
        return result.id ?? '';
      } finally {
        if (await tempFile.exists()) {
          await tempFile.delete();
          _logger.i('Archivo temporal limpio');
        }
      }
    } catch (e, stack) {
      _logger.e('Error subiendo respaldo a Drive: $e', stackTrace: stack);
      if (e is BackupException) rethrow;
      throw BackupException(
        message: 'Error durante la subida: ${e.toString()}',
        code: 'UPLOAD_FAILED',
        originalError: e,
      );
    }
  }

  Future<File> downloadLatestBackup(Directory destinationDir, {void Function(double)? onProgress}) async {
    try {
      _logger.i('Buscando respaldo en Google Drive...');

      final files = await _driveApi.files.list(
        q: "name contains '${BackupConstants.backupFilePrefix}' and trashed = false",
        spaces: 'appDataFolder',
        pageSize: 1,
        orderBy: 'modifiedTime desc',
        $fields: 'files(id, name, modifiedTime, size)',
      );

      if (files.files == null || files.files!.isEmpty) {
        throw BackupException(
          message: 'No hay respaldos disponibles en Google Drive',
          code: 'NO_BACKUPS_FOUND',
        );
      }

      final remoteFile = files.files!.first;
      _logger.i('Respaldo encontrado: ${remoteFile.name} (${remoteFile.size} bytes)');

      final tempFile = File('${destinationDir.path}/temporal_${DateTime.now().millisecondsSinceEpoch}.db');
      final media = await _driveApi.files.get(
        remoteFile.id!,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      await media.stream.pipe(tempFile.openWrite());
      _logger.i('Descarga guardada en cache: ${tempFile.path}');

      if (await tempFile.length() == 0) {
        await tempFile.delete();
        throw CorruptedBackupException();
      }

      return tempFile;
    } catch (e, stack) {
      _logger.e('Error descargando respaldo desde Drive: $e', stackTrace: stack);
      if (e is BackupException) rethrow;
      throw BackupException(
        message: 'Error durante la descarga: ${e.toString()}',
        code: 'DOWNLOAD_FAILED',
        originalError: e,
      );
    }
  }

  Future<bool> validateDatabaseIntegrity(File dbFile) async {
    try {
      final bytes = await dbFile.readAsBytes();
      if (bytes.length < 16) return false;

      final header = String.fromCharCodes(bytes.sublist(0, 16));
      if (!header.startsWith('SQLite format 3')) {
        _logger.w('El archivo descargado no posee firma válida de SQLite');
        return false;
      }

      _logger.i('✅ Integridad del binario SQLite confirmada');
      return true;
    } catch (e) {
      _logger.e('Error validando integridad física: $e');
      return false;
    }
  }

  Future<void> cleanupOldBackups() async {
    try {
      final files = await _driveApi.files.list(
        q: "name contains '${BackupConstants.backupFilePrefix}' and trashed = false",
        spaces: 'appDataFolder',
        orderBy: 'modifiedTime desc',
        $fields: 'files(id, name, modifiedTime)',
      );

      final allFiles = files.files ?? [];
      if (allFiles.length <= BackupConstants.maxBackupsToKeep) return;

      final toDelete = allFiles.sublist(BackupConstants.maxBackupsToKeep);
      for (final file in toDelete) {
        if (file.id != null) {
          await _driveApi.files.delete(file.id!);
          _logger.i('Backup antiguo eliminado: ${file.name}');
        }
      }
    } catch (e) {
      _logger.e('Error limpiando backups antiguos: $e');
    }
  }
}

class _AuthenticatedClient extends BaseClient {
  final Client _inner;
  final String _accessToken;

  _AuthenticatedClient(this._inner, this._accessToken);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $_accessToken';
    return _inner.send(request);
  }
}
