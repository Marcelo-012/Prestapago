import 'dart:math';
import 'package:prestapagos/domain/domain.dart';

class AmortizationCalculator {
  static double dailyMoraRate(double tasaMoratoria, String periodicidad) {
    final decimal = tasaMoratoria / 100;
    return periodicidad == 'mensual' ? decimal / 30 : decimal / 360;
  }

  static List<Amortizacion> recalcularPorMora({
    required List<Amortizacion> pendientes,
    required double montoMora,
    required double tasaInteres,
    required String periodicidadIntereses,
    required double cuotaMensual,
  }) {
    if (pendientes.isEmpty) return pendientes;

    final tasaMensual = _toMonthlyRate(tasaInteres, periodicidadIntereses);
    double saldo =
        pendientes.fold(0.0, (sum, a) => sum + a.montoCapital) + montoMora;

    final result = <Amortizacion>[];
    for (final a in pendientes) {
      final interesMes = saldo * tasaMensual;
      double capitalMes = cuotaMensual - interesMes;
      if (capitalMes >= saldo || a.idCuota == pendientes.last.idCuota) {
        capitalMes = saldo;
      }

      result.add(
        Amortizacion(
          idAmortizacion: a.idAmortizacion,
          idPrestamo: a.idPrestamo,
          idCuota: a.idCuota,
          fechaVencimiento: a.fechaVencimiento,
          fechaPagado: a.fechaPagado,
          montoInicial: cuotaMensual,
          montoPagado: a.montoPagado,
          montoCapital: capitalMes,
          montoInteres: interesMes,
          diasMora: a.diasMora,
          montoMora: a.montoMora,
          montoExcedente: a.montoExcedente,
          estadoAmortizacion: a.estadoAmortizacion,
          fechaActualizacion: DateTime.now(),
        ),
      );

      saldo -= capitalMes;
      if (saldo < 0) saldo = 0;
    }

    return result;
  }

  static ({List<Amortizacion> actualizadas, List<int> idsCanceladas})
  recalcularPorAbonoCapital({
    required List<Amortizacion> pendientes,
    required double abono,
    required double tasaInteres,
    required String periodicidadIntereses,
    required double cuotaMensual,
  }) {
    if (pendientes.isEmpty)
      return (actualizadas: pendientes, idsCanceladas: []);

    final tasaMensual = _toMonthlyRate(tasaInteres, periodicidadIntereses);
    double saldo =
        pendientes.fold(0.0, (sum, a) => sum + a.montoCapital) - abono;
    if (saldo < 0) saldo = 0;

    // Con la misma cuota, calcular cuántas cuotas se necesitan
    int cuotasNecesarias = 0;
    double tempSaldo = saldo;
    while (tempSaldo > 0.01 && cuotasNecesarias < pendientes.length) {
      cuotasNecesarias++;
      final interes = tempSaldo * tasaMensual;
      double capital = cuotaMensual - interes;
      if (capital >= tempSaldo) capital = tempSaldo;
      tempSaldo -= capital;
    }

    final idsCanceladas = <int>[];
    final actualizadas = <Amortizacion>[];

    double saldoActual = saldo;
    for (int i = 0; i < pendientes.length; i++) {
      final a = pendientes[i];
      if (i >= cuotasNecesarias) {
        idsCanceladas.add(a.idAmortizacion);
        continue;
      }

      final interesMes = saldoActual * tasaMensual;
      double capitalMes = cuotaMensual - interesMes;
      if (capitalMes >= saldoActual || i == cuotasNecesarias - 1) {
        capitalMes = saldoActual;
      }

      actualizadas.add(
        Amortizacion(
          idAmortizacion: a.idAmortizacion,
          idPrestamo: a.idPrestamo,
          idCuota: a.idCuota,
          fechaVencimiento: a.fechaVencimiento,
          fechaPagado: a.fechaPagado,
          montoInicial: cuotaMensual,
          montoPagado: a.montoPagado,
          montoCapital: capitalMes,
          montoInteres: interesMes,
          diasMora: a.diasMora,
          montoMora: a.montoMora,
          montoExcedente: a.montoExcedente,
          estadoAmortizacion: a.estadoAmortizacion,
          fechaActualizacion: DateTime.now(),
        ),
      );

      saldoActual -= capitalMes;
      if (saldoActual < 0) saldoActual = 0;
    }

    return (actualizadas: actualizadas, idsCanceladas: idsCanceladas);
  }

  static ({String tipo, double saldoFavorRestante, double diferenciaACubrir})
  recalcularPorSaldoAFavor({
    required double saldoAFavorAcumulado,
    required double cuotaActual,
  }) {
    if (saldoAFavorAcumulado == cuotaActual) {
      return (tipo: 'igual', saldoFavorRestante: 0, diferenciaACubrir: 0);
    } else if (saldoAFavorAcumulado > cuotaActual) {
      return (
        tipo: 'mayor',
        saldoFavorRestante: saldoAFavorAcumulado - cuotaActual,
        diferenciaACubrir: 0,
      );
    } else {
      return (
        tipo: 'menor',
        saldoFavorRestante: 0,
        diferenciaACubrir: cuotaActual - saldoAFavorAcumulado,
      );
    }
  }

