import 'package:riverpod/riverpod.dart';
import 'package:prestapagos/infrastructure/database/database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
});
