import 'package:drift/drift.dart';

import 'package:prestapagos/config/helpers/amortization_calculator.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/database/database.dart';

Future<void> seedDatabase(AppDatabase db) async {
  await db.batch((batch) {
    // ── DEUDORES ──
    final deudores = [
      (
        nombre: 'Juan Pérez',
        telefono: '5550101',
        email: 'juan@mail.com',
        direccion: 'Calle 1 #123',
        numId: 'ID001',
        edad: 35,
      ),
      (
        nombre: 'María García',
        telefono: '5550102',
        email: 'maria@mail.com',
        direccion: 'Calle 2 #456',
        numId: 'ID002',
        edad: 28,
      ),
      (
        nombre: 'Carlos López',
        telefono: '5550103',
        email: 'carlos@mail.com',
        direccion: 'Calle 3 #789',
        numId: 'ID003',
        edad: 42,
      ),
      (
        nombre: 'Ana Martínez',
        telefono: '5550104',
        email: 'ana@mail.com',
        direccion: 'Calle 4 #321',
        numId: 'ID004',
        edad: 30,
      ),
      (
        nombre: 'Pedro Sánchez',
        telefono: '5550105',
        email: 'pedro@mail.com',
        direccion: 'Calle 5 #654',
        numId: 'ID005',
        edad: 45,
      ),
      (
        nombre: 'Laura Rodríguez',
        telefono: '5550106',
        email: 'laura@mail.com',
        direccion: 'Calle 6 #987',
        numId: 'ID006',
        edad: 33,
      ),
      (
        nombre: 'Diego Hernández',
        telefono: '5550107',
        email: 'diego@mail.com',
        direccion: 'Calle 7 #147',
        numId: 'ID007',
        edad: 38,
      ),
      (
        nombre: 'Sofía Ramírez',
        telefono: '5550108',
        email: 'sofia@mail.com',
        direccion: 'Calle 8 #258',
        numId: 'ID008',
        edad: 27,
      ),
      (
        nombre: 'Miguel Torres',
        telefono: '5550109',
        email: 'miguel@mail.com',
        direccion: 'Calle 9 #369',
        numId: 'ID009',
        edad: 50,
      ),
      (
        nombre: 'Carmen Flores',
        telefono: '5550110',
        email: 'carmen@mail.com',
        direccion: 'Calle 10 #159',
        numId: 'ID010',
        edad: 29,
      ),

      // ── NUEVOS CLIENTES CON MORA ──
      (
        nombre: 'Roberto Vega',
        telefono: '5550111',
        email: 'roberto@mail.com',
        direccion: 'Calle 11 #753',
        numId: 'ID011',
        edad: 41,
      ),
      (
        nombre: 'Lucía Mendoza',
        telefono: '5550112',
        email: 'lucia@mail.com',
        direccion: 'Calle 12 #951',
        numId: 'ID012',
        edad: 34,
      ),
      (
        nombre: 'Fernando Ríos',
        telefono: '5550113',
        email: 'fernando@mail.com',
        direccion: 'Calle 13 #357',
        numId: 'ID013',
        edad: 48,
      ),
      (
        nombre: 'Gabriela Núñez',
        telefono: '5550114',
        email: 'gabriela@mail.com',
        direccion: 'Calle 14 #159',
        numId: 'ID014',
        edad: 29,
      ),
      (
        nombre: 'Humberto Salinas',
        telefono: '5550115',
        email: 'humberto@mail.com',
        direccion: 'Calle 15 #486',
        numId: 'ID015',
        edad: 52,
      ),
    ];
    for (final d in deudores) {
      batch.insert(
        db.deudores,
        DeudoresCompanion.insert(
          nombre: d.nombre,
          telefono: d.telefono,
          correoElectronico: Value(d.email),
          direccion: d.direccion,
          numeroIdentificacion: d.numId,
          edad: d.edad,
          estado: EstadoCliente.activo,
        ),
      );
    }

    // ── PRÉSTAMOS ──
    final prestamos = [
      (idD: 1, monto: 10000.0, plazo: 12, tOrd: 12.0, tMor: 5.0),
      (idD: 2, monto: 15000.0, plazo: 24, tOrd: 10.0, tMor: 4.0),
      (idD: 3, monto: 8000.0, plazo: 6, tOrd: 15.0, tMor: 6.0),
      (idD: 4, monto: 20000.0, plazo: 36, tOrd: 12.0, tMor: 5.0),
      (idD: 5, monto: 5000.0, plazo: 12, tOrd: 10.0, tMor: 4.0),
      (idD: 6, monto: 12000.0, plazo: 18, tOrd: 15.0, tMor: 5.0),
      (idD: 7, monto: 9000.0, plazo: 12, tOrd: 12.0, tMor: 4.0),
      (idD: 8, monto: 7000.0, plazo: 12, tOrd: 10.0, tMor: 4.0),
      (idD: 9, monto: 25000.0, plazo: 48, tOrd: 12.0, tMor: 5.0),
      (idD: 10, monto: 6000.0, plazo: 6, tOrd: 10.0, tMor: 4.0),

      // ── NUEVOS PRÉSTAMOS CON MORA ──
      (idD: 11, monto: 30000.0, plazo: 24, tOrd: 18.0, tMor: 10.0),
      (idD: 12, monto: 45000.0, plazo: 36, tOrd: 15.0, tMor: 8.0),
      (idD: 13, monto: 12000.0, plazo: 12, tOrd: 20.0, tMor: 12.0),
      (idD: 14, monto: 22000.0, plazo: 18, tOrd: 16.0, tMor: 9.0),
      (idD: 15, monto: 8000.0, plazo: 6, tOrd: 22.0, tMor: 15.0),
    ];
    for (final p in prestamos) {
      final cuota = AmortizationCalculator.calcularCuota(
        monto: p.monto,
        tasaInteres: p.tOrd,
        plazoMeses: p.plazo,
        tipoInteres: 'compuesto',
        periodicidadIntereses: 'anual',
      );
      batch.insert(
        db.prestamos,
        PrestamosCompanion.insert(
          idDeudor: p.idD,
          tasaInteres: p.tOrd,
          tasaMoratoria: p.tMor,
          monto: p.monto,
          plazoMeses: p.plazo,
          montoCuota: cuota,
        ),
      );
    }

    // ── CONFIGURACIÓN ──
    final configs = [
      (
        idP: 1,
        tInteres: TipoInteres.compuesto,
        eMor: EstadoCliente.activo,
        mEx: ManejoExcedente.abonoCapital,
        ePres: EstadoPrestamo.activo,
      ),
      (
        idP: 2,
        tInteres: TipoInteres.compuesto,
        eMor: EstadoCliente.activo,
        mEx: ManejoExcedente.abonoCapital,
        ePres: EstadoPrestamo.activo,
      ),
      (
        idP: 3,
        tInteres: TipoInteres.simple,
        eMor: EstadoCliente.activo,
        mEx: ManejoExcedente.abonoCapital,
        ePres: EstadoPrestamo.finalizado,
      ),
      (
        idP: 4,
        tInteres: TipoInteres.compuesto,
        eMor: EstadoCliente.activo,
        mEx: ManejoExcedente.abonoCapital,
        ePres: EstadoPrestamo.activo,
      ),
      (
        idP: 5,
        tInteres: TipoInteres.compuesto,
        eMor: EstadoCliente.activo,
        mEx: ManejoExcedente.abonoCapital,
        ePres: EstadoPrestamo.activo,
      ),
      (
        idP: 6,
        tInteres: TipoInteres.simple,
        eMor: EstadoCliente.inactivo,
        mEx: ManejoExcedente.saldoFavor,
        ePres: EstadoPrestamo.activo,
      ),
      (
        idP: 7,
        tInteres: TipoInteres.simple,
        eMor: EstadoCliente.inactivo,
        mEx: ManejoExcedente.saldoFavor,
        ePres: EstadoPrestamo.activo,
      ),
      (
        idP: 8,
        tInteres: TipoInteres.simple,
        eMor: EstadoCliente.activo,
        mEx: ManejoExcedente.abonoCapital,
        ePres: EstadoPrestamo.activo,
      ),
      (
        idP: 9,
        tInteres: TipoInteres.compuesto,
        eMor: EstadoCliente.activo,
        mEx: ManejoExcedente.saldoFavor,
        ePres: EstadoPrestamo.cancelado,
      ),
      (
        idP: 10,
        tInteres: TipoInteres.compuesto,
        eMor: EstadoCliente.activo,
        mEx: ManejoExcedente.saldoFavor,
        ePres: EstadoPrestamo.activo,
      ),

      // ── NUEVAS CONFIGURACIONES CON MORA ──
      (
        idP: 11,
        tInteres: TipoInteres.compuesto,
        eMor: EstadoCliente.activo,
        mEx: ManejoExcedente.abonoCapital,
        ePres: EstadoPrestamo.activo,
      ),
      (
        idP: 12,
        tInteres: TipoInteres.simple,
        eMor: EstadoCliente.activo,
        mEx: ManejoExcedente.saldoFavor,
        ePres: EstadoPrestamo.activo,
      ),
      (
        idP: 13,
        tInteres: TipoInteres.compuesto,
        eMor: EstadoCliente.activo,
        mEx: ManejoExcedente.abonoCapital,
        ePres: EstadoPrestamo.finalizado,
      ),
      (
        idP: 14,
        tInteres: TipoInteres.simple,
        eMor: EstadoCliente.inactivo,
        mEx: ManejoExcedente.saldoFavor,
        ePres: EstadoPrestamo.activo,
      ),
      (
        idP: 15,
        tInteres: TipoInteres.compuesto,
        eMor: EstadoCliente.activo,
        mEx: ManejoExcedente.abonoCapital,
        ePres: EstadoPrestamo.finalizado,
      ),
    ];
    for (final c in configs) {
      batch.insert(
        db.configuracionPrestamos,
        ConfiguracionPrestamosCompanion.insert(
          idPrestamo: c.idP,
          tipoInteres: c.tInteres,
          estadoMoratorio: c.eMor,
          manejoExcedente: c.mEx,
          periodidadIntereses: PeriodicidadInteres.anual,
          estadoPrestamo: c.ePres,
        ),
      );
    }

    // ── SCORES ──
    batch.insert(db.scores, ScoresCompanion.insert(idDeudor: 1, score: 75));
    batch.insert(db.scores, ScoresCompanion.insert(idDeudor: 2, score: 82));
    batch.insert(db.scores, ScoresCompanion.insert(idDeudor: 3, score: 68));
    batch.insert(db.scores, ScoresCompanion.insert(idDeudor: 11, score: 72));
    batch.insert(db.scores, ScoresCompanion.insert(idDeudor: 13, score: 79));
    batch.insert(db.scores, ScoresCompanion.insert(idDeudor: 15, score: 65));
  });

  // ── AMORTIZACIONES ──
  final now = DateTime.now();

  await db.transaction(() async {
    await _generateAmortizaciones(
      db,
      1,
      12,
      12.0,
      5.0,
      10000.0,
      TipoInteres.compuesto,
      pagosAlDia: 12,
      pagosAtrasados: 0,
      conMora: false,
      fechaBase: now.subtract(const Duration(days: 540)),
    );

    await _generateAmortizaciones(
      db,
      2,
      24,
      10.0,
      4.0,
      15000.0,
      TipoInteres.compuesto,
      pagosAlDia: 24,
      pagosAtrasados: 0,
      conMora: false,
      fechaBase: now.subtract(const Duration(days: 720)),
    );

    await _generateAmortizaciones(
      db,
      3,
      6,
      15.0,
      6.0,
      8000.0,
      TipoInteres.simple,
      pagosAlDia: 6,
      pagosAtrasados: 0,
      conMora: false,
      fechaBase: now.subtract(const Duration(days: 365)),
    );

    await _generateAmortizaciones(
      db,
      4,
      36,
      12.0,
      5.0,
      20000.0,
      TipoInteres.compuesto,
      pagosAlDia: 3,
      pagosAtrasados: 2,
      conMora: true,
      fechaBase: now.subtract(const Duration(days: 180)),
      marcarAtrasadosComoNoPagado: true,
    );

    await _generateAmortizaciones(
      db,
      5,
      12,
      10.0,
      4.0,
      5000.0,
      TipoInteres.compuesto,
      pagosAlDia: 3,
      pagosAtrasados: 2,
      conMora: true,
      fechaBase: now.subtract(const Duration(days: 180)),
      marcarAtrasadosComoNoPagado: true,
    );

    await _generateAmortizaciones(
      db,
      6,
      18,
      15.0,
      5.0,
      12000.0,
      TipoInteres.simple,
      pagosAlDia: 3,
      pagosAtrasados: 2,
      conMora: false,
      fechaBase: now.subtract(const Duration(days: 180)),
      marcarAtrasadosComoNoPagado: true,
    );

    await _generateAmortizaciones(
      db,
      7,
      12,
      12.0,
      4.0,
      9000.0,
      TipoInteres.simple,
      pagosAlDia: 3,
      pagosAtrasados: 2,
      conMora: false,
      fechaBase: now.subtract(const Duration(days: 180)),
      marcarAtrasadosComoNoPagado: true,
    );

    // Préstamo 8: 4 pagos al día, 1er pago con excedente (abono_capital)
    await _generateAmortizaciones(
      db,
      8,
      12,
      10.0,
      4.0,
      7000.0,
      TipoInteres.simple,
      pagosAlDia: 4,
      pagosAtrasados: 0,
      conMora: false,
      fechaBase: now.subtract(const Duration(days: 120)),
      pagoExtraCuota: 1,
      montoExtra: 700.0,
    );

    // Préstamo 9: 4 pagos al día, 1er pago con excedente (saldo_favor)
    await _generateAmortizaciones(
      db,
      9,
      48,
      12.0,
      5.0,
      25000.0,
      TipoInteres.compuesto,
      pagosAlDia: 4,
      pagosAtrasados: 0,
      conMora: false,
      fechaBase: now.subtract(const Duration(days: 120)),
      pagoExtraCuota: 1,
      montoExtra: 800.0,
    );

    // Préstamo 10: 4 pagos al día
    await _generateAmortizaciones(
      db,
      10,
      6,
      10.0,
      4.0,
      6000.0,
      TipoInteres.compuesto,
      pagosAlDia: 4,
      pagosAtrasados: 0,
      conMora: false,
      fechaBase: now.subtract(const Duration(days: 120)),
    );

    // ── NUEVAS AMORTIZACIONES CON MORA ──

    // Roberto Vega: $30,000, 18%, 24m, compuesto, activo, 5 al día + 3 atrasados
    await _generateAmortizaciones(
      db,
      11,
      24,
      18.0,
      10.0,
      30000.0,
      TipoInteres.compuesto,
      pagosAlDia: 5,
      pagosAtrasados: 3,
      conMora: true,
      fechaBase: now.subtract(const Duration(days: 280)),
      marcarAtrasadosComoNoPagado: true,
    );

    // Lucía Mendoza: $45,000, 15%, 36m, simple, activo, 4 al día + 4 atrasados
    await _generateAmortizaciones(
      db,
      12,
      36,
      15.0,
      8.0,
      45000.0,
      TipoInteres.simple,
      pagosAlDia: 4,
      pagosAtrasados: 4,
      conMora: true,
      fechaBase: now.subtract(const Duration(days: 280)),
      marcarAtrasadosComoNoPagado: true,
    );

    // Fernando Ríos: $12,000, 20%, 12m, compuesto, finalizado, 10 al día + 2 atrasados
    await _generateAmortizaciones(
      db,
      13,
      12,
      20.0,
      12.0,
      12000.0,
      TipoInteres.compuesto,
      pagosAlDia: 10,
      pagosAtrasados: 2,
      conMora: true,
      fechaBase: now.subtract(const Duration(days: 420)),
    );

    // Gabriela Núñez: $22,000, 16%, 18m, simple, activo, 3 al día + 5 atrasados
    await _generateAmortizaciones(
      db,
      14,
      18,
      16.0,
      9.0,
      22000.0,
      TipoInteres.simple,
      pagosAlDia: 3,
      pagosAtrasados: 5,
      conMora: true,
      fechaBase: now.subtract(const Duration(days: 280)),
      marcarAtrasadosComoNoPagado: true,
    );

    // Humberto Salinas: $8,000, 22%, 6m, compuesto, finalizado, 3 al día + 3 atrasados
    await _generateAmortizaciones(
      db,
      15,
      6,
      22.0,
      15.0,
      8000.0,
      TipoInteres.compuesto,
      pagosAlDia: 3,
      pagosAtrasados: 3,
      conMora: true,
      fechaBase: now.subtract(const Duration(days: 220)),
    );
  });
}

