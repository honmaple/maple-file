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
            onPressed: () {
              showFileAction(context, widget.file, ref);
            },
          ),
        ],
      ),
      body: _buildFile(widget.file),
    );
  }

  _buildFile(File file) {
    final remotePath = filepath.join(file.path, file.name);

    if (PathUtil.isText(file.name, type: file.type)) {
      return TextPreview.remote(remotePath);
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
                "文件大小: {size}".tr(
                  context,
                  args: {"size": Util.formatSize(file.size)},
                ),
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
                  child: Text('下载'.tr(context)),
                  onPressed: () async {
                    await FileActionType.download.action(context, file, ref);
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "未知的文件类型，无法查看文件，请下载到本地查看".tr(context),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class FileImagePreview extends StatefulWidget {
  final File file;
  final List<File>? files;

  const FileImagePreview({super.key, required this.file, this.files});

  @override
  State<FileImagePreview> createState() => _FileImagePreviewState();
}

class _FileImagePreviewState extends State<FileImagePreview> {
  late final PageController _pageController;

  int _currentIndex = 0;
  List<File> _currentFiles = [];

  @override
  void initState() {
    super.initState();

    if (widget.files != null) {
      _currentFiles = widget.files!.where((file) {
        return PathUtil.isImage(file.name, type: file.type);
      }).toList();
    }

    if (_currentFiles.isEmpty) {
      _currentFiles = [widget.file];
    }

    final index = _currentFiles.indexWhere((file) =>
        file.type == widget.file.type && file.name == widget.file.name);
    if (index >= 0) {
      _currentIndex = index;
    }

    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.file.name),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text("${_currentIndex + 1}/${_currentFiles.length}"),
          ),
        ],
      ),
      body: PageView.builder(
        itemCount: _currentFiles.length,
        itemBuilder: (BuildContext context, int index) {
          final file = _currentFiles[index];
          return ImagePreview.remote(
            filepath.join(file.path, file.name),
            fit: BoxFit.fitWidth,
          );
        },
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      // extendBodyBehindAppBar: true,
    );
  }
}

class FileAudioPreview extends StatefulWidget {
  final File file;
  final List<File>? files;

  const FileAudioPreview({super.key, required this.file, this.files});

  @override
  State<FileAudioPreview> createState() => _FileAudioPreviewState();
}

class _FileAudioPreviewState extends State<FileAudioPreview>
    with SingleTickerProviderStateMixin {
  late final AudioPreviewController _controller;

  @override
  void initState() {
    super.initState();

    List<File> currentFiles = [];
    if (widget.files != null) {
      currentFiles = widget.files!.where((file) {
        return PathUtil.isAudio(file.name, type: file.type);
      }).toList();
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

    _controller = AudioPreviewController(
      currentFiles.map((file) {
        final remotePath = filepath.join(file.path, file.name);
        return PreviewSource.network(GRPC().previewURL(remotePath));
      }).toList(),
      index: index,
      autoPlay: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _controller.currentSource.name,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: AudioPreview(controller: _controller),
    );
  }
}

class FileVideoPreview extends StatefulWidget {
  final File file;
  final List<File>? files;

  const FileVideoPreview({super.key, required this.file, this.files});

  @override
  State<FileVideoPreview> createState() => _FileVideoPreviewState();
}

class _FileVideoPreviewState extends State<FileVideoPreview>
    with SingleTickerProviderStateMixin {
  late final VideoPreviewController _controller;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    List<File> currentFiles = [];
    if (widget.files != null) {
      currentFiles = widget.files!.where((file) {
        return PathUtil.isVideo(file.name, type: file.type);
      }).toList();
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

    _controller = VideoPreviewController(
      currentFiles.map((file) {
        final remotePath = filepath.join(file.path, file.name);
        return PreviewSource.network(GRPC().previewURL(remotePath));
      }).toList(),
      index: index,
      autoPlay: true,
    );

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _controller.currentSource.name,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          VideoPreview(controller: _controller),
          TabBar(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            controller: _tabController,
            tabs: <Tab>[
              Tab(text: "简介".tr(context)),
              Tab(text: "播放列表".tr(context)),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TabBarView(
                controller: _tabController,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text("文件名称".tr(context)),
                        trailing: Text(_controller.currentSource.name),
                      ),
                    ],
                  ),
                  ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0.1,
                        color: Colors.grey[300],
                      );
                    },
                    itemCount: _controller.playlist.length,
                    itemBuilder: (context, index) {
                      final source = _controller.playlist[index];
                      final selected = _controller.currentSource == source;
                      return ListTile(
                        leading: Icon(selected
                            ? Icons.pause_circle_outlined
                            : Icons.play_circle_outlined),
                        title: Text(
                          source.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        selected: selected,
                        onTap: () {
                          _controller.play(source);
                          setState(() {});
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
