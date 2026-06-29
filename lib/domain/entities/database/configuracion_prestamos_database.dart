enum ManejoExcedente {
  abonoCapital('abono_capital'),
  saldoFavor('saldo_favor');

  final String value;
  const ManejoExcedente(this.value);
}

enum PeriodidadIntereses {
  mensual('mensual'),
  anual('anual');

  final String value;
  const PeriodidadIntereses(this.value);
}
