import 'package:flutter_test/flutter_test.dart';
import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:maple_file/api/syncing/providers/album.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';
import 'package:maple_file/generated/proto/google/protobuf/timestamp.pb.dart';

void main() {
  group('album backup target path', () {
    const base = AlbumBackupTargetConfig(path: '/photos/backup');

    test('appends the device model when enabled', () {
      expect(
        albumBackupTargetPath(base, 'iPhone 16 Pro'),
        '/photos/backup/iPhone 16 Pro',
      );
    });

    test('does not append an existing device model twice', () {
      const target = AlbumBackupTargetConfig(
        path: '/photos/backup/iPhone 16 Pro',
      );
      expect(
        albumBackupTargetPath(target, 'iPhone 16 Pro'),
        '/photos/backup/iPhone 16 Pro',
      );
    });

    test('keeps the selected path when appending is disabled', () {
      const target = AlbumBackupTargetConfig(
        path: '/photos/backup',
        appendDeviceModel: false,
      );
      expect(
        albumBackupTargetPath(target, 'iPhone 16 Pro'),
        '/photos/backup',
      );
    });

    test('sanitizes invalid path characters in the device model', () {
      expect(
        albumBackupTargetPath(base, r'Phone/Pro:1'),
        '/photos/backup/Phone_Pro_1',
      );
    });
  });

  test('target layout supports year and month folders', () {
    final date = DateTime(2026, 9, 19);

    expect(
      AlbumTargetLayout.fromValue('year_month'),
      AlbumTargetLayout.yearMonth,
    );
    expect(
      AlbumTargetLayout.yearMonth.pathParts(date),
      ['2026', '09'],
    );
    expect(
      AlbumTargetLayout.yearMonthDay.pathParts(date),
      ['2026', '09', '19'],
    );
    expect(AlbumTargetLayout.filenameAssetId.pathParts(date), isEmpty);
  });

  test('iOS asset identifier cannot create subdirectories in upload name', () {
    expect(
      albumBackupFilename('IMG_1565.HEIC', 'F6A1B2C3/L0/001'),
      'IMG_1565_F6A1B2C3_L0_001.HEIC',
    );
  });

  test('filename is a single path component for nested source names', () {
    final name = albumBackupFilename(r'Photos\IMG_1565.JPG', r'asset\123');
    expect(name, 'IMG_1565_asset_123.JPG');
    expect(name.contains('/'), isFalse);
    expect(name.contains(r'\'), isFalse);
  });

  test('a record is stale after a photo or target change', () {
    final modified = DateTime.utc(2026, 9, 18, 10);
    final record = SyncRecord(
      targetPath: '/backup/2026/IMG_1_asset.jpg',
      sourceModifiedAt: Timestamp.fromDateTime(modified),
      state: SyncRecord_State.STATE_ACTIVE,
      configVersion: fixnum.Int64(1),
    );
    expect(
      albumBackupRecordMatches(
          record, modified, '/backup/2026', 'IMG_1_asset.jpg', 1),
      isTrue,
    );
    expect(
      albumBackupRecordMatches(record, modified, '/backup/new', null, 1),
      isFalse,
    );
    expect(
      albumBackupRecordMatches(record, modified.add(const Duration(seconds: 1)),
          '/backup/2026', null, 1),
      isFalse,
    );
    expect(albumBackupRecordMatches(record, modified, '/backup/2026', null, 2),
        isFalse);
  });
}
