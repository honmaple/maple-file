import 'dart:io' as io;
import 'dart:math' as math;
import 'dart:async';
import 'dart:typed_data';
import 'package:path/path.dart' as filepath;
import 'package:flutter/material.dart';

import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/app/app.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';
import 'package:maple_file/generated/proto/api/file/service.pbgrpc.dart';

class FileService {
  static final FileService _instance = FileService._internal();

  factory FileService() => _instance;

  late final FileServiceClient _client;

  FileService._internal() {
    _client = FileServiceClient(
      GRPC().client,
      // interceptors: [AccountInterceptor()],
    );
  }

  FileServiceClient get client {
    return _client;
  }

  Future<List<File>> list({Map<String, String>? filter}) async {
    final result = await doFuture(() async {
      ListFilesRequest request = ListFilesRequest(filter: filter);
      ListFilesResponse response = await _client.list(request);
      return response.results;
    });
    return result.data ?? <File>[];
  }

  Future<void> move(
    String path,
    String newPath,
    List<String> names,
  ) async {
    await doFuture(() {
      MoveFileRequest request = MoveFileRequest(
        path: path,
        newPath: newPath,
        names: names,
      );
      return _client.move(request);
    });
  }

  Future<void> copy(
    String path,
    String newPath,
    List<String> names,
  ) async {
    await doFuture(() {
      CopyFileRequest request = CopyFileRequest(
        path: path,
        newPath: newPath,
        names: names,
      );
      return _client.copy(request);
    });
  }

  Future<void> rename(
    String path,
    String name,
    String newName,
  ) async {
    await doFuture(() {
      RenameFileRequest request = RenameFileRequest(
        path: path,
        name: name,
        newName: newName,
      );
      return _client.rename(request);
    });
  }

  Future<void> mkdir(
    String path,
    String name,
  ) async {
    await doFuture(() {
      MkdirFileRequest request = MkdirFileRequest(
        path: path,
        name: name,
      );
      return _client.mkdir(request);
    });
  }

  Future<void> remove(
    String path,
    List<String> names,
  ) async {
    await doFuture(() {
      RemoveFileRequest request = RemoveFileRequest(
        path: path,
        names: names,
      );
      return _client.remove(request);
    });
  }

  Stream<FileRequest> _upload(String path, io.File file) async* {
    const int chunkSize = 1024 * 32;

    var size = file.lengthSync();

    // 第0片不包括chunk
    yield FileRequest(
      path: path,
      size: size,
      filename: filepath.basename(file.path),
    );

    var index = 0;
    var readFile = file.openSync();
    var readSize = math.min(chunkSize, size);

    var chunk = readFile.readSync(readSize);
    while (chunk.length >= readSize) {
      index++;

      yield FileRequest(
        path: path,
        size: size,
        index: index,
        chunk: chunk.toList(),
        filename: filepath.basename(file.path),
      );

      chunk = readFile.readSync(readSize);
    }
    if (chunk.isNotEmpty) {
      yield FileRequest(
        path: path,
        size: size,
        index: index + 1,
        chunk: chunk.toList(),
        filename: filepath.basename(file.path),
      );
    }
  }

  Future<List<File>?> upload(
    String path,
    List<io.File> files,
  ) async {
    final result = await doFuture(() async {
      List<File> results = <File>[];

      for (final file in files) {
        final response = await _client.upload(_upload(path, file));

        results.add(response.result);
      }
      return results;
    });
    return result.data;
  }

  Future<Uint8List?> preview(String path) async {
    final result = await doFuture(() async {
      PreviewFileRequest request = PreviewFileRequest(path: path);

      final response = _client.preview(request);

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
    return result.data;
  }

  Future<void> download(String path, io.File file) {
    return doFuture(() async {
      if (file.existsSync()) {
        App.showSnackBar(const Text("文件已存在"));
        return;
      }

      final response = _client.download(
        DownloadFileRequest(path: path),
      );

      var ios = file.openWrite(mode: io.FileMode.append);

      await response.forEach((stream) {
        ios.add(stream.chunk);
      });
      ios.close();
    });
  }

  Future<List<Repo>> listRepos({Map<String, String>? filterMap}) async {
    final result = await doFuture(() async {
      ListReposRequest request = ListReposRequest();
      ListReposResponse response = await _client.listRepos(request);
      return response.results;
    });
    return result.data ?? <Repo>[];
  }

  Future<void> testRepo(Repo payload) {
    return doFuture(() {
      TestRepoRequest request = TestRepoRequest();
      request.payload = payload;

      return _client.testRepo(request).then((response) {
        App.showSnackBar(const Text("连接成功"));
      });
    });
  }

  Future<Response<Repo>> createRepo(Repo payload) {
    return doFuture(() async {
      CreateRepoRequest request = CreateRepoRequest(payload: payload);
      CreateRepoResponse response = await _client.createRepo(request);
      return response.result;
    });
  }

  Future<Response<Repo>> updateRepo(Repo payload) {
    return doFuture(() async {
      UpdateRepoRequest request = UpdateRepoRequest(payload: payload);
      UpdateRepoResponse response = await _client.updateRepo(request);
      return response.result;
    });
  }

  Future<void> deleteRepo(int id) {
    return doFuture(() {
      DeleteRepoRequest request = DeleteRepoRequest(id: id);
      return _client.deleteRepo(request);
    });
  }

}
