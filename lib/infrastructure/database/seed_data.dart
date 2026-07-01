import 'package:drift/drift.dart';

import 'package:prestapagos/domain/entities/entities.dart';
import 'package:prestapagos/infrastructure/database/database.dart';

double _monthlyRate(double annualRate) => annualRate / 12 / 100;

double _frenchCuota(double monto, double annualRate, int meses) {
  final r = _monthlyRate(annualRate);
  if (r == 0) return monto / meses;
  return monto * r * _pow(1 + r, meses) / (_pow(1 + r, meses) - 1);
}

double _pow(double base, int exp) {
  double result = 1;
  for (int i = 0; i < exp; i++) {
    result *= base;
  }
  return result;
}

Future<void> seedDatabase(AppDatabase db) async {
  await db.batch((batch) {
    // ── DEUDORES ──
    final deudores = [
      (nombre: 'Juan Pérez', telefono: '5550101', email: 'juan@mail.com', direccion: 'Calle 1 #123', numId: 'ID001', edad: 35),
      (nombre: 'María García', telefono: '5550102', email: 'maria@mail.com', direccion: 'Calle 2 #456', numId: 'ID002', edad: 28),
      (nombre: 'Carlos López', telefono: '5550103', email: 'carlos@mail.com', direccion: 'Calle 3 #789', numId: 'ID003', edad: 42),
      (nombre: 'Ana Martínez', telefono: '5550104', email: 'ana@mail.com', direccion: 'Calle 4 #321', numId: 'ID004', edad: 30),
      (nombre: 'Pedro Sánchez', telefono: '5550105', email: 'pedro@mail.com', direccion: 'Calle 5 #654', numId: 'ID005', edad: 45),
      (nombre: 'Laura Rodríguez', telefono: '5550106', email: 'laura@mail.com', direccion: 'Calle 6 #987', numId: 'ID006', edad: 33),
      (nombre: 'Diego Hernández', telefono: '5550107', email: 'diego@mail.com', direccion: 'Calle 7 #147', numId: 'ID007', edad: 38),
      (nombre: 'Sofía Ramírez', telefono: '5550108', email: 'sofia@mail.com', direccion: 'Calle 8 #258', numId: 'ID008', edad: 27),
      (nombre: 'Miguel Torres', telefono: '5550109', email: 'miguel@mail.com', direccion: 'Calle 9 #369', numId: 'ID009', edad: 50),
      (nombre: 'Carmen Flores', telefono: '5550110', email: 'carmen@mail.com', direccion: 'Calle 10 #159', numId: 'ID010', edad: 29),
    ];
    for (final d in deudores) {
      batch.insert(db.deudores, DeudoresCompanion.insert(
        nombre: d.nombre,
        telefono: d.telefono,
        correoElectronico: Value(d.email),
        direccion: d.direccion,
        numeroIdentificacion: d.numId,
        edad: d.edad,
        estado: Status.activo,
      ));
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
    ];
    for (final p in prestamos) {
      final cuota = _frenchCuota(p.monto, p.tOrd, p.plazo);
      batch.insert(db.prestamos, PrestamosCompanion.insert(
        idDeudor: p.idD,
        tasaInteres: p.tOrd,
        tasaMoratoria: p.tMor,
        monto: Value(p.monto),
        plazoMeses: p.plazo,
        montoCuota: cuota,
      ));
    }

    // ── CONFIGURACIÓN ──
    final configs = [
      (idP: 1, tInteres: TiposInteres.compuesto, eMor: Status.activo, mEx: ManejoExcedente.abonoCapital, ePres: Status.inactivo),
      (idP: 2, tInteres: TiposInteres.compuesto, eMor: Status.activo, mEx: ManejoExcedente.abonoCapital, ePres: Status.inactivo),
      (idP: 3, tInteres: TiposInteres.simple, eMor: Status.activo, mEx: ManejoExcedente.abonoCapital, ePres: Status.inactivo),
      (idP: 4, tInteres: TiposInteres.compuesto, eMor: Status.activo, mEx: ManejoExcedente.abonoCapital, ePres: Status.activo),
      (idP: 5, tInteres: TiposInteres.compuesto, eMor: Status.activo, mEx: ManejoExcedente.abonoCapital, ePres: Status.activo),
      (idP: 6, tInteres: TiposInteres.simple, eMor: Status.inactivo, mEx: ManejoExcedente.saldoFavor, ePres: Status.activo),
      (idP: 7, tInteres: TiposInteres.simple, eMor: Status.inactivo, mEx: ManejoExcedente.saldoFavor, ePres: Status.activo),
      (idP: 8, tInteres: TiposInteres.simple, eMor: Status.activo, mEx: ManejoExcedente.abonoCapital, ePres: Status.activo),
      (idP: 9, tInteres: TiposInteres.compuesto, eMor: Status.activo, mEx: ManejoExcedente.saldoFavor, ePres: Status.activo),
      (idP: 10, tInteres: TiposInteres.compuesto, eMor: Status.activo, mEx: ManejoExcedente.saldoFavor, ePres: Status.activo),
    ];
    for (final c in configs) {
      batch.insert(db.configuracionPrestamos, ConfiguracionPrestamosCompanion.insert(
        idPrestamo: c.idP,
        tipoInteres: c.tInteres,
        estadoMoratorio: c.eMor,
        manejoExcedente: c.mEx,
        periodidadIntereses: PeriodidadIntereses.mensual,
        estadoPrestamo: c.ePres,
      ));
    }

    // ── SCORES (solo préstamos 1,2,3) ──
    batch.insert(db.scores, ScoresCompanion.insert(idDeudor: 1, score: 750));
    batch.insert(db.scores, ScoresCompanion.insert(idDeudor: 2, score: 820));
    batch.insert(db.scores, ScoresCompanion.insert(idDeudor: 3, score: 680));
  });

  // ── AMORTIZACIONES ──
  final now = DateTime.now();

  await _generateAmortizaciones(db, 1, 12, 12.0, 5.0, 10000.0, TiposInteres.compuesto,
    pagosAlDia: 12, pagosAtrasados: 0, conMora: false, fechaBase: now.subtract(const Duration(days: 540)));

  await _generateAmortizaciones(db, 2, 24, 10.0, 4.0, 15000.0, TiposInteres.compuesto,
    pagosAlDia: 24, pagosAtrasados: 0, conMora: false, fechaBase: now.subtract(const Duration(days: 720)));

  await _generateAmortizaciones(db, 3, 6, 15.0, 6.0, 8000.0, TiposInteres.simple,
    pagosAlDia: 6, pagosAtrasados: 0, conMora: false, fechaBase: now.subtract(const Duration(days: 365)));

  await _generateAmortizaciones(db, 4, 36, 12.0, 5.0, 20000.0, TiposInteres.compuesto,
    pagosAlDia: 3, pagosAtrasados: 2, conMora: true, fechaBase: now.subtract(const Duration(days: 180)));

  await _generateAmortizaciones(db, 5, 12, 10.0, 4.0, 5000.0, TiposInteres.compuesto,
    pagosAlDia: 3, pagosAtrasados: 2, conMora: true, fechaBase: now.subtract(const Duration(days: 180)));

  await _generateAmortizaciones(db, 6, 18, 15.0, 5.0, 12000.0, TiposInteres.simple,
    pagosAlDia: 3, pagosAtrasados: 2, conMora: false, fechaBase: now.subtract(const Duration(days: 180)));

  await _generateAmortizaciones(db, 7, 12, 12.0, 4.0, 9000.0, TiposInteres.simple,
    pagosAlDia: 3, pagosAtrasados: 2, conMora: false, fechaBase: now.subtract(const Duration(days: 180)));

  // Préstamo 8: 4 pagos al día, 1er pago con excedente (abono_capital)
  await _generateAmortizaciones(db, 8, 12, 10.0, 4.0, 7000.0, TiposInteres.simple,
    pagosAlDia: 4, pagosAtrasados: 0, conMora: false, fechaBase: now.subtract(const Duration(days: 120)),
    pagoExtraCuota: 1, montoExtra: 700.0);

  // Préstamo 9: 4 pagos al día, 1er pago con excedente (saldo_favor)
  await _generateAmortizaciones(db, 9, 48, 12.0, 5.0, 25000.0, TiposInteres.compuesto,
    pagosAlDia: 4, pagosAtrasados: 0, conMora: false, fechaBase: now.subtract(const Duration(days: 120)),
    pagoExtraCuota: 1, montoExtra: 800.0);

  // Préstamo 10: 4 pagos al día
  await _generateAmortizaciones(db, 10, 6, 10.0, 4.0, 6000.0, TiposInteres.compuesto,
    pagosAlDia: 4, pagosAtrasados: 0, conMora: false, fechaBase: now.subtract(const Duration(days: 120)));
}

