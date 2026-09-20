import 'dart:io';

import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:flutter_test/flutter_test.dart';

import 'package:maple_file/api/syncing/providers/local_directory.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart' as remote;
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';
import 'package:maple_file/generated/proto/google/protobuf/timestamp.pb.dart';

void main() {
  test('local directory profile encodes typed configuration', () {
    final profile =
        LocalDirectorySyncProfile.create(name: 'Documents').copyWith(
      sourceConfig: const LocalDirectorySourceConfig(
        path: '/Users/test/Documents',
        bookmark: 'bookmark',
      ),
      targetConfig: const LocalDirectoryTargetConfig(path: '/remote/docs'),
    );

    final decoded =
        LocalDirectorySyncProfile.fromSyncProfile(profile.toSyncProfile());

    expect(decoded.sourceConfig.path, '/Users/test/Documents');
    expect(decoded.sourceConfig.bookmark, 'bookmark');
    expect(decoded.targetConfig.path, '/remote/docs');
    expect(decoded.toSyncProfile().mode, SyncProfile_Mode.MODE_ONE_WAY);
  });

  test('maps nested and hidden files without the source root name', () {
    final separator = Platform.pathSeparator;
    final root = '${separator}data${separator}source';
    final file = '$root${separator}.hidden${separator}photo.jpg';

    expect(
      localDirectoryTargetPath(
        sourceRoot: root,
        sourceFile: file,
        targetRoot: '/remote/backup',
      ),
      '/remote/backup/.hidden/photo.jpg',
    );
  });

  test('includes hidden files and excludes symbolic links from scan', () async {
    final directory = await Directory.systemTemp.createTemp('local-scan-test');
    addTearDown(() => directory.delete(recursive: true));
    final hidden = File(
      '${directory.path}${Platform.pathSeparator}.hidden',
    );
    await hidden.writeAsString('hidden');
    final entities = <FileSystemEntity>[hidden];
    if (!Platform.isWindows) {
      final link = Link('${directory.path}${Platform.pathSeparator}link');
      await link.create(hidden.path);
      entities.add(link);
    }

    final result = localDirectoryScanEntries(entities);

    expect(result.files.map((file) => file.path), [hidden.path]);
    expect(result.directories, isEmpty);
  });

  test('detects skip, source changes, missing targets, and conflicts',
      () async {
    final directory = await Directory.systemTemp.createTemp('local-sync-test');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}${Platform.pathSeparator}item.txt');
    await file.writeAsString('one');
    final stat = await file.stat();
    final target = remote.File(
      path: '/remote',
      name: 'item.txt',
      type: 'FILE',
      size: fixnum.Int64(stat.size),
      updatedAt: Timestamp.fromDateTime(stat.modified),
    );
    final record = SyncRecord(
      state: SyncRecord_State.STATE_ACTIVE,
      configVersion: fixnum.Int64(1),
      sourceSize: fixnum.Int64(stat.size),
      sourceModifiedAt: Timestamp.fromDateTime(stat.modified),
      targetPath: '/remote/item.txt',
      targetSize: fixnum.Int64(stat.size),
      targetModifiedAt: Timestamp.fromDateTime(stat.modified),
    );

    expect(
      localDirectorySyncDecision(
        record: record,
        source: stat,
        targetPath: '/remote/item.txt',
        target: target,
        configVersion: 1,
      ),
      LocalDirectorySyncDecision.skip,
    );
    expect(
      localDirectorySyncDecision(
        record: record,
        source: stat,
        targetPath: '/remote/item.txt',
        target: null,
        configVersion: 1,
      ),
      LocalDirectorySyncDecision.upload,
    );
    expect(
      localDirectorySyncDecision(
        record: null,
        source: stat,
        targetPath: '/remote/item.txt',
        target: target,
        configVersion: 1,
      ),
      LocalDirectorySyncDecision.conflictWithoutBaseline,
    );

    final changedTarget = remote.File(
      path: target.path,
      name: target.name,
      type: target.type,
      size: fixnum.Int64(stat.size + 1),
      updatedAt: target.updatedAt,
    );
    expect(
      localDirectorySyncDecision(
        record: record,
        source: stat,
        targetPath: '/remote/item.txt',
        target: changedTarget,
        configVersion: 1,
      ),
      LocalDirectorySyncDecision.conflictModified,
    );

    await file.writeAsString('changed');
    final changedSource = await file.stat();
    expect(
      localDirectorySyncDecision(
        record: record,
        source: changedSource,
        targetPath: '/remote/item.txt',
        target: target,
        configVersion: 1,
      ),
      LocalDirectorySyncDecision.upload,
    );
  });
}
