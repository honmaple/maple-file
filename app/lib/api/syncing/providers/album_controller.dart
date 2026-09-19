import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/api/syncing/providers/album.dart';
import 'package:maple_file/api/syncing/providers/history.dart';
import 'package:maple_file/api/syncing/providers/profile.dart';
import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/app/task_scheduler.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

class AlbumBackupState {
  const AlbumBackupState({
    required this.profile,
    this.albumNames = const {},
    this.running = false,
  });

  final AlbumBackupProfile profile;
  final Map<String, String> albumNames;
  final bool running;

  String get albumSummary =>
      profile.sourceConfig.albumIds.map((id) => albumNames[id] ?? id).join('、');

  AlbumBackupState copyWith({
    AlbumBackupProfile? profile,
    Map<String, String>? albumNames,
    bool? running,
  }) {
    return AlbumBackupState(
      profile: profile ?? this.profile,
      albumNames: albumNames ?? this.albumNames,
      running: running ?? this.running,
    );
  }
}

class AlbumBackupController extends StateNotifier<AlbumBackupState> {
  AlbumBackupController(this.ref, SyncProfile profile)
      : super(AlbumBackupState(
          profile: AlbumBackupProfile.fromSyncProfile(profile),
        )) {
    state = state.copyWith(running: _scheduler.isRunning(_taskId));
    _scheduler.addListener(_handleTaskStateChanged);
    ref.invalidate(syncHistoriesProvider(profile.id));
    if (Util.isAndroid || Util.isIOS) loadAlbumNames();
  }

  final Ref ref;
  final AppTaskScheduler _scheduler = AppTaskScheduler.instance;

  String get _taskId => 'album-backup:${state.profile.id}';

  void _handleTaskStateChanged() {
    if (!mounted) return;
    final running = _scheduler.isRunning(_taskId);
    if (running == state.running) return;
    state = state.copyWith(running: running);
    if (!running) {
      ref.invalidate(syncHistoriesProvider(state.profile.id));
    }
  }

  Future<void> loadAlbumNames() async {
    try {
      final albums =
          await AlbumBackupService.instance.requestAlbums(includeEmpty: true);
      if (!mounted) return;
      state = state.copyWith(
        albumNames: {for (final album in albums) album.id: album.name},
      );
    } catch (_) {
      // Album selection requests permission when opened.
    }
  }

  Future<void> setEnabled(bool enabled) async {
    final updated = await SyncingService.instance.updateProfile(
      state.profile.copyWith(enabled: enabled).toSyncProfile(),
    );
    if (!mounted) return;
    state = state.copyWith(
      profile: AlbumBackupProfile.fromSyncProfile(updated),
    );
    ref.invalidate(syncProfilesProvider);
  }

  void replaceProfile(SyncProfile profile) {
    state = state.copyWith(
      profile: AlbumBackupProfile.fromSyncProfile(profile),
    );
    loadAlbumNames();
  }

  Future<SyncHistory> run() async {
    final profile = state.profile;
    return _scheduler.schedule(
      taskId: _taskId,
      task: () => AlbumBackupService.instance.run(profile),
    );
  }

  @override
  void dispose() {
    _scheduler.removeListener(_handleTaskStateChanged);
    super.dispose();
  }
}

final albumBackupProvider = StateNotifierProvider.autoDispose
    .family<AlbumBackupController, AlbumBackupState, SyncProfile>(
  AlbumBackupController.new,
);
