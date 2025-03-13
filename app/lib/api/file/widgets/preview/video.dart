import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import 'source.dart';

class VideoPreviewController extends ChangeNotifier {
  VideoPlayerController _controller;
  ChewieController? _chewieController;

  int _index = 0;
  PreviewRepeat _repeat;
  List<PreviewSource> _playlist;

  final bool _autoPlay;

  VideoPreviewController(
    List<PreviewSource> playlist, {
    PreviewRepeat? repeat,
    int index = 0,
    bool autoPlay = false,
  })  : assert(playlist.isNotEmpty, "playlist is empty"),
        assert(index < playlist.length && index >= 0, "playlist index error"),
        _index = index,
        _repeat = repeat ?? PreviewRepeat.list,
        _autoPlay = autoPlay,
        _playlist = playlist,
        _controller = _getController(playlist[index]);

  static VideoPlayerController _getController(PreviewSource s) {
    switch (s.sourceType) {
      case SourceType.file:
        return VideoPlayerController.file(File(s.source));
      case SourceType.asset:
        return VideoPlayerController.asset(s.source);
      case SourceType.network:
        return VideoPlayerController.networkUrl(Uri.parse(s.source));
    }
  }

  VideoPlayerController get player {
    return _controller;
  }

  ChewieController get chewie {
    _chewieController ??= ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 16 / 9,
      autoPlay: _autoPlay,
      looping: true,
      showOptions: false,
    );
    return _chewieController!;
  }

  List<PreviewSource> get playlist {
    return _playlist;
  }

  PreviewRepeat get currentRepeat {
    return _repeat;
  }

  PreviewSource get currentSource {
    return _playlist[_index];
  }

  int get _randomIndex {
    if (_playlist.length <= 1) {
      return 0;
    }
    int index = Random().nextInt(_playlist.length);
    if (index == _index) {
      index += 1;
    }
    if (index >= _playlist.length) {
      index = 0;
    }
    return index;
  }

  void prev() {
    switch (_repeat) {
      case PreviewRepeat.one:
      case PreviewRepeat.list:
        _index--;
        break;
      case PreviewRepeat.random:
        _index = _randomIndex;
        break;
    }

    if (_index < 0) {
      _index = _playlist.length - 1;
    }

    play(currentSource);
  }

  void next() {
    switch (_repeat) {
      case PreviewRepeat.one:
      case PreviewRepeat.list:
        _index++;
        break;
      case PreviewRepeat.random:
        _index = _randomIndex;
        break;
    }

    if (_index >= _playlist.length) {
      _index = 0;
    }

    play(currentSource);
  }

  Future<void> play(PreviewSource source) async {
    final index = _playlist.indexWhere((s) {
      return s.source == source.source && s.sourceType == source.sourceType;
    });
    if (index < 0) {
      _playlist.add(source);
      _index = _playlist.length - 1;
    } else {
      _index = index;
    }

    setSource(source);
    notifyListeners();
  }

  Future<void> pause() async {
    await _controller.pause();
  }

  Future<void> resume() async {
    await _controller.play();
  }

  void setSource(PreviewSource s) {
    _controller.pause();
    _controller.seekTo(const Duration(seconds: 0));
    _controller.dispose();
    _chewieController?.dispose();
    _chewieController = null;

    _controller = _getController(s);
  }

  void setRepeat(PreviewRepeat repeat) {
    _repeat = repeat;
    notifyListeners();
  }

  void toggleRepeat() {
    switch (_repeat) {
      case PreviewRepeat.one:
        setRepeat(PreviewRepeat.list);
        break;
      case PreviewRepeat.list:
        setRepeat(PreviewRepeat.random);
        break;
      case PreviewRepeat.random:
        setRepeat(PreviewRepeat.one);
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController?.dispose();

    super.dispose();
  }
}

class VideoPreview extends StatefulWidget {
  final VideoPreviewController controller;

  const VideoPreview({
    super.key,
    required this.controller,
  });

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late final VideoPreviewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller;
    _controller.addListener(() {
      setState(() {});
    });
    _controller.player.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Chewie(
        controller: _controller.chewie,
      ),
    );
  }
}
