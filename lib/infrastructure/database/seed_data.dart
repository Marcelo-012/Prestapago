import 'package:drift/drift.dart';

import 'package:prestapagos/shared/domain/services/amortization_calculator.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/database/database.dart';

Future<void> seedDatabase(AppDatabase db) async {
  await db.batch((batch) {
    // ── DEUDORES (10) ──
    final deudores = [
      (nombre: 'Juan Pérez', tel: '5550101', email: 'juan@mail.com', dir: 'Calle 1 #123', numId: 'ID001', edad: 35),
      (nombre: 'María García', tel: '5550102', email: 'maria@mail.com', dir: 'Calle 2 #456', numId: 'ID002', edad: 28),
      (nombre: 'Carlos López', tel: '5550103', email: 'carlos@mail.com', dir: 'Calle 3 #789', numId: 'ID003', edad: 42),
      (nombre: 'Ana Martínez', tel: '5550104', email: 'ana@mail.com', dir: 'Calle 4 #321', numId: 'ID004', edad: 30),
      (nombre: 'Pedro Sánchez', tel: '5550105', email: 'pedro@mail.com', dir: 'Calle 5 #654', numId: 'ID005', edad: 45),
      (nombre: 'Laura Rodríguez', tel: '5550106', email: 'laura@mail.com', dir: 'Calle 6 #987', numId: 'ID006', edad: 33),
      (nombre: 'Diego Hernández', tel: '5550107', email: 'diego@mail.com', dir: 'Calle 7 #147', numId: 'ID007', edad: 38),
      (nombre: 'Sofía Ramírez', tel: '5550108', email: 'sofia@mail.com', dir: 'Calle 8 #258', numId: 'ID008', edad: 27),
      (nombre: 'Miguel Torres', tel: '5550109', email: 'miguel@mail.com', dir: 'Calle 9 #369', numId: 'ID009', edad: 50),
      (nombre: 'Carmen Flores', tel: '5550110', email: 'carmen@mail.com', dir: 'Calle 10 #159', numId: 'ID010', edad: 29),
    ];
    for (final d in deudores) {
      batch.insert(
        db.deudores,
        DeudoresCompanion.insert(
          nombre: d.nombre,
          telefono: d.tel,
          correoElectronico: Value(d.email),
          direccion: d.dir,
          numeroIdentificacion: d.numId,
          edad: d.edad,
          estado: EstadoCliente.activo,
        ),
      );
    }

    // ── PRÉSTAMOS (30) ──
    // Cada tupla: (idDeudor, monto, plazo, tasaOrd, tasaMor, tipoInteres, manejoExcedente, estadoPrestamo, pagosAlDia, pagosAtrasados, conMora, fechaBaseDays, marcarAtrasadosComoPendiente)
    final prestamos = [
      // Cliente 1 – Juan Pérez
      (idD: 1, monto: 10000.0, plazo: 12, tOrd: 12.0, tMor: 5.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.finalizado, alDia: 12, atras: 0, mora: false, fb: -540, marcar: false),
      (idD: 1, monto: 20000.0, plazo: 24, tOrd: 10.0, tMor: 4.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.activo, alDia: 6, atras: 0, mora: false, fb: -180, marcar: false),
      (idD: 1, monto: 15000.0, plazo: 18, tOrd: 12.0, tMor: 5.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.saldoFavor, ePres: EstadoPrestamo.activo, alDia: 4, atras: 3, mora: true, fb: -210, marcar: true),
      // Cliente 2 – María García
      (idD: 2, monto: 5000.0, plazo: 6, tOrd: 10.0, tMor: 4.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.finalizado, alDia: 6, atras: 0, mora: false, fb: -365, marcar: false),
      (idD: 2, monto: 12000.0, plazo: 12, tOrd: 15.0, tMor: 5.0, tipo: TipoInteres.simple, mEx: ManejoExcedente.saldoFavor, ePres: EstadoPrestamo.activo, alDia: 5, atras: 0, mora: false, fb: -150, marcar: false),
      (idD: 2, monto: 25000.0, plazo: 24, tOrd: 12.0, tMor: 5.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.activo, alDia: 6, atras: 4, mora: true, fb: -300, marcar: true),
      // Cliente 3 – Carlos López
      (idD: 3, monto: 8000.0, plazo: 12, tOrd: 15.0, tMor: 6.0, tipo: TipoInteres.simple, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.activo, alDia: 4, atras: 0, mora: false, fb: -120, marcar: false),
      (idD: 3, monto: 18000.0, plazo: 18, tOrd: 15.0, tMor: 6.0, tipo: TipoInteres.simple, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.activo, alDia: 3, atras: 4, mora: true, fb: -210, marcar: true),
      (idD: 3, monto: 6000.0, plazo: 6, tOrd: 15.0, tMor: 6.0, tipo: TipoInteres.simple, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.activo, alDia: 1, atras: 5, mora: true, fb: -180, marcar: true),
      // Cliente 4 – Ana Martínez
      (idD: 4, monto: 30000.0, plazo: 24, tOrd: 12.0, tMor: 5.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.finalizado, alDia: 24, atras: 0, mora: false, fb: -720, marcar: false),
      (idD: 4, monto: 9000.0, plazo: 12, tOrd: 10.0, tMor: 4.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.saldoFavor, ePres: EstadoPrestamo.activo, alDia: 4, atras: 0, mora: false, fb: -120, marcar: false),
      (idD: 4, monto: 40000.0, plazo: 36, tOrd: 12.0, tMor: 5.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.activo, alDia: 8, atras: 5, mora: true, fb: -390, marcar: true),
      // Cliente 5 – Pedro Sánchez
      (idD: 5, monto: 7000.0, plazo: 12, tOrd: 10.0, tMor: 4.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.finalizado, alDia: 12, atras: 0, mora: false, fb: -365, marcar: false),
      (idD: 5, monto: 14000.0, plazo: 18, tOrd: 15.0, tMor: 5.0, tipo: TipoInteres.simple, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.activo, alDia: 6, atras: 0, mora: false, fb: -180, marcar: false),
      (idD: 5, monto: 22000.0, plazo: 24, tOrd: 12.0, tMor: 5.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.activo, alDia: 5, atras: 3, mora: true, fb: -240, marcar: true),
      // Cliente 6 – Laura Rodríguez
      (idD: 6, monto: 4000.0, plazo: 6, tOrd: 10.0, tMor: 4.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.activo, alDia: 2, atras: 0, mora: false, fb: -60, marcar: false),
      (idD: 6, monto: 11000.0, plazo: 12, tOrd: 15.0, tMor: 5.0, tipo: TipoInteres.simple, mEx: ManejoExcedente.saldoFavor, ePres: EstadoPrestamo.activo, alDia: 4, atras: 4, mora: true, fb: -240, marcar: true),
      (idD: 6, monto: 16000.0, plazo: 18, tOrd: 15.0, tMor: 5.0, tipo: TipoInteres.simple, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.activo, alDia: 3, atras: 5, mora: true, fb: -240, marcar: true),
      // Cliente 7 – Diego Hernández
      (idD: 7, monto: 10000.0, plazo: 12, tOrd: 12.0, tMor: 4.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.activo, alDia: 5, atras: 0, mora: false, fb: -150, marcar: false),
      (idD: 7, monto: 28000.0, plazo: 24, tOrd: 12.0, tMor: 4.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.activo, alDia: 4, atras: 0, mora: false, fb: -120, marcar: false),
      (idD: 7, monto: 5000.0, plazo: 6, tOrd: 10.0, tMor: 4.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.activo, alDia: 3, atras: 0, mora: false, fb: -90, marcar: false),
      // Cliente 8 – Sofía Ramírez
      (idD: 8, monto: 8000.0, plazo: 12, tOrd: 10.0, tMor: 4.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.finalizado, alDia: 12, atras: 0, mora: false, fb: -365, marcar: false),
      (idD: 8, monto: 15000.0, plazo: 18, tOrd: 10.0, tMor: 4.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.activo, alDia: 5, atras: 2, mora: true, fb: -210, marcar: true),
      (idD: 8, monto: 20000.0, plazo: 24, tOrd: 12.0, tMor: 5.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.saldoFavor, ePres: EstadoPrestamo.activo, alDia: 6, atras: 4, mora: true, fb: -300, marcar: true),
      // Cliente 9 – Miguel Torres
      (idD: 9, monto: 50000.0, plazo: 48, tOrd: 12.0, tMor: 5.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.finalizado, alDia: 48, atras: 0, mora: false, fb: -1440, marcar: false),
      (idD: 9, monto: 35000.0, plazo: 36, tOrd: 10.0, tMor: 4.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.finalizado, alDia: 36, atras: 0, mora: false, fb: -1080, marcar: false),
      (idD: 9, monto: 12000.0, plazo: 12, tOrd: 12.0, tMor: 5.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.activo, alDia: 3, atras: 0, mora: false, fb: -90, marcar: false),
      // Cliente 10 – Carmen Flores
      (idD: 10, monto: 6000.0, plazo: 6, tOrd: 10.0, tMor: 4.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.activo, alDia: 2, atras: 0, mora: false, fb: -60, marcar: false),
      (idD: 10, monto: 9000.0, plazo: 12, tOrd: 15.0, tMor: 6.0, tipo: TipoInteres.simple, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.activo, alDia: 3, atras: 5, mora: true, fb: -240, marcar: true),
      (idD: 10, monto: 14000.0, plazo: 18, tOrd: 12.0, tMor: 5.0, tipo: TipoInteres.compuesto, mEx: ManejoExcedente.abonoCapital, ePres: EstadoPrestamo.finalizado, alDia: 18, atras: 0, mora: false, fb: -540, marcar: false),
    ];

    for (final p in prestamos) {
      final cuota = AmortizationCalculator.calcularCuota(
        monto: p.monto,
        tasaInteres: p.tOrd,
        plazoMeses: p.plazo,
        tipoInteres: p.tipo == TipoInteres.simple ? 'simple' : 'compuesto',
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

    // ── CONFIGURACIONES (30) ──
    for (int i = 1; i <= 30; i++) {
      final p = prestamos[i - 1];
      batch.insert(
        db.configuracionPrestamos,
        ConfiguracionPrestamosCompanion.insert(
          idPrestamo: i,
          tipoInteres: p.tipo,
          estadoMoratorio: EstadoCliente.activo,
          manejoExcedente: p.mEx,
          periodidadIntereses: PeriodicidadInteres.anual,
          estadoPrestamo: p.ePres,
        ),
      );
    }

    // ── SCORES ──
    batch.insert(db.scores, ScoresCompanion.insert(idDeudor: 1, score: 75));
    batch.insert(db.scores, ScoresCompanion.insert(idDeudor: 2, score: 82));
    batch.insert(db.scores, ScoresCompanion.insert(idDeudor: 3, score: 68));
    batch.insert(db.scores, ScoresCompanion.insert(idDeudor: 4, score: 90));
    batch.insert(db.scores, ScoresCompanion.insert(idDeudor: 5, score: 72));
    batch.insert(db.scores, ScoresCompanion.insert(idDeudor: 9, score: 88));
  });

  // ── AMORTIZACIONES ──
  final now = DateTime.now();
  final prestamos = [
    // (idPrestamo, plazo, tasaOrd, tasaMor, monto, tipo, alDia, atras, mora, fechaBaseDays, marcarAtrasadosComoPendiente)
    // Cliente 1
    (1, 12, 12.0, 5.0, 10000.0, TipoInteres.compuesto, 12, 0, false, -540, false),
    (2, 24, 10.0, 4.0, 20000.0, TipoInteres.compuesto, 6, 0, false, -180, false),
    (3, 18, 12.0, 5.0, 15000.0, TipoInteres.compuesto, 4, 3, true, -210, true),
    // Cliente 2
    (4, 6, 10.0, 4.0, 5000.0, TipoInteres.compuesto, 6, 0, false, -365, false),
    (5, 12, 15.0, 5.0, 12000.0, TipoInteres.simple, 5, 0, false, -150, false),
    (6, 24, 12.0, 5.0, 25000.0, TipoInteres.compuesto, 6, 4, true, -300, true),
    // Cliente 3
    (7, 12, 15.0, 6.0, 8000.0, TipoInteres.simple, 4, 0, false, -120, false),
    (8, 18, 15.0, 6.0, 18000.0, TipoInteres.simple, 3, 4, true, -210, true),
    (9, 6, 15.0, 6.0, 6000.0, TipoInteres.simple, 1, 5, true, -180, true),
    // Cliente 4
    (10, 24, 12.0, 5.0, 30000.0, TipoInteres.compuesto, 24, 0, false, -720, false),
    (11, 12, 10.0, 4.0, 9000.0, TipoInteres.compuesto, 4, 0, false, -120, false),
    (12, 36, 12.0, 5.0, 40000.0, TipoInteres.compuesto, 8, 5, true, -390, true),
    // Cliente 5
    (13, 12, 10.0, 4.0, 7000.0, TipoInteres.compuesto, 12, 0, false, -365, false),
    (14, 18, 15.0, 5.0, 14000.0, TipoInteres.simple, 6, 0, false, -180, false),
    (15, 24, 12.0, 5.0, 22000.0, TipoInteres.compuesto, 5, 3, true, -240, true),
    // Cliente 6
    (16, 6, 10.0, 4.0, 4000.0, TipoInteres.compuesto, 2, 0, false, -60, false),
    (17, 12, 15.0, 5.0, 11000.0, TipoInteres.simple, 4, 4, true, -240, true),
    (18, 18, 15.0, 5.0, 16000.0, TipoInteres.simple, 3, 5, true, -240, true),
    // Cliente 7
    (19, 12, 12.0, 4.0, 10000.0, TipoInteres.compuesto, 5, 0, false, -150, false),
    (20, 24, 12.0, 4.0, 28000.0, TipoInteres.compuesto, 4, 0, false, -120, false),
    (21, 6, 10.0, 4.0, 5000.0, TipoInteres.compuesto, 3, 0, false, -90, false),
    // Cliente 8
    (22, 12, 10.0, 4.0, 8000.0, TipoInteres.compuesto, 12, 0, false, -365, false),
    (23, 18, 10.0, 4.0, 15000.0, TipoInteres.compuesto, 5, 2, true, -210, true),
    (24, 24, 12.0, 5.0, 20000.0, TipoInteres.compuesto, 6, 4, true, -300, true),
    // Cliente 9
    (25, 48, 12.0, 5.0, 50000.0, TipoInteres.compuesto, 48, 0, false, -1440, false),
    (26, 36, 10.0, 4.0, 35000.0, TipoInteres.compuesto, 36, 0, false, -1080, false),
    (27, 12, 12.0, 5.0, 12000.0, TipoInteres.compuesto, 3, 0, false, -90, false),
    // Cliente 10
    (28, 6, 10.0, 4.0, 6000.0, TipoInteres.compuesto, 2, 0, false, -60, false),
    (29, 12, 15.0, 6.0, 9000.0, TipoInteres.simple, 3, 5, true, -240, true),
    (30, 18, 12.0, 5.0, 14000.0, TipoInteres.compuesto, 18, 0, false, -540, false),
  ];

  await db.transaction(() async {
    for (final p in prestamos) {
      await _generateAmortizaciones(
        db,
        p.$1,
        p.$2,
        p.$3,
        p.$4,
        p.$5,
        p.$6,
        pagosAlDia: p.$7,
        pagosAtrasados: p.$8,
        conMora: p.$9,
        fechaBase: now.add(Duration(days: p.$10)),
        marcarAtrasadosComoPendiente: p.$11,
      );
    }
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
  bool marcarAtrasadosComoPendiente = false,
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
    final pagadoRealmente = !esAtrasado || !marcarAtrasadosComoPendiente;
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
        : EstadoAmortizacion.pendiente;

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
