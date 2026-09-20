import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/api/syncing/providers/history.dart';
import 'package:maple_file/api/syncing/providers/local_directory.dart';
import 'package:maple_file/api/syncing/providers/profile.dart';
import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/app/task_scheduler.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

class LocalDirectorySyncState {
  const LocalDirectorySyncState({
    required this.profile,
    this.running = false,
  });

  final LocalDirectorySyncProfile profile;
  final bool running;

  LocalDirectorySyncState copyWith({
    LocalDirectorySyncProfile? profile,
    bool? running,
  }) {
    return LocalDirectorySyncState(
      profile: profile ?? this.profile,
      running: running ?? this.running,
    );
  }
}

class LocalDirectorySyncController
    extends StateNotifier<LocalDirectorySyncState> {
  LocalDirectorySyncController(this.ref, SyncProfile profile)
      : super(LocalDirectorySyncState(
          profile: LocalDirectorySyncProfile.fromSyncProfile(profile),
        )) {
    state = state.copyWith(running: _scheduler.isRunning(_taskId));
    _scheduler.addListener(_handleTaskStateChanged);
    ref.invalidate(syncHistoriesProvider(profile.id));
  }

  final Ref ref;
  final AppTaskScheduler _scheduler = AppTaskScheduler.instance;

  String get _taskId => 'local-directory-sync:${state.profile.id}';

  void _handleTaskStateChanged() {
    if (!mounted) return;
    final running = _scheduler.isRunning(_taskId);
    if (running == state.running) return;
    state = state.copyWith(running: running);
    if (!running) {
      ref.invalidate(syncHistoriesProvider(state.profile.id));
    }
  }

  Future<void> setEnabled(bool enabled) async {
    final updated = await SyncingService.instance.updateProfile(
      state.profile.copyWith(enabled: enabled).toSyncProfile(),
    );
    if (!mounted) return;
    state = state.copyWith(
      profile: LocalDirectorySyncProfile.fromSyncProfile(updated),
    );
    ref.invalidate(syncProfilesProvider);
  }

  void replaceProfile(SyncProfile profile) {
    state = state.copyWith(
      profile: LocalDirectorySyncProfile.fromSyncProfile(profile),
    );
  }

  Future<SyncHistory> run() {
    final profile = state.profile;
    return _scheduler.schedule(
      taskId: _taskId,
      task: () => LocalDirectorySyncService.instance.run(profile),
    );
  }

  @override
  void dispose() {
    _scheduler.removeListener(_handleTaskStateChanged);
    super.dispose();
  }
}

final localDirectorySyncProvider = StateNotifierProvider.autoDispose
    .family<LocalDirectorySyncController, LocalDirectorySyncState, SyncProfile>(
  LocalDirectorySyncController.new,
);
