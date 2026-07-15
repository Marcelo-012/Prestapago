import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/shared/domain/services/amortization_calculator.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/shared/infrastructure/inputs/inputs.dart';

class PrestamoFormState {
  final ClienteResumen? selectedClient;
  final RequiredString idDeudor;
  final PositiveNumber monto;
  final PositiveNumber plazo;
  final Percentage tasaInteres;
  final OptionalNumber tasaInteresMoratoria;
  final PositiveNumber montoCuota;
  final String tipoInteres;
  final String estadoMoratorio;
  final String manejoExcedente;
  final String periodidadIntereses;

  const PrestamoFormState({
    this.selectedClient,
    this.idDeudor = const RequiredString.pure(),
    this.monto = const PositiveNumber.pure(),
    this.plazo = const PositiveNumber.pure(),
    this.tasaInteres = const Percentage.pure(),
    this.tasaInteresMoratoria = const OptionalNumber.pure(),
    this.montoCuota = const PositiveNumber.pure(),
    this.tipoInteres = 'compuesto',
    this.estadoMoratorio = 'inactivo',
    this.manejoExcedente = 'saldo_favor',
    this.periodidadIntereses = 'mensual',
  });

  bool get isFormValid =>
      idDeudor.isValid &&
      monto.isValid &&
      plazo.isValid &&
      tasaInteres.isValid &&
      montoCuota.isValid;

  PrestamoFormState copyWith({
    ClienteResumen? selectedClient,
    RequiredString? idDeudor,
    PositiveNumber? monto,
    PositiveNumber? plazo,
    Percentage? tasaInteres,
    OptionalNumber? tasaInteresMoratoria,
    PositiveNumber? montoCuota,
    String? tipoInteres,
    String? estadoMoratorio,
    String? manejoExcedente,
    String? periodidadIntereses,
  }) {
    return PrestamoFormState(
      selectedClient: selectedClient ?? this.selectedClient,
      idDeudor: idDeudor ?? this.idDeudor,
      monto: monto ?? this.monto,
      plazo: plazo ?? this.plazo,
      tasaInteres: tasaInteres ?? this.tasaInteres,
      tasaInteresMoratoria: tasaInteresMoratoria ?? this.tasaInteresMoratoria,
      montoCuota: montoCuota ?? this.montoCuota,
      tipoInteres: tipoInteres ?? this.tipoInteres,
      estadoMoratorio: estadoMoratorio ?? this.estadoMoratorio,
      manejoExcedente: manejoExcedente ?? this.manejoExcedente,
      periodidadIntereses: periodidadIntereses ?? this.periodidadIntereses,
    );
  }

  CreatePrestamoDTO toDTO({
    required List<CreateAmortizacionDTO> amortizaciones,
  }) {
    return CreatePrestamoDTO(
      idDeudor: int.tryParse(idDeudor.value) ?? 0,
      monto: double.tryParse(monto.value) ?? 0,
      plazo: (double.tryParse(plazo.value) ?? 0).toInt(),
      tasaInteres: double.tryParse(tasaInteres.value) ?? 0,
      tasaInteresMoratoria: tasaInteresMoratoria.value.isEmpty
          ? 0
          : double.tryParse(tasaInteresMoratoria.value) ?? 0,
      montoCuota: double.tryParse(montoCuota.value) ?? 0,
      tipoInteres: tipoInteres,
      estadoMoratorio: estadoMoratorio,
      manejoExcedente: manejoExcedente,
      periodidadIntereses: periodidadIntereses,
      estadoPrestamo: 'activo',
      amortizaciones: amortizaciones,
    );
  }

  List<CreateAmortizacionDTO> calcularAmortizaciones() {
    final monto = double.tryParse(this.monto.value);
    final tasa = double.tryParse(tasaInteres.value);
    if (monto == null || tasa == null) return [];

    final tasaMora = tasaInteresMoratoria.value.isEmpty
        ? 0.0
        : double.tryParse(tasaInteresMoratoria.value) ?? 0.0;
    final meses = int.tryParse(plazo.value);
    if (meses == null || meses <= 0) return [];

    final cuota = double.tryParse(montoCuota.value);
    if (cuota == null || cuota <= 0) return [];

    final amortizaciones = AmortizationCalculator.calcular(
      idPrestamo: 0,
      monto: monto,
      tasaInteres: tasa,
      tasaInteresMoratoria: tasaMora,
      plazoMeses: meses,
      cuota: cuota,
      fechaInicio: DateTime.now(),
      tipoInteres: tipoInteres,
      periodicidadIntereses: periodidadIntereses,
      estadoMoratorioActivo: estadoMoratorio == 'activo',
    );

    return amortizaciones
        .map(
          (a) => CreateAmortizacionDTO(
            idCuota: a.idCuota,
            fechaVencimiento: a.fechaVencimiento,
            montoInicial: a.montoInicial,
            montoCapital: a.montoCapital,
            montoInteres: a.montoInteres,
            montoMora: a.montoMora,
          ),
        )
        .toList();
  }
}

