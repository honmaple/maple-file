import 'package:flutter_test/flutter_test.dart';
import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';
import 'package:maple_file/generated/proto/google/protobuf/timestamp.pb.dart';

void main() {
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

  test('a record is stale after a photo or destination change', () {
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
