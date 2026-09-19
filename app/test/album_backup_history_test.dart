import 'package:flutter_test/flutter_test.dart';
import 'package:maple_file/api/syncing/providers/album.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

void main() {
  test('history and file issues round trip through database message', () {
    final history = AlbumBackupHistory(
      startedAt: DateTime.utc(2026, 9, 18, 10),
      finishedAt: DateTime.utc(2026, 9, 18, 10, 2),
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

    final message = history.toHistory(7, 'history-1');
    final restored = AlbumBackupHistory.fromHistory(message);

    expect(message.status, SyncHistory_Status.STATUS_PARTIAL);
    expect(message.synced, 1);
    expect(message.issues.single.kind, SyncHistoryIssue_Kind.KIND_ERROR);
    expect(message.issues.single.sourcePath, 'album-1');
    expect(message.issues.single.sourceKey, 'asset-1');
    expect(message.issues.single.sourceLabel, 'a.jpg');
    expect(restored.startedAt, history.startedAt);
    expect(restored.finishedAt, history.finishedAt);
    expect(restored.uploaded, 1);
    expect(restored.skipped, 3);
    expect(restored.failures.single.reason, '上传失败');
    expect(restored.failures.single.item, 'a.jpg');
  });

  test('history-level error is retained in the summary', () {
    final history = AlbumBackupHistory(
      startedAt: DateTime.utc(2026, 9, 18, 10),
      finishedAt: DateTime.utc(2026, 9, 18, 10, 2),
      uploaded: 0,
      skipped: 0,
      failures: const [],
      error: '无法访问照片',
    );
    final restored =
        AlbumBackupHistory.fromHistory(history.toHistory(7, 'history-2'));
    expect(restored.hasFailed, isTrue);
    expect(restored.error, '无法访问照片');
  });
}
