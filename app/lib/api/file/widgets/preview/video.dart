import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';

import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/util.dart';

import 'source.dart';

abstract class VideoPreviewController extends PreviewSourceListController {
  PreviewSourceImpl? get source;

  Future<void> play();
  Future<void> pause();
  Future<void> resume();
  // Future<void> setSource(PreviewSourceImpl s, {bool autoPlay = false});

  Widget playerWidget(BuildContext context);
}

class MobileVideoPreviewController extends VideoPreviewController {
  final FijkPlayer _player;

  PreviewSourceImpl? _source;

  MobileVideoPreviewController({
    PreviewSourceImpl? source,
    bool autoPlay = false,
  })  : _source = source,
        _player = FijkPlayer() {
    if (source != null) {
      setSource(source, autoPlay: autoPlay);
    }
  }

  FijkPlayer get player => _player;

  @override
  PreviewSourceImpl? get source => _source;

  @override
  Future<void> play() {
    return _player.start();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> resume() async {
    await _player.start();
  }

  @override
  Future<void> setSource(PreviewSourceImpl s, {bool autoPlay = false}) async {
    _source = s;

    await player.reset();

    switch (s.type) {
      case SourceType.file:
        return _player.setDataSource("file://${s.path}", autoPlay: autoPlay);
      case SourceType.asset:
        return _player.setDataSource("asset:///${s.path}", autoPlay: autoPlay);
      case SourceType.network:
        return _player.setDataSource(s.path, autoPlay: autoPlay);
    }
  }

  @override
  void dispose() {
    _player.release();
    // _player.dispose();
    super.dispose();
  }

  @override
  Widget playerWidget(BuildContext context) {
    return FijkView(
      fit: FijkFit.cover,
      player: _player,
    );
  }
}

class DesktopVideoPreviewController extends VideoPreviewController {
  late VideoPlayerController _controller;

  ChewieController? _chewieController;
  PreviewSourceImpl? _source;

  DesktopVideoPreviewController({
    PreviewSourceImpl? source,
    bool autoPlay = false,
  }) : _source = source {
    if (source != null) {
      _initController(source, autoPlay: autoPlay);
    }
  }

  ChewieController get chewie {
    _chewieController ??= ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 16 / 9,
      autoPlay: false,
      looping: true,
      showOptions: false,
    );
    return _chewieController!;
  }

  VideoPlayerController get player => _controller;

  @override
  PreviewSourceImpl? get source => _source;

  @override
  Future<void> play() async {
    return _controller.play();
  }

  @override
  Future<void> pause() {
    return _controller.pause();
  }

  @override
  Future<void> resume() {
    return _controller.play();
  }

  @override
  Future<void> setSource(PreviewSourceImpl s, {bool autoPlay = false}) async {
    _source = s;

    _controller.pause();
    _controller.seekTo(const Duration(seconds: 0));
    _controller.dispose();
    _chewieController?.dispose();
    _chewieController = null;

    await _initController(s, autoPlay: autoPlay);
  }

  Future<void> _initController(PreviewSourceImpl s,
      {bool autoPlay = false}) async {
    switch (s.type) {
      case SourceType.file:
        _controller = VideoPlayerController.file(File(s.path));
      case SourceType.asset:
        _controller = VideoPlayerController.asset(s.path);
      case SourceType.network:
        _controller = VideoPlayerController.networkUrl(Uri.parse(s.path));
    }
    if (autoPlay) {
      await _controller.initialize();
      await _controller.play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController?.dispose();

    super.dispose();
  }

  @override
  Widget playerWidget(BuildContext context) {
    return Chewie(
      controller: chewie,
    );
  }
}

class VideoPreview extends StatefulWidget {
  final bool autoPlay;
  final PreviewSourceImpl source;
  final VideoPreviewController? controller;

  const VideoPreview({
    super.key,
    required this.source,
    this.autoPlay = false,
    this.controller,
  });

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late final VideoPreviewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ??
        (Util.isDesktop
            ? DesktopVideoPreviewController()
            : MobileVideoPreviewController());
    _controller.setSource(widget.source, autoPlay: widget.autoPlay);

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _controller.playerWidget(context),
    );
  }
}

class VideoListPreview extends StatefulWidget {
  final int index;
  final bool autoPlay;
  final List<PreviewSourceImpl> sources;
  final VideoPreviewController? controller;
  final Function(int)? onChanged;

  const VideoListPreview({
    super.key,
    required this.sources,
    this.index = 0,
    this.autoPlay = false,
    this.controller,
    this.onChanged,
  });

  @override
  State<VideoListPreview> createState() => _VideoListPreviewState();
}

class _VideoListPreviewState extends State<VideoListPreview> {
  late final VideoPreviewController _controller;

  int _index = 0;

  @override
  void initState() {
    super.initState();

    _index = widget.index;

    _controller = widget.controller ??
        (Util.isDesktop
            ? DesktopVideoPreviewController()
            : MobileVideoPreviewController());
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final source = widget.sources[_index];
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: VideoPreview(
            source: source,
            autoPlay: widget.autoPlay,
            controller: _controller,
          ),
        ),
        SliverToBoxAdapter(
          child: ExpansionTile(
            initiallyExpanded: true,
            leading: Icon(Icons.playlist_play),
            title: Text("播放列表".tr()),
            children: [
              ...ListTile.divideTiles(
                context: context,
                tiles: [
                  for (final (index, source) in widget.sources.indexed)
                    buildListTile(context, index, source)
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildListTile(BuildContext context, int index, PreviewSourceImpl source) {
    final selected = (index == _index);
    return ListTile(
      leading: Icon(
          selected ? Icons.pause_circle_outlined : Icons.play_circle_outlined),
      title: Text(
        source.name,
        overflow: TextOverflow.ellipsis,
      ),
      selected: selected,
      onTap: () {
        _controller.setSource(source, autoPlay: true);
        setState(() {
          _index = index;
        });
        widget.onChanged?.call(index);
      },
    );
  }
}
