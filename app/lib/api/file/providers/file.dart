import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/common/providers/selection.dart';
import 'package:maple_file/common/providers/pagination.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';

import 'service.dart';
import 'file_setting.dart';

class FileNotifier extends FamilyAsyncNotifier<List<File>, String>
    with PaginationNotifierMixin<File> {
  @override
  FutureOr<List<File>> build(String arg) async {
    final size = ref.watch(fileSettingProvider.select((state) {
      return state.paginationSize;
    }));

    final results = await FileService.instance.list(
      filter: {
        "path": arg,
        "page_size": "$size",
      },
    );

    final sort = ref.watch(fileSettingProvider.select((state) {
      return state.sort;
    }));

    switch (sort) {
      case FileListSort.name:
        results.sort((a, b) {
          return b.name.compareTo(a.name);
        });
        break;
      case FileListSort.type:
        results.sort((a, b) {
          return b.type.compareTo(a.type);
        });
        break;
      case FileListSort.size:
        results.sort((a, b) {
          return b.size.compareTo(a.size);
        });
        break;
      case FileListSort.time:
        results.sort((a, b) {
          return b.updatedAt.seconds.compareTo(a.updatedAt.seconds);
        });
        break;
    }
    final sortReversed =
        ref.watch(fileSettingProvider.select((state) => state.sortReversed));
    if (sortReversed) {
      return results.reversed.toList();
    }
    return results;
  }

  @override
  FutureOr<List<File>> fetch(int page) async {
    final size = ref.read(fileSettingProvider.select((state) {
      return state.paginationSize;
    }));
    if (size == 0) {
      return <File>[];
    }
    final results = await FileService.instance.list(
      filter: {"path": arg, "page": "$page", "page_size": "$size"},
    );
    return results;
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