  static double _toMonthlyRate(double tasa, String periodicidad) {
    final decimal = tasa / 100;
    return periodicidad == 'mensual' ? decimal : decimal / 12;
  }

  static List<Amortizacion> calcular({
    required int idPrestamo,
    required double monto,
    required double tasaInteres,
    required double tasaInteresMoratoria,
    required int plazoMeses,
    required double cuota,
    required DateTime fechaInicio,
    required String tipoInteres,
    required String periodicidadIntereses,
    bool estadoMoratorioActivo = false,
  }) {
    final List<Amortizacion> amortizaciones = [];
    final tasaMensual = _toMonthlyRate(tasaInteres, periodicidadIntereses);
    final tasaMoraMensual = _toMonthlyRate(
      tasaInteresMoratoria,
      periodicidadIntereses,
    );
    double saldo = monto;
    int idCuota = 0;

    while (saldo > 0.01 && idCuota < plazoMeses) {
      idCuota++;
      final interesMes = tipoInteres == 'simple'
          ? monto * tasaMensual
          : saldo * tasaMensual;

      double capitalMes = cuota - interesMes;

      if (capitalMes >= saldo || idCuota == plazoMeses) {
        capitalMes = saldo;
      }

      final pagoCuota = capitalMes + interesMes;
      final montoMora = estadoMoratorioActivo
          ? pagoCuota * tasaMoraMensual
          : 0.0;

      final fechaVencimiento = DateTime(
        fechaInicio.year,
        fechaInicio.month + idCuota,
        fechaInicio.day,
      );

      amortizaciones.add(
        Amortizacion(
          idAmortizacion: 0,
          idPrestamo: idPrestamo,
          idCuota: idCuota,
          fechaVencimiento: fechaVencimiento,
          fechaPagado: null,
          montoInicial: cuota,
          montoPagado: 0,
          montoCapital: capitalMes,
          montoInteres: interesMes,
          diasMora: 0,
          montoMora: montoMora,
          montoExcedente: 0,
          estadoAmortizacion: 'pendiente',
          fechaActualizacion: DateTime.now(),
        ),
      );

      saldo -= capitalMes;
    }

    return amortizaciones;
  }

  static double calcularMontoMora({
    required double montoInicial,
    required double tasaMoratoria,
    required String periodicidad,
    required int diasMora,
  }) {
    final tasaDiaria = dailyMoraRate(tasaMoratoria, periodicidad);
    return montoInicial * tasaDiaria * diasMora;
  }

  static ({
    double montoCuota,
    double montoMora,
    int diasMora,
    double saldoAFavor,
    double totalMinimo,
    double montoMaximo,
  })
  calcularPreviewPago({
    required Amortizacion prox,
    required Prestamo prestamo,
    required ConfiguracionPrestamo config,
    required List<Amortizacion> amortizaciones,
  }) {
    final esSimple = config.tipoInteres == 'simple';

    final montoMora = calcularMontoMora(
      montoInicial: prox.montoInicial,
      tasaMoratoria: prestamo.tasaInteresMoratoria,
      periodicidad: config.periodidadIntereses,
      diasMora: prox.diasMora,
    );

    final saldoPreCargado = prox.montoExcedente;

    final totalRestante = amortizaciones
        .where((a) => a.estadoAmortizacion == 'pendiente' || a.estadoAmortizacion == 'atrasado')
        .fold<double>(0, (sum, a) => sum + a.montoInicial);

    final bruto = prox.montoInicial + (esSimple ? montoMora : 0);
    final totalMinimo = bruto - saldoPreCargado;

    return (
      montoCuota: prox.montoInicial,
      montoMora: montoMora,
      diasMora: prox.diasMora,
      saldoAFavor: saldoPreCargado > 0 ? saldoPreCargado : 0,
      totalMinimo: totalMinimo > 0 ? totalMinimo : 0,
      montoMaximo: totalRestante + (esSimple ? montoMora : 0),
    );
  }

  static double calcularCuota({
    required double monto,
    required double tasaInteres,
    required int plazoMeses,
    required String tipoInteres,
    required String periodicidadIntereses,
  }) {
    if (tasaInteres <= 0 || plazoMeses <= 0) return monto / plazoMeses;

    final tasaMensual = _toMonthlyRate(tasaInteres, periodicidadIntereses);

    if (tipoInteres == 'simple') {
      final interesTotal = monto * tasaMensual * plazoMeses;
      return (monto + interesTotal) / plazoMeses;
    }

    if (tasaMensual == 0) return monto / plazoMeses;

    final factor =
        (tasaMensual * pow(1 + tasaMensual, plazoMeses)) /
        (pow(1 + tasaMensual, plazoMeses) - 1);

    return monto * factor;
  }
}
