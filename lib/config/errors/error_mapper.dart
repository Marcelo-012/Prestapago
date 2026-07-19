import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'package:prestapagos/config/errors/backup_exceptions.dart';

String mapErrorToMessage(Object? error) {
  if (error is SocketException ||
      error is HttpException ||
      error is HandshakeException) {
    return 'No hay conexión a internet. Por favor, revisa tu red e intenta de nuevo.';
  }

  if (error is TimeoutException) {
    return 'No hay conexión a internet. Por favor, revisa tu red e intenta de nuevo.';
  }

  final errorStr = error.toString();

  if (errorStr.contains('Failed host lookup') ||
      errorStr.contains('Connection refused') ||
      errorStr.contains('Connection reset')) {
    return 'No hay conexión a internet. Por favor, revisa tu red e intenta de nuevo.';
  }

  if (error is PlatformException ||
      errorStr.contains('401') ||
      errorStr.contains('403') ||
      errorStr.contains('AUTH_FAILED')) {
    return 'Problema de autenticación. Verifica tus permisos o vuelve a iniciar sesión.';
  }

  if (errorStr.contains('500') ||
      errorStr.contains('502') ||
      errorStr.contains('503')) {
    return 'El servicio no está disponible en este momento. Inténtalo más tarde.';
  }

  if (error is FileSystemException ||
      error is DiskSpaceException ||
      error is CorruptedBackupException) {
    return 'Ocurrió un problema al leer o guardar el archivo. Verifica el espacio disponible.';
  }

  if (error is StorageQuotaExceededException) {
    return error.message;
  }

  if (errorStr.contains('El número de identidad ya está registrado')) {
    return 'El número de identidad ya está registrado. Verifica los datos e intenta de nuevo.';
  }

  if (error is BackupException) {
    return switch (error.code) {
      'NO_INTERNET' =>
        'No hay conexión a internet. Por favor, revisa tu red e intenta de nuevo.',
      'AUTH_FAILED' =>
        'Problema de autenticación. Verifica tus permisos o vuelve a iniciar sesión.',
      'LOW_BATTERY' => 'Batería baja. Conecta el cargador antes de continuar.',
      'CANCELLED' => 'Operación cancelada por el usuario.',
      'CORRUPTED' || 'NO_SPACE' || 'FILE_NOT_FOUND' =>
        'Ocurrió un problema al leer o guardar el archivo. Verifica el espacio disponible.',
      'UPLOAD_FAILED' || 'DOWNLOAD_FAILED' =>
        'El servicio no está disponible en este momento. Inténtalo más tarde.',
      'NO_BACKUPS_FOUND' => 'No hay respaldos disponibles para restaurar.',
      _ => 'Ocurrió un error inesperado. Por favor, intenta de nuevo.',
    };
  }

  return 'Ocurrió un error inesperado. Por favor, intenta de nuevo.';
}
