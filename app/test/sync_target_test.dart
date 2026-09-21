import 'package:flutter_test/flutter_test.dart';

import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

class _Gateway implements SyncTargetGateway {
  final listings = <String, List<File>>{
    '/': [File(path: '/', name: 'remote', type: 'DIR')],
    '/remote': [],
  };
  final created = <String>[];

  @override
  Future<List<File>> list(String path) async {
    if (!listings.containsKey(path)) {
      throw StateError('missing directory was listed: $path');
    }
    return List.of(listings[path]!);
  }

  @override
  Future<void> mkdir(String path, String name) async {
    created.add('$path/$name');
    listings[path]!.add(File(path: path, name: name, type: 'DIR'));
    listings['$path/$name'] = [];
  }
}

void main() {
  test('creates missing target directories from parent listings', () async {
    final gateway = _Gateway();
    final target = SyncTargetDirectory(gateway: gateway);

    await target.ensure('/remote/year/month');
    await target.ensure('/remote/year/month');

    expect(gateway.created, ['/remote/year', '/remote/year/month']);
  });

  test('records uploaded files in the run cache', () async {
    final gateway = _Gateway();
    final target = SyncTargetDirectory(gateway: gateway);
    await target.ensure('/remote/folder');

    target.record(
      '/remote/folder',
      File(path: '/remote/folder', name: 'photo.jpg', type: 'FILE'),
    );

    expect(
      target.find(await target.ensure('/remote/folder'), 'photo.jpg')?.name,
      'photo.jpg',
    );
  });

  test('resolves repository roots and identifies local targets', () {
    final local = Repo(
      path: '/',
      name: 'local',
      driver: 'local',
      status: true,
    );
    final remote = Repo(
      path: '/',
      name: 'remote',
      driver: 'webdav',
      status: true,
    );

    expect(
      SyncTargetRepository.resolve('/remote/photos', [local, remote]),
      remote,
    );
    expect(SyncTargetRepository.localRoots([local, remote]), {'/local'});
    expect(
      () => SyncTargetRepository.requireRemoteFrom('/local/docs', [
        local,
        remote,
      ]),
      throwsStateError,
    );
    expect(
      SyncTargetRepository.requireRemoteFrom('/remote/docs', [local, remote]),
      remote,
    );
  });
}
