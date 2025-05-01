import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path/path.dart' as filepath;

import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/common/utils/path.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';

import '../widgets/preview/text.dart';
import '../widgets/preview/video.dart';
import '../widgets/preview/image.dart';
import '../widgets/preview/audio.dart';
import '../widgets/preview/source.dart';
import '../widgets/file_action.dart';

import '../providers/file.dart';

class FileSource extends PreviewSource {
  final File file;

  FileSource({
    required this.file,
  }) : super(
          type: SourceType.network,
          name: file.name,
          path: GRPC.instance.previewURL(filepath.posix.join(
            file.path,
            file.name,
          )),
        );
}

abstract class FilePreviewBase extends ConsumerStatefulWidget {
  final File file;
  final List<File>? files;

  const FilePreviewBase({super.key, required this.file, this.files});
}

abstract class FilePreviewBaseState<T extends FilePreviewBase>
    extends ConsumerState<T> {
  File get _file => _sources[_index].file;

  late final List<FileSource> _sources;
  int _index = 0;

  bool filter(File file);

  @override
  void initState() {
    super.initState();

    List<File> currentFiles = [];
    if (widget.files != null) {
      currentFiles = widget.files!.where(filter).toList();
    }

    if (currentFiles.isEmpty) {
      currentFiles = [widget.file];
    }

    int index = currentFiles.indexWhere((file) {
      return file.type == widget.file.type && file.name == widget.file.name;
    });
    if (index < 0) {
      index = 0;
    }

    _index = index;
    _sources = currentFiles.map((file) => FileSource(file: file)).toList();
  }
}

class FilePreview extends ConsumerStatefulWidget {
  final File file;

  const FilePreview({super.key, required this.file});

  factory FilePreview.fromRoute(ModalRoute? route) {
    final args = route?.settings.arguments as Map<String, dynamic>;
    return FilePreview(
      file: args["file"],
    );
  }

  @override
  ConsumerState<FilePreview> createState() => _FilePreviewState();
}

class _FilePreviewState extends ConsumerState<FilePreview> {
  (List<FileSource>, int) getFiles(List<File> allFiles) {
    List<File> files = allFiles.where((file) {
      return PathUtil.isVideo(file.name, type: file.type);
    }).toList();

    if (files.isEmpty) {
      files = [widget.file];
    }

    int index = files.indexWhere((file) {
      return file.type == widget.file.type && file.name == widget.file.name;
    });
    if (index < 0) {
      index = 0;
    }
    return (files.map((file) => FileSource(file: file)).toList(), index);
  }

  @override
  Widget build(BuildContext context) {
    if (PathUtil.isVideo(widget.file.name, type: widget.file.type)) {
      return FileVideoPreview(
        file: widget.file,
        files: ref.read(fileProvider(widget.file.path)).valueOrNull,
      );
    }
    if (PathUtil.isImage(widget.file.name, type: widget.file.type)) {
      return FileImagePreview(
        file: widget.file,
        files: ref.read(fileProvider(widget.file.path)).valueOrNull,
      );
    }
    if (PathUtil.isAudio(widget.file.name, type: widget.file.type)) {
      return FileAudioPreview(
        file: widget.file,
        files: ref.read(fileProvider(widget.file.path)).valueOrNull,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.file.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () async {
              final result = await showFileAction(
                context,
                widget.file,
                ref: ref,
              );
              if (!context.mounted) return;
              result?.action(context, widget.file, ref: ref);
            },
          ),
        ],
      ),
      body: _buildFile(widget.file),
    );
  }

  _buildFile(File file) {
    final remotePath = filepath.posix.join(file.path, file.name);

    if (PathUtil.isText(file.name, type: file.type)) {
      return TextPreview(source: PreviewSource.remote(remotePath));
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Icon(
                PathUtil.icon(file.name, type: file.type),
                size: 64,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                file.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                "文件大小: {size}".tr(args: {
                  "size": Util.formatSize(file.size),
                }),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  child: Text('下载'.tr()),
                  onPressed: () async {
                    await FileAction.download.action(context, file, ref: ref);
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "未知的文件类型，无法查看文件，请下载到本地查看".tr(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class FileImagePreview extends FilePreviewBase {
  const FileImagePreview({super.key, required super.file, super.files});

  @override
  ConsumerState<FileImagePreview> createState() => _FileImagePreviewState();
}

class _FileImagePreviewState extends FilePreviewBaseState<FileImagePreview> {
  @override
  bool filter(File file) {
    return PathUtil.isImage(file.name, type: file.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          _file.name,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () async {
              final result = await showFileAction(
                context,
                _file,
                ref: ref,
              );
              if (!context.mounted) return;
              result?.action(context, _file, ref: ref);
            },
          ),
        ],
      ),
      body: ImageListPreview(
        index: _index,
        sources: _sources,
        onChanged: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}

class FileAudioPreview extends FilePreviewBase {
  const FileAudioPreview({super.key, required super.file, super.files});

  @override
  ConsumerState<FileAudioPreview> createState() => _FileAudioPreviewState();
}

class _FileAudioPreviewState extends FilePreviewBaseState<FileAudioPreview> {
  @override
  bool filter(File file) {
    return PathUtil.isAudio(file.name, type: file.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _file.name,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: AudioListPreview(
        sources: _sources,
        index: _index,
        autoPlay: true,
      ),
    );
  }
}

class FileVideoPreview extends FilePreviewBase {
  const FileVideoPreview({super.key, required super.file, super.files});

  @override
  ConsumerState<FileVideoPreview> createState() => _FileVideoPreviewState();
}

class _FileVideoPreviewState extends FilePreviewBaseState<FileVideoPreview> {
  @override
  bool filter(File file) {
    return PathUtil.isVideo(file.name, type: file.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _file.name,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: VideoListPreview(
        onChanged: (index) {
          setState(() {
            _index = index;
          });
        },
        autoPlay: true,
        index: _index,
        sources: _sources,
      ),
    );
  }
}
