import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prestapagos/config/errors/errors.dart';
import 'package:prestapagos/domain/domain.dart';
import 'package:prestapagos/infrastructure/datasources/datasources.dart';
import 'package:prestapagos/presentation/providers/config/account_provider.dart';

enum BackupFrequency { manual, daily, weekly }

class BackupState {
  final BackupStatusEnum currentStatus;
  final String currentMessage;
  final double? progress;
  final DateTime? lastSuccessfulBackup;
  final String lastBackupStatus;
  final bool isAutoBackupEnabled;
  final BackupFrequency frequency;

  const BackupState({
    required this.currentStatus,
    required this.currentMessage,
    this.progress,
    this.lastSuccessfulBackup,
    required this.lastBackupStatus,
    required this.isAutoBackupEnabled,
    required this.frequency,
  });

  BackupState copyWith({
    BackupStatusEnum? currentStatus,
    String? currentMessage,
    double? progress,
    DateTime? lastSuccessfulBackup,
    String? lastBackupStatus,
    bool? isAutoBackupEnabled,
    BackupFrequency? frequency,
  }) {
    return BackupState(
      currentStatus: currentStatus ?? this.currentStatus,
      currentMessage: currentMessage ?? this.currentMessage,
      progress: progress ?? this.progress,
      lastSuccessfulBackup: lastSuccessfulBackup ?? this.lastSuccessfulBackup,
      lastBackupStatus: lastBackupStatus ?? this.lastBackupStatus,
      isAutoBackupEnabled: isAutoBackupEnabled ?? this.isAutoBackupEnabled,
      frequency: frequency ?? this.frequency,
    );
  }

  bool get isRunning =>
      currentStatus == BackupStatusEnum.uploading ||
      currentStatus == BackupStatusEnum.downloading ||
      currentStatus == BackupStatusEnum.validating ||
      currentStatus == BackupStatusEnum.restoring ||
      currentStatus == BackupStatusEnum.authenticating;
}

class BackupNotifier extends Notifier<BackupState> {
  StreamSubscription<BackupStatus>? _backupSubscription;

  @override
  BackupState build() {
    final localBackup = ref.read(localBackupDatasourceProvider);
    final lastBackup = localBackup.getLastBackupTime();
    final freqStr = localBackup.getBackupFrequency();

    final frequency = switch (freqStr) {
      'daily' => BackupFrequency.daily,
      'weekly' => BackupFrequency.weekly,
      _ => BackupFrequency.manual,
    };

    final isAuto = frequency != BackupFrequency.manual;

    ref.onDispose(() {
      _backupSubscription?.cancel();
    });

    final backupStatus = localBackup.getBackupStatus();

    return BackupState(
      currentStatus: BackupStatusEnum.idle,
      currentMessage: '',
      lastSuccessfulBackup: lastBackup,
      lastBackupStatus: backupStatus,
      isAutoBackupEnabled: isAuto,
      frequency: frequency,
    );
  }

  Future<void> performBackup() async {
    final repository = ref.read(backupRepositoryProvider);

    try {
      final stream = repository.performBackup();
      final completer = Completer<void>();
      _backupSubscription = stream.listen(
        (status) {
          state = state.copyWith(
            currentStatus: status.status,
            currentMessage: status.message,
            progress: status.progress,
            lastSuccessfulBackup:
                status.lastSuccessfulBackup ?? state.lastSuccessfulBackup,
          );
        },
        onError: (error) {
          state = state.copyWith(
            currentStatus: BackupStatusEnum.failed,
            currentMessage: mapErrorToMessage(error),
          );
          NotificationService.showBackupFailure(state.currentMessage);
          completer.complete();
        },
        onDone: () {
          if (state.currentStatus != BackupStatusEnum.failed) {
            state = state.copyWith(currentStatus: BackupStatusEnum.idle);
            NotificationService.showBackupSuccess();
          }
          completer.complete();
        },
        cancelOnError: false,
      );
      await completer.future;
    } catch (e) {
      state = state.copyWith(
        currentStatus: BackupStatusEnum.failed,
        currentMessage: mapErrorToMessage(e),
      );
      NotificationService.showBackupFailure(state.currentMessage);
    }
  }

  Future<void> performRestore() async {
    final repository = ref.read(backupRepositoryProvider);

    try {
      final stream = repository.performRestore();
      final completer = Completer<void>();
      _backupSubscription = stream.listen(
        (status) {
          state = state.copyWith(
            currentStatus: status.status,
            currentMessage: status.message,
            progress: status.progress,
            lastSuccessfulBackup:
                status.lastSuccessfulBackup ?? state.lastSuccessfulBackup,
          );
        },
        onError: (error) {
          state = state.copyWith(
            currentStatus: BackupStatusEnum.failed,
            currentMessage: mapErrorToMessage(error),
          );
          NotificationService.showRestoreFailure(state.currentMessage);
          completer.complete();
        },
        onDone: () {
          if (state.currentStatus != BackupStatusEnum.failed) {
            state = state.copyWith(currentStatus: BackupStatusEnum.idle);
            NotificationService.showRestoreSuccess();
          }
          completer.complete();
        },
        cancelOnError: false,
      );
      await completer.future;
    } catch (e) {
      state = state.copyWith(
        currentStatus: BackupStatusEnum.failed,
        currentMessage: mapErrorToMessage(e),
      );
      NotificationService.showRestoreFailure(state.currentMessage);
    }
  }

  Future<void> setAutoBackup(bool enabled) async {
    final localBackup = ref.read(localBackupDatasourceProvider);
    final frequency = enabled ? BackupFrequency.daily : BackupFrequency.manual;
    await localBackup.setBackupFrequency(
      frequency == BackupFrequency.daily ? 'daily' : 'Manual',
    );
    state = state.copyWith(isAutoBackupEnabled: enabled, frequency: frequency);
  }

  Future<void> setFrequency(BackupFrequency frequency) async {
    final localBackup = ref.read(localBackupDatasourceProvider);
    final freqStr = switch (frequency) {
      BackupFrequency.daily => 'daily',
      BackupFrequency.weekly => 'weekly',
      BackupFrequency.manual => 'Manual',
    };
    await localBackup.setBackupFrequency(freqStr);
    state = state.copyWith(
      frequency: frequency,
      isAutoBackupEnabled: frequency != BackupFrequency.manual,
    );
  }
}

final backupProvider = NotifierProvider<BackupNotifier, BackupState>(
  BackupNotifier.new,
);

final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  throw UnimplementedError('BackupRepository must be initialized');
});
