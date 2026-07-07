class Cliente {
  final int idDeudor;
  final String nombre;
  final String telefono;
  final String? email;
  final String direccion;
  final String dni;
  final int edad;
  final String estado;
  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;

  Cliente({
    required this.idDeudor,
    required this.nombre,
    required this.telefono,
    this.email,
    required this.direccion,
    required this.dni,
    required this.edad,
    required this.estado,
    required this.fechaCreacion,
    required this.fechaActualizacion,
  });
}
