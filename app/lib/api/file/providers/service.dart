import 'dart:io' as io;
import 'dart:math' as math;
import 'dart:core';
import 'dart:typed_data';
import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:path/path.dart' as filepath;
import 'package:grpc/grpc.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/common/utils/isolate.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';
import 'package:maple_file/generated/proto/api/file/service.pbgrpc.dart';

class FileService {
  static FileService get instance => _instance;
  static final FileService _instance = FileService._internal();
  factory FileService() => _instance;
  FileService._internal();

  FileServiceClient? _client;
  DateTime _clientTime = DateTime.now();

  FileServiceClient get client {
    if (_client == null || Grpc.instance.connectTime.isAfter(_clientTime)) {
      _client = FileServiceClient(
        Grpc.instance.client,
        options: CallOptions(
          metadata: {"Authorization": "Bearer ${Grpc.instance.token}"},
        ),
      );
      _clientTime = Grpc.instance.connectTime;
    }
    return _client!;
  }

  Future<List<File>> list({Map<String, String>? filter}) async {
    return doFuture(() async {
      ListFilesRequest request = ListFilesRequest(filter: filter);
      ListFilesResponse response = await client.list(request);
      return response.results;
    });
  }

  Future<void> move(
    String path,
    String newPath,
    List<String> names,
  ) {
    return doFuture(() {
      MoveFileRequest request = MoveFileRequest(
        path: path,
        newPath: newPath,
        names: names,
      );
      return client.move(request);
    });
  }

  Future<void> copy(
    String path,
    String newPath,
    List<String> names,
  ) {
    return doFuture(() {
      CopyFileRequest request = CopyFileRequest(
        path: path,
        newPath: newPath,
        names: names,
      );
      return client.copy(request);
    });
  }

  Future<void> rename(
    String path,
    String name,
    String newName,
  ) {
    return doFuture(() {
      RenameFileRequest request = RenameFileRequest(
        path: path,
        name: name,
        newName: newName,
      );
      return client.rename(request);
    });
  }

  Future<void> mkdir(
    String path,
    String name,
  ) {
    return doFuture(() {
      MkdirFileRequest request = MkdirFileRequest(
        path: path,
        name: name,
      );
      return client.mkdir(request);
    });
  }

  Future<void> remove(
    String path,
    List<String> names,
  ) {
    return doFuture(() {
      RemoveFileRequest request = RemoveFileRequest(
        path: path,
        names: names,
      );
      return client.remove(request);
    });
  }

  // isolate必须使用static函数
  static Stream<FileRequest> _upload(
    String path,
    io.File file, {
    String? newName,
  }) async* {
    const int chunkSize = 1024 * 32;

    var size = file.lengthSync();
    var name = newName ?? filepath.basename(file.path);

    // 第0片不包括chunk
    yield FileRequest(
      path: path,
      size: fixnum.Int64(size),
      filename: name,
    );

    var index = 0;
    var readFile = file.openSync();
    var readSize = math.min(chunkSize, size);

    var chunk = readFile.readSync(readSize);
    while (chunk.length >= readSize) {
      index++;

      yield FileRequest(
        path: path,
        size: fixnum.Int64(size),
        index: index,
        chunk: chunk.toList(),
        filename: name,
      );

      chunk = readFile.readSync(readSize);
    }
    if (chunk.isNotEmpty) {
      yield FileRequest(
        path: path,
        size: fixnum.Int64(size),
        index: index + 1,
        chunk: chunk.toList(),
        filename: name,
      );
    }
  }

  Future<List<File>> _uploadDir(
    String path,
    io.Directory dir, {
    bool recursive = true,
  }) async {
    final root = filepath.dirname(dir.path);

    await client.mkdir(MkdirFileRequest(
      path: path,
      name: filepath.basename(dir.path),
    ));

    List<File> results = <File>[];

    await for (final entity in dir.list(
      recursive: recursive,
      followLinks: false,
    )) {
      String realPath =
          filepath.dirname(entity.path).substring(root.length + 1);
      if (Util.isWindows) {
        realPath = filepath.toUri(realPath).path;
      }

      final uploadPath = filepath.posix.join(path, realPath);

      if (entity is io.Directory) {
        await client.mkdir(MkdirFileRequest(
          path: uploadPath,
          name: filepath.basename(entity.path),
        ));
        continue;
      }

      final response = await client.upload(_upload(
        uploadPath,
        entity as io.File,
      ));
      results.add(response.result);
    }
    return results;
  }

