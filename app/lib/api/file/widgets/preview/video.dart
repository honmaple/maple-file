import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';

import 'source.dart';

class VideoPreviewController extends ChangeNotifier {
  final FijkPlayer _player;
  final List<PreviewSource> _playlist;

  int _index = 0;
  PreviewLoopMode _loopMode;

  VideoPreviewController(
    List<PreviewSource> playlist, {
    int index = 0,
    PreviewLoopMode loopMode = PreviewLoopMode.list,
    bool autoPlay = false,
  })  : assert(playlist.isNotEmpty, "playlist is empty"),
        assert(index < playlist.length && index >= 0, "playlist index error"),
        _index = index,
        _loopMode = loopMode,
        _player = FijkPlayer(),
        _playlist = playlist {
    if (autoPlay) {
      play(currentSource);
    }
  }

  FijkPlayer get player {
    return _player;
  }

  List<PreviewSource> get playlist {
    return _playlist;
  }

  PreviewLoopMode get currentLoopMode {
    return _loopMode;
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

  Future<void> prev() {
    switch (_loopMode) {
      case PreviewLoopMode.off:
      case PreviewLoopMode.one:
      case PreviewLoopMode.list:
        _index--;
        break;
      case PreviewLoopMode.random:
        _index = _randomIndex;
        break;
    }

    if (_index < 0) {
      _index = _playlist.length - 1;
    }

    return play(currentSource);
  }

  Future<void> next() {
    switch (_loopMode) {
      case PreviewLoopMode.off:
      case PreviewLoopMode.one:
      case PreviewLoopMode.list:
        _index++;
        break;
      case PreviewLoopMode.random:
        _index = _randomIndex;
        break;
    }

    if (_index >= _playlist.length) {
      _index = 0;
    }

    return play(currentSource);
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
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.start();
  }

  Future<void> setSource(PreviewSource s) async {
    await player.reset();

    switch (s.sourceType) {
      case SourceType.file:
        return _player.setDataSource("file://${s.source}", autoPlay: true);
      case SourceType.asset:
        return _player.setDataSource("asset:///${s.source}", autoPlay: true);
      case SourceType.network:
        return _player.setDataSource(s.source, autoPlay: true);
    }
  }

  void setLoopMode(PreviewLoopMode loopMode) {
    _loopMode = loopMode;
    notifyListeners();
  }

  void toggleLoopMode() {
    switch (_loopMode) {
      case PreviewLoopMode.off:
        setLoopMode(PreviewLoopMode.one);
        break;
      case PreviewLoopMode.one:
        setLoopMode(PreviewLoopMode.list);
        break;
      case PreviewLoopMode.list:
        setLoopMode(PreviewLoopMode.random);
        break;
      case PreviewLoopMode.random:
        setLoopMode(PreviewLoopMode.off);
        break;
    }
  }

  @override
  void dispose() {
    _player.release();
    // _player.dispose();
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
  VideoPreviewController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: FijkView(
        fit: FijkFit.cover,
        player: _controller.player,
      ),
    );
  }
}