class CreatePrestamoFormNotifier extends Notifier<PrestamoFormState> {
  @override
  PrestamoFormState build() => const PrestamoFormState();

  void onClientSelected(ClienteResumen client) {
    state = state.copyWith(
      selectedClient: client,
      idDeudor: RequiredString.dirty(client.idDeudor.toString()),
    );
  }

  void onMontoChanged(String value) {
    state = state.copyWith(monto: PositiveNumber.dirty(value));
    _autoCalcCuota();
  }

  void onPlazoChanged(String value) {
    state = state.copyWith(plazo: PositiveNumber.dirty(value));
    _autoCalcCuota();
  }

  void onTasaInteresChanged(String value) {
    state = state.copyWith(tasaInteres: Percentage.dirty(value));
    _autoCalcCuota();
  }

  void onTasaInteresMoratoriaChanged(String value) {
    state = state.copyWith(tasaInteresMoratoria: OptionalNumber.dirty(value));
  }

  void onMontoCuotaChanged(String value) {
    state = state.copyWith(montoCuota: PositiveNumber.dirty(value));
  }

  void _autoCalcCuota() {
    final s = state;
    final monto = double.tryParse(s.monto.value);
    final tasa = double.tryParse(s.tasaInteres.value);
    final plazo = int.tryParse(s.plazo.value);
    if (monto == null || tasa == null || plazo == null) return;
    if (monto <= 0 || tasa <= 0 || plazo <= 0) return;
    final cuota = AmortizationCalculator.calcularCuota(
      monto: monto,
      tasaInteres: tasa,
      plazoMeses: plazo,
      tipoInteres: s.tipoInteres,
      periodicidadIntereses: s.periodidadIntereses,
    );
    state = state.copyWith(
      montoCuota: PositiveNumber.dirty(cuota.toStringAsFixed(6)),
    );
  }

  void onTipoInteresChanged(String value) {
    state = state.copyWith(tipoInteres: value);
    _autoCalcCuota();
  }

  void onEstadoMoratorioChanged(String value) {
    state = state.copyWith(estadoMoratorio: value);
  }

  void onManejoExcedenteChanged(String value) {
    state = state.copyWith(manejoExcedente: value);
  }

  void onPeriodidadInteresesChanged(String value) {
    state = state.copyWith(periodidadIntereses: value);
  }

  void touchAll() {
    final s = state;
    state = PrestamoFormState(
      selectedClient: s.selectedClient,
      idDeudor: RequiredString.dirty(s.idDeudor.value),
      monto: PositiveNumber.dirty(s.monto.value),
      plazo: PositiveNumber.dirty(s.plazo.value),
      tasaInteres: Percentage.dirty(s.tasaInteres.value),
      tasaInteresMoratoria: OptionalNumber.dirty(s.tasaInteresMoratoria.value),
      montoCuota: PositiveNumber.dirty(s.montoCuota.value),
      tipoInteres: s.tipoInteres,
      estadoMoratorio: s.estadoMoratorio,
      manejoExcedente: s.manejoExcedente,
      periodidadIntereses: s.periodidadIntereses,
    );
  }

  void setDefaults() {
    state = PrestamoFormState(
      selectedClient: state.selectedClient,
      tipoInteres: 'compuesto',
      estadoMoratorio: 'inactivo',
      manejoExcedente: 'saldo_favor',
      periodidadIntereses: 'mensual',
    );
  }

  void reset() {
    state = build();
  }
}

final createPrestamoFormProvider =
    NotifierProvider<CreatePrestamoFormNotifier, PrestamoFormState>(
      CreatePrestamoFormNotifier.new,
    );

final editPrestamoFormProvider =
    NotifierProvider<CreatePrestamoFormNotifier, PrestamoFormState>(
      CreatePrestamoFormNotifier.new,
    );