  Future<List<File>?> upload(
    String path, {
    List<io.File>? files,
    List<io.Directory>? dirs,
    Map<String, String>? newNames,
    bool recursive = true,
  }) {
    final dirsCount = dirs?.length ?? 0;
    final filesCount = files?.length ?? 0;

    SmartDialog.showNotify(
      msg: "共有{file_count}{sep}{dir_count}添加至上传任务".tr(args: {
        "sep": dirsCount > 0 && filesCount > 0 ? ", " : "",
        "dir_count": dirsCount == 0
            ? ""
            : "{count}个文件夹".tr(args: {
                "count": dirsCount,
              }),
        "file_count": filesCount == 0
            ? ""
            : "{count}个文件".tr(args: {
                "count": filesCount,
              }),
      }),
      notifyType: NotifyType.success,
    );

    return doFuture(() async {
      List<File> results = <File>[];

      for (final file in files ?? []) {
        final stream = await IsolateUtil.streamCompute<
            (String, String, String?),
            FileRequest>(((String, String, String?) args) {
          return _upload(args.$1, io.File(args.$2), newName: args.$3);
        }, (path, file.path, newNames == null ? null : newNames[file.path]));

        final response = await client.upload(stream);

        results.add(response.result);
      }

      for (final dir in dirs ?? []) {
        results.addAll(await _uploadDir(path, dir, recursive: recursive));
      }
      return results;
    });
  }

  Future<Uint8List?> preview(String path) {
    return doFuture(() async {
      PreviewFileRequest request = PreviewFileRequest(path: path);

      final response = client.preview(request);

      List<List<int>> chunks = <List<int>>[];
      int contentLength = 0;

      await response.forEach((stream) {
        chunks.add(stream.chunk);
        contentLength += stream.chunk.length;
      });

      Uint8List bytes = Uint8List(contentLength);
      int offset = 0;
      for (final List<int> chunk in chunks) {
        bytes.setRange(offset, offset + chunk.length, chunk);
        offset += chunk.length;
      }
      return bytes;
    });
  }

  Future<void> download(
    String path,
    io.File file, {
    bool override = false,
  }) {
    return doFuture(() async {
      if (file.existsSync() && !override) {
        SmartDialog.showNotify(
          msg: "文件已存在".tr(),
          notifyType: NotifyType.warning,
        );
        return;
      }

      final response = client.download(
        DownloadFileRequest(path: path),
      );

      var ios = file.openWrite(mode: io.FileMode.write);

      await response.forEach((stream) {
        ios.add(stream.chunk);
      });
      ios.close();
    });
  }

  Future<List<Repo>> listRepos({Map<String, String>? filterMap}) {
    return doFuture(() async {
      ListReposRequest request = ListReposRequest();
      ListReposResponse response = await client.listRepos(request);
      return response.results;
    });
  }

  Future<void> testRepo(Repo payload) {
    return doFuture(() {
      TestRepoRequest request = TestRepoRequest();
      request.payload = payload;

      return client.testRepo(request).then((response) {
        SmartDialog.showNotify(
          msg: "连接成功".tr(),
          notifyType: NotifyType.warning,
        );
      });
    });
  }

  Future<Repo> createRepo(Repo payload) {
    return doFuture(() async {
      CreateRepoRequest request = CreateRepoRequest(payload: payload);
      CreateRepoResponse response = await client.createRepo(request);
      return response.result;
    });
  }

  Future<Repo> updateRepo(Repo payload) {
    return doFuture(() async {
      UpdateRepoRequest request = UpdateRepoRequest(payload: payload);
      UpdateRepoResponse response = await client.updateRepo(request);
      return response.result;
    });
  }

  Future<void> deleteRepo(int id) {
    return doFuture(() {
      DeleteRepoRequest request = DeleteRepoRequest(id: id);
      return client.deleteRepo(request);
    });
  }
}
