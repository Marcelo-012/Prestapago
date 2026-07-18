import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:prestapagos/infrastructure/database/database.dart' as drift;

class EstadoPrestamoService {
  final drift.AppDatabase _db;
  final _logger = Logger(level: kReleaseMode ? Level.off : Level.trace);

  EstadoPrestamoService({required this._db});

  Future<void> actualizarMorosidad({int? idPrestamo}) async {
    final idFilter = idPrestamo != null ? ' AND id_prestamo = $idPrestamo' : '';

    await _db.transaction(() async {
      await _db.customStatement("""
      UPDATE amortizaciones SET
        estado_amortizacion = 'atrasado',
        dias_mora = CAST(julianday('now') - julianday(fecha_vencimiento, 'unixepoch') AS INTEGER)
      WHERE estado_amortizacion IN ('pendiente', 'atrasado')
        AND date(fecha_vencimiento, 'unixepoch') < date('now')
        $idFilter
      """);

      await _db.customStatement("""
      UPDATE amortizaciones SET monto_mora = ROUND(
        (monto_capital + monto_interes) * (SELECT tasa_interes_moratoria FROM prestamos
         WHERE id_prestamo = amortizaciones.id_prestamo) / 100.0 /
        CASE WHEN (SELECT periodidad_intereses FROM configuracion_prestamos
         WHERE id_prestamo = amortizaciones.id_prestamo) = 'mensual' THEN 30 ELSE 360 END
        * dias_mora, 2)
      WHERE estado_amortizacion = 'atrasado'
        $idFilter
      """);

      await _db.customStatement("""
      UPDATE configuracion_prestamos SET estado_prestamo = 'atrasado'
      WHERE 1 = 1
        ${idPrestamo != null ? 'AND id_prestamo = $idPrestamo' : ''}
        AND id_prestamo IN (
          SELECT DISTINCT id_prestamo FROM amortizaciones
          WHERE estado_amortizacion = 'atrasado'
            ${idPrestamo != null ? 'AND id_prestamo = $idPrestamo' : ''}
        )
        AND estado_prestamo NOT IN ('finalizado', 'cancelado', 'incobrable')
      """);
    });

    _logger.i('Morosidad actualizada${idPrestamo != null ? ' para préstamo $idPrestamo' : ''}');
  }

  Future<void> recalcularEstadoPrestamo({int? idPrestamo}) async {
    final idFilter = idPrestamo != null ? ' AND id_prestamo = $idPrestamo' : '';

    await _db.transaction(() async {
      await _db.customStatement("""
        UPDATE configuracion_prestamos SET
          estado_prestamo = 'finalizado',
          fecha_actualizacion = CAST(strftime('%s', 'now') AS INTEGER)
        WHERE estado_prestamo NOT IN ('finalizado', 'cancelado', 'incobrable')
          AND (
            SELECT COUNT(*) FROM amortizaciones a
            WHERE a.id_prestamo = configuracion_prestamos.id_prestamo
              AND a.estado_amortizacion NOT IN ('pagado', 'cancelado')
          ) = 0
          AND (
            SELECT COALESCE(SUM(a.monto_pagado), 0) FROM amortizaciones a
            WHERE a.id_prestamo = configuracion_prestamos.id_prestamo
              AND a.estado_amortizacion = 'pagado'
          ) >= (
            SELECT COALESCE(p.monto, 0) + COALESCE((
              SELECT SUM(a2.monto_interes) FROM amortizaciones a2
              WHERE a2.id_prestamo = p.id_prestamo
                AND a2.estado_amortizacion NOT IN ('cancelado')
            ), 0) FROM prestamos p WHERE p.id_prestamo = configuracion_prestamos.id_prestamo
          )
          $idFilter
      """);

      await _db.customStatement("""
        UPDATE configuracion_prestamos SET
          estado_prestamo = 'atrasado',
          fecha_actualizacion = CAST(strftime('%s', 'now') AS INTEGER)
        WHERE estado_prestamo = 'activo'
          AND EXISTS (
            SELECT 1 FROM amortizaciones a
            WHERE a.id_prestamo = configuracion_prestamos.id_prestamo
              AND a.estado_amortizacion = 'atrasado'
          )
          $idFilter
      """);

      await _db.customStatement("""
        UPDATE configuracion_prestamos SET
          estado_prestamo = 'activo',
          fecha_actualizacion = CAST(strftime('%s', 'now') AS INTEGER)
        WHERE estado_prestamo = 'atrasado'
          AND NOT EXISTS (
            SELECT 1 FROM amortizaciones a
            WHERE a.id_prestamo = configuracion_prestamos.id_prestamo
              AND a.estado_amortizacion = 'atrasado'
          )
          $idFilter
      """);
    });

    _logger.i('Estado recalculado${idPrestamo != null ? ' para préstamo $idPrestamo' : ''}');
  }
}
