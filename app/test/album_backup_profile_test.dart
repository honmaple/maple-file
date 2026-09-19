import 'dart:convert';

import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:flutter_test/flutter_test.dart';
import 'package:maple_file/api/syncing/providers/album.dart';
import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

void main() {
  test('album backup config is decoded once into typed fields', () {
    final profile = SyncProfile(
      id: 7,
      name: '相册备份',
      enabled: true,
      mode: SyncProfile_Mode.MODE_BACKUP,
      sourceType: SyncSourceType.album.value,
      sourceConfig: jsonEncode({
        'album_ids': ['album-1', 'album-2'],
      }),
      targetType: SyncTargetType.repoDirectory.value,
      targetConfig: jsonEncode({
        'path': '/photos/phone',
        'layout': AlbumTargetLayout.yearMonth.value,
      }),
      configVersion: fixnum.Int64(3),
      policyConfig: '{}',
    );

    final albumProfile = AlbumBackupProfile.fromSyncProfile(profile);

    expect(albumProfile.sourceConfig.albumIds, ['album-1', 'album-2']);
    expect(albumProfile.targetConfig.path, '/photos/phone');
    expect(albumProfile.targetConfig.layout, AlbumTargetLayout.yearMonth);
    expect(albumProfile.targetConfig.appendDeviceModel, isTrue);
    expect(albumProfile.configVersion, 3);
  });

  test('typed changes are encoded back into sync config', () {
    final profile = AlbumBackupProfile.create(name: '相册备份').copyWith(
      sourceConfig: AlbumBackupSourceConfig(albumIds: ['album-1']),
      targetConfig: const AlbumBackupTargetConfig(
        path: '/photos',
        layout: AlbumTargetLayout.filenameAssetId,
        appendDeviceModel: false,
      ),
    );

    final message = profile.toSyncProfile();
    final source = jsonDecode(message.sourceConfig) as Map<String, dynamic>;
    final target = jsonDecode(message.targetConfig) as Map<String, dynamic>;

    expect(source['album_ids'], ['album-1']);
    expect(target['path'], '/photos');
    expect(target['layout'], 'filename_asset_id');
    expect(target['append_device_model'], isFalse);
  });
}