Future<void> _generateAmortizaciones(
  AppDatabase db,
  int idPrestamo,
  int totalCuotas,
  double tasaAnual,
  double tasaMoraAnual,
  double monto,
  TiposInteres tipo,
  {required int pagosAlDia,
  required int pagosAtrasados,
  required bool conMora,
  required DateTime fechaBase,
  int? pagoExtraCuota,
  double? montoExtra,
}) async {
  final totalPagos = pagosAlDia + pagosAtrasados;
  if (totalPagos > totalCuotas) return;

  final r = _monthlyRate(tasaAnual);
  final rMora = tasaMoraAnual / 100 / 360;

  double saldoRestante = monto;
  final cuota = _frenchCuota(monto, tasaAnual, totalCuotas);

  for (int i = 1; i <= totalPagos; i++) {
    final cuotaCapital = tipo == TiposInteres.simple
        ? monto / totalCuotas
        : cuota - saldoRestante * r;
    final interes = tipo == TiposInteres.simple
        ? saldoRestante * r
        : saldoRestante * r;

    final esAtrasado = i > pagosAlDia;
    final diasMora = esAtrasado ? 15 * (i - pagosAlDia) : 0;
    final montoMora = conMora ? cuota * rMora * diasMora : 0.0;

    final pagoExtra = (pagoExtraCuota != null && i == pagoExtraCuota) ? (montoExtra ?? 0) : 0.0;
    final montoPagado = cuota + pagoExtra;
    final excedente = montoPagado - cuota;

    final fechaPago = fechaBase.add(Duration(days: 30 * i));

    await db.into(db.amortizaciones).insert(AmortizacionesCompanion.insert(
      idPrestamo: idPrestamo,
      idCuota: i,
      fechaPago: fechaPago,
      montoInicial: cuota,
      montoPagado: montoPagado,
      montoACapital: cuotaCapital,
      montoInteres: interes,
      diasMora: Value(diasMora),
      montoMora: montoMora,
      montoExcedente: excedente,
    ));

    if (tipo == TiposInteres.simple) {
      saldoRestante -= monto / totalCuotas;
    } else {
      saldoRestante -= cuotaCapital;
    }
    if (saldoRestante < 0) saldoRestante = 0;
  }
}
