import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import 'package:maple_file/app/grpc.dart';

import 'source.dart';

class VideoPreview extends StatefulWidget {
  final String source;
  final SourceType sourceType;

  const VideoPreview({
    super.key,
    required this.source,
    required this.sourceType,
  });

  VideoPreview.file(
    File file, {
    super.key,
  })  : source = file.path,
        sourceType = SourceType.file;

  const VideoPreview.asset(
    String path, {
    super.key,
  })  : source = path,
        sourceType = SourceType.asset;

  const VideoPreview.network(
    String url, {
    super.key,
  })  : source = url,
        sourceType = SourceType.network;

  const VideoPreview.local(
    String path, {
    super.key,
  })  : source = path,
        sourceType = SourceType.file;

  VideoPreview.remote(
    String path, {
    super.key,
  })  : source = GRPC().previewURL(path),
        sourceType = SourceType.network;

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    switch (widget.sourceType) {
      case SourceType.file:
        _videoPlayerController =
            VideoPlayerController.file(File(widget.source));
      case SourceType.asset:
        _videoPlayerController = VideoPlayerController.asset(widget.source);
      case SourceType.network:
        _videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(widget.source));
    }

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: FutureBuilder(
        future: _videoPlayerController.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }
            return Chewie(
              controller: _chewieController,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
