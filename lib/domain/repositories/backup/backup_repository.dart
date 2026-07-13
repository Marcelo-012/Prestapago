import 'package:prestapagos/domain/domain.dart';

abstract class BackupRepository {
  /// Ejecuta el flujo completo de respaldo emitiendo estados progresivos
  Stream<BackupStatus> performBackup();

  /// Ejecuta el flujo completo de restauración emitiendo estados progresivos
  Stream<BackupStatus> performRestore();
}
