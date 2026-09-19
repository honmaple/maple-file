import 'package:flutter_test/flutter_test.dart';
import 'package:maple_file/api/syncing/providers/album.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

void main() {
  test('album result is converted to sync history and issues', () {
    final startedAt = DateTime.utc(2026, 9, 18, 10);
    final finishedAt = DateTime.utc(2026, 9, 18, 10, 2);
    final result = AlbumBackupResult(
      scanned: 4,
      uploaded: 1,
      skipped: 3,
      failures: const [
        AlbumBackupFailure(
          album: '相机',
          item: 'a.jpg',
          itemKey: 'asset-1',
          sourceKey: 'album-1',
          reason: '上传失败',
        ),
      ],
    );

    final history = buildAlbumSyncHistory(
      profileId: 7,
      runId: 'history-1',
      startedAt: startedAt,
      finishedAt: finishedAt,
      result: result,
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
    final history = buildAlbumSyncHistory(
      profileId: 7,
      runId: 'history-2',
      startedAt: DateTime.utc(2026, 9, 18, 10),
      finishedAt: DateTime.utc(2026, 9, 18, 10, 2),
      error: '无法访问照片',
    );

    expect(history.status, SyncHistory_Status.STATUS_FAILED);
    expect(history.failed, 1);
    expect(history.errorSummary, '无法访问照片');
  });
}
