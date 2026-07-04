enum EstadoAmortizacion {
  nopagado('nopagado'),
  pagado('pagado'),
  atrasado('atrasado'),
  cancelado('cancelado');

  final String value;
  const EstadoAmortizacion(this.value);
}
