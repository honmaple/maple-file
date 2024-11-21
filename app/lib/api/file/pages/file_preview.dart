import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path/path.dart' as filepath;

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';

import '../widgets/preview/text.dart';
import '../widgets/preview/video.dart';
import '../widgets/preview/image.dart';
import '../widgets/preview/audio.dart';

class FilePreview extends ConsumerStatefulWidget {
  final List<File> files;
  final File? currentFile;

  const FilePreview({super.key, this.currentFile, required this.files});

  factory FilePreview.fromRoute(ModalRoute? route) {
    final args = route?.settings.arguments as Map<String, dynamic>;
    return FilePreview(
      files: args["files"] as List<File>,
      currentFile: args["currentFile"],
    );
  }

  @override
  ConsumerState<FilePreview> createState() => _FilePreviewState();
}

class _FilePreviewState extends ConsumerState<FilePreview> {
  late PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();

    if (widget.currentFile == null) {
      currentIndex = 0;
    } else {
      final index = widget.files.indexWhere((file) =>
          file.type == widget.currentFile?.type &&
          file.name == widget.currentFile?.name);
      if (index >= 0) {
        currentIndex = index;
      }
    }
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("预览".tr(context)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text("${currentIndex + 1}/${widget.files.length}"),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: PageView.builder(
        itemCount: widget.files.length,
        itemBuilder: (BuildContext context, int index) {
          final file = widget.files[index];

          final mimeType = Util.mimeType(file.name);
          final remotePath = filepath.join(file.path, file.name);

          if (mimeType.startsWith("text/")) {
            return TextPreview.remote(remotePath);
          }
          if (mimeType.startsWith("image/")) {
            return ImagePreview.remote(remotePath, fit: BoxFit.fitWidth);
          }
          if (mimeType.startsWith("video/")) {
            return VideoPreview.remote(remotePath);
          }
          if (mimeType.startsWith("audio/")) {
            return AudioPreview.remote(remotePath);
          }
          return Center(
            child: Text(
              "未知的文件类型".tr(context),
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
