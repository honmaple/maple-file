import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/common/providers/selection.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';

import 'service.dart';
import 'file_setting.dart';

class FileNotifier extends FamilyAsyncNotifier<List<File>, String> {
  final _client = FileService().client;

  @override
  FutureOr<List<File>> build(String arg) async {
    ListFilesRequest request = ListFilesRequest(path: arg);
    ListFilesResponse response = await _client.list(request);

    final sort = ref.watch(fileSettingProvider.select((state) => state.sort));
    switch (sort) {
      case FileListSort.NAME:
        response.results.sort((a, b) {
          return b.name.compareTo(a.name);
        });
        break;
      case FileListSort.TYPE:
        response.results.sort((a, b) {
          return b.type.compareTo(a.type);
        });
        break;
      case FileListSort.SIZE:
        response.results.sort((a, b) {
          return b.size.compareTo(a.size);
        });
        break;
      case FileListSort.TIME:
        response.results.sort((a, b) {
          return b.updatedAt.seconds.compareTo(a.updatedAt.seconds);
        });
        break;
    }
    final sortReversed =
        ref.watch(fileSettingProvider.select((state) => state.sortReversed));
    if (sortReversed) {
      return response.results.reversed.toList();
    }
    return response.results;
  }
}

final fileProvider =
    AsyncNotifierProvider.family<FileNotifier, List<File>, String>(() {
  return FileNotifier();
});
final fileSelectionProvider =
    NotifierProvider<SelectionNotifier<File>, Selection<File>>(() {
  return SelectionNotifier(
      compare: (o, n) => o.path == n.path && o.name == n.name);
});