Future<void> _generateAmortizaciones(
  AppDatabase db,
  int idPrestamo,
  int totalCuotas,
  double tasaAnual,
  double tasaMoraAnual,
  double monto,
  TipoInteres tipo, {
  required int pagosAlDia,
  required int pagosAtrasados,
  required bool conMora,
  required DateTime fechaBase,
  int? pagoExtraCuota,
  double? montoExtra,
  bool marcarAtrasadosComoNoPagado = false,
}) async {
  final totalPagos = pagosAlDia + pagosAtrasados;
  if (totalPagos > totalCuotas) return;

  final r = tasaAnual / 12 / 100;
  final rMora = tasaMoraAnual / 100 / 360;

  double saldoRestante = monto;
  final cuota = AmortizationCalculator.calcularCuota(
    monto: monto,
    tasaInteres: tasaAnual,
    plazoMeses: totalCuotas,
    tipoInteres: 'compuesto',
    periodicidadIntereses: 'anual',
  );

  for (int i = 1; i <= totalPagos; i++) {
    final cuotaCapital = tipo == TipoInteres.simple
        ? monto / totalCuotas
        : cuota - saldoRestante * r;
    final interes = tipo == TipoInteres.simple
        ? saldoRestante * r
        : saldoRestante * r;

    final esAtrasado = i > pagosAlDia;
    final diasMora = esAtrasado ? 15 * (i - pagosAlDia) : 0;
    final montoMora = conMora ? cuota * rMora * diasMora : 0.0;

    final pagoExtra = (pagoExtraCuota != null && i == pagoExtraCuota)
        ? (montoExtra ?? 0)
        : 0.0;
    final pagadoRealmente = !esAtrasado || !marcarAtrasadosComoNoPagado;
    final montoPagado = pagadoRealmente ? (cuota + pagoExtra) : 0.0;
    final excedente = pagadoRealmente ? (montoPagado - cuota) : 0.0;

    final fechaVencimiento = fechaBase.add(Duration(days: 30 * i));
    final fechaPagado = pagadoRealmente
        ? (esAtrasado
              ? fechaVencimiento.add(Duration(days: diasMora))
              : fechaVencimiento)
        : null;
    final estadoAmortizacion = pagadoRealmente
        ? EstadoAmortizacion.pagado
        : EstadoAmortizacion.noPagado;

    await db
        .into(db.amortizaciones)
        .insert(
          AmortizacionesCompanion.insert(
            idPrestamo: idPrestamo,
            idCuota: i,
            fechaVencimiento: fechaVencimiento,
            fechaPagado: Value(fechaPagado),
            montoInicial: cuota,
            montoPagado: montoPagado,
            montoACapital: cuotaCapital,
            montoInteres: interes,
            diasMora: Value(diasMora),
            montoMora: montoMora,
            montoExcedente: excedente,
            estadoAmortizacion: estadoAmortizacion,
          ),
        );

    if (tipo == TipoInteres.simple) {
      saldoRestante -= monto / totalCuotas;
    } else {
      saldoRestante -= cuotaCapital;
    }
    if (saldoRestante < 0) saldoRestante = 0;
  }
}
