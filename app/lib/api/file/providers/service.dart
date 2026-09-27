import 'dart:io' as io;
import 'dart:typed_data';
import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:path/path.dart' as filepath;
import 'package:grpc/grpc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/generated/proto/api/file/file.pbgrpc.dart';

class FileService {
  static const hashAlgorithm = 'sha256';

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

  Future<List<File>> list({
    Map<String, String>? filter,
    bool showError = true,
  }) {
    return doFuture(() async {
      File_ListRequest request = File_ListRequest(filter: filter);
      File_ListResponse response = await client.list(request);
      return response.results;
    }, showError: showError);
  }

  Future<void> move(
    String path,
    String newPath,
    List<String> names,
  ) {
    return doFuture(() {
      File_MoveRequest request = File_MoveRequest(
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
      File_CopyRequest request = File_CopyRequest(
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
      File_RenameRequest request = File_RenameRequest(
        path: path,
        name: name,
        newName: newName,
      );
      return client.rename(request);
    });
  }

  Future<void> mkdir(
    String path,
    String name, {
    bool showError = true,
  }) async {
    await doFuture(() {
      File_MkdirRequest request = File_MkdirRequest(
        path: path,
        name: name,
      );
      return client.mkdir(request);
    }, showError: showError);
  }

  Future<void> remove(
    String path,
    List<String> names,
  ) async {
    await doFuture(() {
      File_RemoveRequest request = File_RemoveRequest(
        path: path,
        names: names,
      );
      return client.remove(request);
    });
  }

  static Stream<File_UploadRequest> _upload(
    String path,
    io.File file, {
    String? newName,
    File_UploadPolicy uploadPolicy = File_UploadPolicy.UPLOAD_POLICY_INHERIT,
  }) async* {
    const int chunkSize = 1024 * 32;

    final size = await file.length();
    final name = newName ?? filepath.basename(file.path);

    // 第0片不包括chunk
    yield File_UploadRequest(
      path: path,
      size: fixnum.Int64(size),
      filename: name,
      uploadPolicy: uploadPolicy,
    );

    var index = 0;
    final readFile = await file.open();
    try {
      while (true) {
        final chunk = await readFile.read(chunkSize);
        if (chunk.isEmpty) break;
        index++;
        yield File_UploadRequest(
          path: path,
          size: fixnum.Int64(size),
          index: index,
          chunk: chunk,
          filename: name,
          uploadPolicy: uploadPolicy,
        );
      }
    } finally {
      await readFile.close();
    }
  }

  Future<List<File>> _uploadDir(
    String path,
    io.Directory dir, {
    bool recursive = true,
    File_UploadPolicy uploadPolicy = File_UploadPolicy.UPLOAD_POLICY_INHERIT,
  }) async {
    final root = filepath.dirname(dir.path);

    await client.mkdir(File_MkdirRequest(
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
        await client.mkdir(File_MkdirRequest(
          path: uploadPath,
          name: filepath.basename(entity.path),
        ));
        continue;
      }

      final response = await client.upload(_upload(
        uploadPath,
        entity as io.File,
        uploadPolicy: uploadPolicy,
      ));
      results.add(response.result);
    }
    return results;
  }

  Future<File> uploadFile(
    String path,
    io.File file,
    String name, {
    File_UploadPolicy uploadPolicy = File_UploadPolicy.UPLOAD_POLICY_INHERIT,
    bool showError = true,
  }) async {
    return doFuture(() async {
      final response = await client.upload(_upload(
        path,
        file,
        newName: name,
        uploadPolicy: uploadPolicy,
      ));
      return response.result;
    }, showError: showError);
  }

  Future<List<File>?> upload(
    String path, {
    List<io.File>? files,
    List<io.Directory>? dirs,
    Map<String, String>? newNames,
    bool recursive = true,
    File_UploadPolicy uploadPolicy = File_UploadPolicy.UPLOAD_POLICY_INHERIT,
  }) async {
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
        final stream = _upload(
          path,
          file,
          newName: newNames?[file.path],
          uploadPolicy: uploadPolicy,
        );

        final response = await client.upload(stream);

        results.add(response.result);
      }

      for (final dir in dirs ?? []) {
        results.addAll(await _uploadDir(
          path,
          dir,
          recursive: recursive,
          uploadPolicy: uploadPolicy,
        ));
      }
      return results;
    });
  }

  Future<Uint8List?> preview(String path) {
    return doFuture(() async {
      File_PreviewRequest request = File_PreviewRequest(path: path);

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
        File_DownloadRequest(path: path),
      );

      var ios = file.openWrite(mode: io.FileMode.write);

      await response.forEach((stream) {
        ios.add(stream.chunk);
      });
      ios.close();
    });
  }
}
