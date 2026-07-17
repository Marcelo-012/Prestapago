import 'package:drift/drift.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/database/database.dart';

class ReporteCardRepositoryImpl implements ReporteCardRepository {
  final AppDatabase _db;

  ReporteCardRepositoryImpl(this._db);

  @override
  Future<ReporteCard> getReporteCard() async {
    final now = DateTime.now();

    await _db.customStatement("""
      UPDATE amortizaciones SET
        estado_amortizacion = 'atrasado',
        dias_mora = CAST(julianday('now') - julianday(fecha_vencimiento, 'unixepoch') AS INTEGER)
      WHERE estado_amortizacion = 'pendiente'
        AND date(fecha_vencimiento, 'unixepoch') < date('now')
    """);

    await _db.customStatement("""
      UPDATE amortizaciones SET monto_mora = ROUND(
        (monto_capital + monto_interes) * (SELECT tasa_interes_moratoria FROM prestamos
         WHERE id_prestamo = amortizaciones.id_prestamo) / 100.0 /
        CASE WHEN (SELECT periodidad_intereses FROM configuracion_prestamos
         WHERE id_prestamo = amortizaciones.id_prestamo) = 'mensual' THEN 30 ELSE 360 END
        * dias_mora, 2)
      WHERE estado_amortizacion = 'atrasado'
        AND (SELECT tipo_interes FROM configuracion_prestamos
         WHERE id_prestamo = amortizaciones.id_prestamo) = 'compuesto'
        AND monto_mora = 0
    """);

    await _db.customStatement("""
      UPDATE configuracion_prestamos SET estado_prestamo = 'atrasado'
      WHERE id_prestamo IN (
        SELECT DISTINCT id_prestamo FROM amortizaciones
        WHERE estado_amortizacion = 'atrasado'
      )
      AND estado_prestamo NOT IN ('finalizado', 'cancelado')
    """);

    final prestamos = _db.prestamos;
    final amortizaciones = _db.amortizaciones;
    final clientes = _db.deudores;
    final configuracionPrestamos = _db.configuracionPrestamos;

    //Monto total prestado
    final totalPrestadoExpr = prestamos.monto.sum();
    final prestadoQuery = _db.selectOnly(prestamos)
      ..addColumns([totalPrestadoExpr]);
    final totalPrestado =
        (await prestadoQuery.getSingle()).read(totalPrestadoExpr) ?? 0.0;

    //Monto total cobrado
    final totalPagadoExpr = amortizaciones.montoPagado.sum();
    final cobradoQuery = _db.selectOnly(amortizaciones)
      ..addColumns([totalPagadoExpr]);
    final totalPagado =
        (await cobradoQuery.getSingle()).read(totalPagadoExpr) ?? 0.0;

    //Monto total pendiente
    final restanteRow = await _db
        .customSelect(
          'SELECT COALESCE(SUM(monto - COALESCE('
          '(SELECT SUM(monto_pagado) FROM amortizaciones WHERE id_prestamo = p.id_prestamo), 0'
          ')), 0) AS total_restante '
          'FROM prestamos p',
        )
        .getSingle();
    final totalPendiente = restanteRow.read<double>('total_restante');

    //Total de intereses cobrados (histórico)
    final interesesRow = await _db
        .customSelect(
          "SELECT COALESCE(SUM(monto_interes),0) AS total FROM amortizaciones WHERE estado_amortizacion = 'pagado'",
        )
        .getSingle();
    final totalInteresesCobrados = interesesRow.read<double>('total');

    //Total de intereses de mora cobrados (histórico)
    final moraRow = await _db
        .customSelect(
          "SELECT COALESCE(SUM(monto_mora),0) AS total FROM amortizaciones WHERE estado_amortizacion = 'pagado'",
        )
        .getSingle();
    final totalInteresesMoraCobrados = moraRow.read<double>('total');

    //Total prestado este mes
    final yM = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final prestadoMesRow = await _db
        .customSelect(
          "SELECT COALESCE(SUM(monto),0) AS total FROM prestamos WHERE strftime('%Y-%m',fecha_creacion,'unixepoch') = '$yM'",
        )
        .getSingle();
    final totalPrestadoEsteMes = prestadoMesRow.read<double>('total');

    //Total cobrado este mes
    final cobradoMesRow = await _db
        .customSelect(
          "SELECT COALESCE(SUM(monto_pagado),0) AS total FROM amortizaciones WHERE strftime('%Y-%m',fecha_pagado,'unixepoch') = '$yM' AND estado_amortizacion = 'pagado'",
        )
        .getSingle();
    final totalCobradoEsteMes = cobradoMesRow.read<double>('total');

    //Total ganado este mes (intereses + mora)
    final ganadoMesRow = await _db
        .customSelect(
          "SELECT COALESCE(SUM(monto_interes+monto_mora),0) AS total FROM amortizaciones WHERE strftime('%Y-%m',fecha_pagado,'unixepoch') = '$yM' AND estado_amortizacion = 'pagado'",
        )
        .getSingle();
    final totalGanadoEsteMes = ganadoMesRow.read<double>('total');

    //Total de clientes
    final totalClientes = await _db.select(clientes).get();
    final totalClientesCount = totalClientes.length;

    // Total de prestamos
    final totalPrestamos = await _db.select(prestamos).get();
    final totalPrestamosCount = totalPrestamos.length;

    // Total de prestamos activos
    final query = _db.selectOnly(configuracionPrestamos)
      ..addColumns([configuracionPrestamos.id.count()])
      ..where(
        configuracionPrestamos.estadoPrestamo.equalsValue(
              EstadoPrestamo.activo,
            ) |
            configuracionPrestamos.estadoPrestamo.equalsValue(
              EstadoPrestamo.atrasado,
            ),
      );

    final result = await query.getSingle();
    final totalPrestamosActivos =
        result.read(_db.configuracionPrestamos.id.count()) ?? 0;

    return ReporteCard(
      totalPrestado: totalPrestado,
      totalPagado: totalPagado,
      totalPendiente: totalPendiente,
      totalInteresesCobrados: totalInteresesCobrados,
      totalInteresesMoraCobrados: totalInteresesMoraCobrados,
      totalPrestadoEsteMes: totalPrestadoEsteMes,
      totalCobradoEsteMes: totalCobradoEsteMes,
      totalGanadoEsteMes: totalGanadoEsteMes,
      totalPrestamos: totalPrestamosCount,
      totalPrestamosActivos: totalPrestamosActivos,
      totalClientes: totalClientesCount,
    );
  }
}
