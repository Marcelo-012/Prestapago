enum EstadoPrestamo {
  activo('activo'),
  inactivo('inactivo'),
  cancelado('cancelado'),
  finalizado('finalizado');

  final String value;
  const EstadoPrestamo(this.value);
}
