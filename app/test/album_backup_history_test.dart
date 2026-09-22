import 'package:flutter_test/flutter_test.dart';
import 'package:maple_file/api/syncing/providers/album/service.dart';
import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

void main() {
  test('album result is converted to sync history and issues', () {
    final startedAt = DateTime.utc(2026, 9, 18, 10);
    final finishedAt = DateTime.utc(2026, 9, 18, 10, 2);
    final progress = SyncRunProgress()
      ..scanned = 4
      ..synced = 1
      ..skipped = 3
      ..issues.add(
        SyncHistoryIssue(
          sourceLabel: 'a.jpg',
          sourceKey: 'asset-1',
          sourcePath: 'album-1',
          kind: SyncHistoryIssue_Kind.KIND_ERROR,
          errorCode: SyncErrorCode.uploadFailed.value,
          errorMessage: '上传失败',
        ),
      );

    final history = AlbumBackupService.buildHistory(
      profileId: 7,
      runId: 'history-1',
      startedAt: startedAt,
      finishedAt: finishedAt,
      progress: progress,
    );

    expect(history.status, SyncHistory_Status.STATUS_PARTIAL);
    expect(history.scanned, 4);
    expect(history.synced, 1);
    expect(history.skipped, 3);
    expect(history.failed, 1);
    expect(history.issues.single.kind, SyncHistoryIssue_Kind.KIND_ERROR);
    expect(history.issues.single.sourcePath, 'album-1');
    expect(history.issues.single.sourceKey, 'asset-1');
    expect(history.issues.single.sourceLabel, 'a.jpg');
    expect(history.issues.single.errorMessage, '上传失败');
  });

  test('history-level error is retained in the summary', () {
    final progress = SyncRunProgress()
      ..scanned = 4
      ..synced = 2;
    const failure = SyncException(
      code: SyncErrorCode.sourcePermissionDenied,
      operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
      message: '无法访问照片',
    );
    progress.addRunFailure(failure);
    final history = AlbumBackupService.buildHistory(
      profileId: 7,
      runId: 'history-2',
      startedAt: DateTime.utc(2026, 9, 18, 10),
      finishedAt: DateTime.utc(2026, 9, 18, 10, 2),
      progress: progress,
      error: failure,
    );

    expect(history.status, SyncHistory_Status.STATUS_FAILED);
    expect(history.failed, 1);
    expect(history.scanned, 4);
    expect(history.synced, 2);
    expect(history.errorSummary, '无法访问照片');
    expect(history.issues.single.errorCode, 'source_permission_denied');
    expect(history.issues.single.sourcePath, isEmpty);
    expect(history.issues.single.sourceKey, isEmpty);
  });
}
