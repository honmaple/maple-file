import 'package:flutter_test/flutter_test.dart';
import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:maple_file/api/syncing/providers/album/profile.dart';
import 'package:maple_file/api/syncing/providers/album/service.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';
import 'package:maple_file/generated/proto/google/protobuf/timestamp.pb.dart';

void main() {
  group('album backup target path', () {
    const base = AlbumBackupTargetConfig(path: '/photos/backup');

    test('appends the device model when enabled', () {
      expect(
        AlbumBackupService.targetPath(base, 'iPhone 16 Pro'),
        '/photos/backup/iPhone 16 Pro',
      );
    });

    test('does not append an existing device model twice', () {
      const target = AlbumBackupTargetConfig(
        path: '/photos/backup/iPhone 16 Pro',
      );
      expect(
        AlbumBackupService.targetPath(target, 'iPhone 16 Pro'),
        '/photos/backup/iPhone 16 Pro',
      );
    });

    test('keeps the selected path when appending is disabled', () {
      const target = AlbumBackupTargetConfig(
        path: '/photos/backup',
        appendDeviceModel: false,
      );
      expect(
        AlbumBackupService.targetPath(target, 'iPhone 16 Pro'),
        '/photos/backup',
      );
    });

    test('sanitizes invalid path characters in the device model', () {
      expect(
        AlbumBackupService.targetPath(base, r'Phone/Pro:1'),
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
      AlbumBackupService.layoutPathParts(
        layout: AlbumTargetLayout.yearMonth,
        createdAt: date,
        albumName: '最近项目',
        isAndroid: false,
      ),
      ['2026', '09'],
    );
    expect(
      AlbumBackupService.layoutPathParts(
        layout: AlbumTargetLayout.yearMonthDay,
        createdAt: date,
        albumName: '最近项目',
        isAndroid: false,
      ),
      ['2026', '09', '19'],
    );
  });

  test('keeps the original photo name without appending the asset id', () {
    expect(
      AlbumBackupService.filename('IMG_1565.HEIC'),
      'IMG_1565.HEIC',
    );
  });

  test('filename is a single path component for nested source names', () {
    final name = AlbumBackupService.filename(r'Photos\IMG_1565.JPG');
    expect(name, 'IMG_1565.JPG');
    expect(name.contains('/'), isFalse);
    expect(name.contains(r'\'), isFalse);
  });

  test('flat layout uses the album name on iOS', () {
    expect(
      AlbumBackupService.layoutPathParts(
        layout: AlbumTargetLayout.flat,
        createdAt: DateTime(2026, 9, 19),
        albumName: '最近项目',
        isAndroid: false,
      ),
      ['最近项目'],
    );
  });

  test('flat layout uses the relative physical path on Android', () {
    expect(
      AlbumBackupService.layoutPathParts(
        layout: AlbumTargetLayout.flat,
        createdAt: DateTime(2026, 9, 19),
        albumName: '相机',
        isAndroid: true,
        relativePath: 'DCIM/Camera/',
      ),
      ['DCIM', 'Camera'],
    );
  });

  test('flat layout removes the storage root on older Android versions', () {
    expect(
      AlbumBackupService.layoutPathParts(
        layout: AlbumTargetLayout.flat,
        createdAt: DateTime(2026, 9, 19),
        albumName: '相机',
        isAndroid: true,
        relativePath: '/storage/emulated/0/DCIM/Camera',
      ),
      ['DCIM', 'Camera'],
    );
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
      AlbumBackupService.recordMatches(
          record, modified, '/backup/2026', 'IMG_1_asset.jpg', 1),
      isTrue,
    );
    expect(
      AlbumBackupService.recordMatches(
          record, modified, '/backup/new', null, 1),
      isFalse,
    );
    expect(
      AlbumBackupService.recordMatches(record,
          modified.add(const Duration(seconds: 1)), '/backup/2026', null, 1),
      isFalse,
    );
    expect(
      AlbumBackupService.recordMatches(
          record, modified, '/backup/2026', null, 2),
      isFalse,
    );
  });
}
