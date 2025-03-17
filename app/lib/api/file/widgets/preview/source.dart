import 'dart:io';

import 'package:maple_file/app/grpc.dart';
import 'package:path/path.dart' as filepath;

enum SourceType {
  file,
  asset,
  network,
}

enum PreviewRepeat {
  one,
  list,
  random,
}

class PreviewSource {
  final String name;
  final String source;
  final SourceType sourceType;

  PreviewSource({
    required this.name,
    required this.source,
    required this.sourceType,
  });

  PreviewSource.file(File file)
      : name = filepath.basename(file.path),
        source = file.path,
        sourceType = SourceType.file;

  PreviewSource.asset(String path)
      : name = filepath.basename(path),
        source = path,
        sourceType = SourceType.asset;

  PreviewSource.network(
    String url, {
    String? name,
  })  : name = name ?? filepath.url.basename(url),
        source = url,
        sourceType = SourceType.network;

  PreviewSource.local(String path)
      : name = filepath.basename(path),
        source = path,
        sourceType = SourceType.file;

  PreviewSource.remote(String path)
      : name = filepath.posix.basename(path),
        source = GRPC.instance.previewURL(path),
        sourceType = SourceType.network;
}
