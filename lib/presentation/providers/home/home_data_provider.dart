import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/repositories/repositories.dart';
import 'package:prestapagos/presentation/providers/providers.dart';

class HomeData {
  final List<UltimoPago> ultimosPagos;
  final List<ProximoVencimiento> proximosVencimientos;
  final List<ClienteResumen> mejoresClientes;

  HomeData({
    required this.ultimosPagos,
    required this.proximosVencimientos,
    required this.mejoresClientes,
  });
}

final homeDataProvider = FutureProvider<HomeData>((ref) async {
  final db = ref.read(appDatabaseProvider);
  final repo = HomeRepositoryImpl(db: db);

  final results = await Future.wait([
    repo.getUltimosPagos(),
    repo.getProximosVencimientos(),
    repo.getMejoresClientes(),
  ]);

  return HomeData(
    ultimosPagos: results[0] as List<UltimoPago>,
    proximosVencimientos: results[1] as List<ProximoVencimiento>,
    mejoresClientes: results[2] as List<ClienteResumen>,
  );
});
