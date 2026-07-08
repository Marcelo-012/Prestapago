import 'package:prestapagos/domain/entities/dtos/clientes/cliente_detalle.dart';
import 'package:prestapagos/domain/entities/dtos/clientes/cliente_resumen.dart';
import 'package:prestapagos/domain/entities/clientes/cliente.dart';
import 'package:prestapagos/domain/repositories/clientes/cliente_repository.dart';
import 'package:prestapagos/infrastructure/database/database.dart';

class ClienteRepositoryImpl implements ClienteRepository {
  final AppDatabase _db;

  ClienteRepositoryImpl(this._db);

  @override
  Future<void> actualizarCliente(Cliente cliente) {
    throw UnimplementedError();
  }

  @override
  Future<void> crearCliente(Cliente cliente) {
    // TODO: implement crearCliente
    throw UnimplementedError();
  }

  @override
  Future<void> eliminarCliente(int idDeudor) {
    // TODO: implement eliminarCliente
    throw UnimplementedError();
  }

  @override
  Future<List<ClienteResumen>> getAll() async {
    //obtiene toda la tabla
    final clientes = await _db.select(_db.deudores).get();

    return Future.wait(
      clientes.map((cliente) async {
        // Obtén los scores del cliente

        final scores = await (_db.select(
          _db.scores,
        )..where((s) => s.idDeudor.equals(cliente.id))).get();

        // Calcula el promedio de score

        final scorePromedio = scores.isNotEmpty
            ? scores.map((s) => s.score).reduce((a, b) => a + b) / scores.length
            : 0.0;

        // Obtén total de préstamos

        final prestamos = await (_db.select(
          _db.prestamos,
        )..where((prestamos) => prestamos.idDeudor.equals(cliente.id))).get();

        // Calcula total deuda

        final totalDeuda = prestamos.fold<double>(
          0,
          (sum, prestamos) => sum + (prestamos.monto),
        );

        return ClienteResumen(
          idDeudor: cliente.id,
          nombre: cliente.nombre,
          telefono: cliente.telefono,
          estado: cliente.estado.name,
          score: scorePromedio,
          totalPrestamos: prestamos.length,
          totalDeuda: totalDeuda,
        );
      }),
    );
  }

  @override
  Future<Cliente> getById(int idDeudor) async {
    final cliente = await (_db.select(
      _db.deudores,
    )..where((cliente) => cliente.id.equals(idDeudor))).getSingle();

    return Cliente(
      idDeudor: cliente.id,
      nombre: cliente.nombre,
      telefono: cliente.telefono,
      email: cliente.correoElectronico,
      direccion: cliente.direccion,
      dni: cliente.numeroIdentificacion,
      edad: cliente.edad,
      estado: cliente.estado.name,
      fechaCreacion: cliente.fechaCreacion,
      fechaActualizacion: cliente.fechaActualizacion,
    );
  }

  @override
  Future<ClienteDetalle> getDetalle(int idDeudor) async {
    final cliente = await getById(idDeudor);

    final scores = await (_db.select(
      _db.scores,
    )..where((score) => score.idDeudor.equals(idDeudor))).get();

    final scorePromedio = scores.isNotEmpty
        ? scores
              .map((promedio) => promedio.score)
              .reduce((a, b) => a + b / scores.length)
        : 0.0;

    // Obtén total de préstamos

    final prestamos = await (_db.select(
      _db.prestamos,
    )..where((prestamos) => prestamos.idDeudor.equals(cliente.idDeudor))).get();

    return ClienteDetalle(
      cliente: cliente,
      scores: scores,
      prestamos: prestamos,
      scorePromedio: scorePromedio,
    );
  }
}
