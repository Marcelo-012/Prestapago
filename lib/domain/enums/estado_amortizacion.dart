enum EstadoAmortizacion {
  pendiente('pendiente'),
  pagado('pagado'),
  atrasado('atrasado'),
  cancelado('cancelado');

  final String value;
  const EstadoAmortizacion(this.value);
}
