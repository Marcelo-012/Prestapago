import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:prestapagos/config/constants/backup_constants.dart';

class LocalBackupDatasource {
  final SharedPreferences _prefs;
  final _logger = Logger();

  LocalBackupDatasource(this._prefs);

  /// Marca si la cuenta está vinculada a Google Drive
  Future<void> setAccountLinked(bool linked) async {
    await _prefs.setBool(BackupConstants.keyAccountLinked, linked);
    _logger.i('Estado de cuenta actualizado: $linked');
  }

  bool isAccountLinked() {
    return _prefs.getBool(BackupConstants.keyAccountLinked) ?? false;
  }

  Future<void> setUserEmail(String email) async {
    await _prefs.setString(BackupConstants.keyUserEmail, email);
    _logger.i('Email guardado: $email');
  }

  String? getUserEmail() {
    return _prefs.getString(BackupConstants.keyUserEmail);
  }

  Future<void> setUserPhotoUrl(String url) async {
    await _prefs.setString(BackupConstants.keyUserPhotoUrl, url);
    _logger.i('URL de foto guardada');
  }

  String? getUserPhotoUrl() {
    return _prefs.getString(BackupConstants.keyUserPhotoUrl);
  }

  Future<void> setUserName(String name) async {
    await _prefs.setString(BackupConstants.keyUserName, name);
    _logger.i('Nombre guardado: $name');
  }

  String? getUserName() {
    return _prefs.getString(BackupConstants.keyUserName);
  }

  Future<void> setLastBackupTime(DateTime time) async {
    await _prefs.setString(
      BackupConstants.keyLastBackup,
      time.toIso8601String(),
    );
    _logger.i('Último respaldo exitoso: $time');
  }

  DateTime? getLastBackupTime() {
    final timeStr = _prefs.getString(BackupConstants.keyLastBackup);
    return timeStr != null ? DateTime.tryParse(timeStr) : null;
  }

  Future<void> setBackupStatus(String status) async {
    await _prefs.setString(BackupConstants.keyBackupStatus, status);
  }

  String getBackupStatus() {
    return _prefs.getString(BackupConstants.keyBackupStatus) ?? 'Sin respaldar';
  }

  Future<void> setBackupFrequency(String frequency) async {
    await _prefs.setString(BackupConstants.keyBackupFrequency, frequency);
  }

  String getBackupFrequency() {
    return _prefs.getString(BackupConstants.keyBackupFrequency) ?? 'Manual';
  }

  /// Limpia los datos de control locales del respaldo
  Future<void> clearLocalBackupData() async {
    await _prefs.remove(BackupConstants.keyAccountLinked);
    await _prefs.remove(BackupConstants.keyUserEmail);
    await _prefs.remove(BackupConstants.keyUserName);
    await _prefs.remove(BackupConstants.keyUserPhotoUrl);
    await _prefs.remove(BackupConstants.keyLastBackup);
    await _prefs.remove(BackupConstants.keyBackupStatus);
    _logger.i('Datos locales de respaldo eliminados de SharedPreferences');
  }
}
