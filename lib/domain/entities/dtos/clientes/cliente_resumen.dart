class ClienteResumen {
  final int idDeudor;
  final String nombre;
  final String telefono;
  final String estado;
  final double score;
  final int totalPrestamos;
  final double totalDeuda;

  ClienteResumen({
    required this.idDeudor,
    required this.nombre,
    required this.telefono,
    required this.estado,
    required this.score,
    required this.totalPrestamos,
    required this.totalDeuda,
  });
}
