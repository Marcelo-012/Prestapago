enum EstadoPrestamo {
  activo('activo'),
  inactivo('inactivo'),
  cancelado('cancelado'),
  finalizado('finalizado'),
  atrasado('atrasado'),
  incobrable('incobrable');

  final String value;
  const EstadoPrestamo(this.value);
}
