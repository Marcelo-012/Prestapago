import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:prestapagos/infrastructure/database/database.dart';
import 'package:prestapagos/infrastructure/database/seed_data.dart';

final closeDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();

  unawaited(Future(() async {
    final deudores = await database.select(database.deudores).get();
    if (deudores.isEmpty) {
      await seedDatabase(database);
    }
  }));

  ref.onDispose(() => database.close());
  return database;
});
