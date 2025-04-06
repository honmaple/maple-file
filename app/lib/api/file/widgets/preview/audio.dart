import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:path/path.dart' as filepath;
import 'package:audioplayers/audioplayers.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/dialog.dart';

import 'source.dart';

class AudioPreviewController extends ChangeNotifier {
  final AudioPlayer _player;
  final List<PreviewSource> _playlist;

  int _index = 0;
  PreviewLoopMode _loopMode;

  AudioPreviewController(
    List<PreviewSource> playlist, {
    int index = 0,
    PreviewLoopMode loopMode = PreviewLoopMode.list,
    bool autoPlay = false,
  })  : assert(playlist.isNotEmpty, "playlist is empty"),
        assert(index < playlist.length && index >= 0, "playlist index error"),
        _index = index,
        _loopMode = loopMode,
        _player = AudioPlayer(),
        _playlist = playlist {
    if (autoPlay) {
      play(currentSource);
    }
  }

  AudioPlayer get player {
    return _player;
  }

  List<PreviewSource> get playlist {
    return _playlist;
  }

  PreviewLoopMode get currentLoopMode {
    return _loopMode;
  }

  PlayerState get currentState {
    return _player.state;
  }

  PreviewSource get currentSource {
    return _playlist[_index];
  }

  Source get _source {
    final s = _playlist[_index];
    switch (s.sourceType) {
      case SourceType.file:
        return DeviceFileSource(s.source);
      case SourceType.asset:
        return AssetSource(s.source);
      case SourceType.network:
        return UrlSource(s.source);
    }
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

    _player.play(_source);

    notifyListeners();
  }

  void next() {
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

    _player.play(_source);

    notifyListeners();
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
    notifyListeners();

    await _player.play(_source);
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.resume();
  }

  Future<void> toggle() async {
    switch (_player.state) {
      case PlayerState.playing:
        await _player.pause();
        break;
      case PlayerState.paused:
        await _player.resume();
        break;
      case PlayerState.stopped:
        await _player.play(_source);
        break;
      case PlayerState.completed:
        await _player.play(_source);
        break;
      case PlayerState.disposed:
    }
    notifyListeners();
  }

  void setSource(PreviewSource s) {
    switch (s.sourceType) {
      case SourceType.file:
        _player.setSource(DeviceFileSource(s.source));
      case SourceType.asset:
        _player.setSource(AssetSource(s.source));
      case SourceType.network:
        _player.setSource(UrlSource(s.source));
    }

    notifyListeners();
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
    _player.dispose();

    super.dispose();
  }
}

class AudioPreview extends StatefulWidget {
  final AudioPreviewController controller;

  const AudioPreview({
    super.key,
    required this.controller,
  });

  @override
  State<AudioPreview> createState() => _AudioPreviewState();
}

class _AudioPreviewState extends State<AudioPreview> {
  AudioPreviewController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {});
    });
    _controller.player.onPlayerComplete.listen((event) {
      _controller.next();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.music_note,
                  size: 81, color: Theme.of(context).primaryColor),
              Text(filepath
                  .basenameWithoutExtension(_controller.currentSource.name)),
            ],
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AudioPreviewSliver(
                player: _controller.player,
              ),
              buildControlButton(context),
              const SizedBox(height: 32),
            ],
          ),
        ],
      ),
    );
  }

  buildControlButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            _controller.toggleLoopMode();
          },
          iconSize: 32,
          icon: _buildLoopModeIcon(),
        ),
        IconButton(
          onPressed: () {
            _controller.prev();
          },
          iconSize: 32,
          icon: const Icon(Icons.skip_previous),
        ),
        IconButton(
          onPressed: () {
            _controller.toggle();
          },
          iconSize: 42,
          icon: _buildPlayIcon(),
        ),
        IconButton(
          onPressed: () {
            _controller.next();
          },
          iconSize: 32,
          icon: const Icon(Icons.skip_next),
        ),
        IconButton(
          onPressed: () {
            showListDialog2(
              context,
              height: MediaQuery.sizeOf(context).height * 0.618,
              child: AudioPreviewPlaylist(controller: _controller),
            );
          },
          iconSize: 32,
          icon: const Icon(Icons.format_list_bulleted),
        ),
      ],
    );
  }

  Widget _buildPlayIcon() {
    if (_controller.currentState == PlayerState.stopped ||
        _controller.currentState == PlayerState.paused) {
      return const Icon(Icons.play_circle_outlined);
    }
    return const Icon(Icons.pause_circle_outlined);
  }

  Widget _buildLoopModeIcon() {
    switch (_controller.currentLoopMode) {
      case PreviewLoopMode.off:
        return const Icon(Icons.music_off);
      case PreviewLoopMode.one:
        return const Icon(Icons.repeat_one);
      case PreviewLoopMode.list:
        return const Icon(Icons.repeat);
      case PreviewLoopMode.random:
        return const Icon(Icons.shuffle);
    }
  }
}

class AudioPreviewPlaylist extends StatefulWidget {
  final AudioPreviewController controller;

  const AudioPreviewPlaylist({
    super.key,
    required this.controller,
  });

  @override
  State<StatefulWidget> createState() {
    return _AudioPreviewPlaylistState();
  }
}

class _AudioPreviewPlaylistState extends State<AudioPreviewPlaylist> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              "当前播放列表({length})".tr(args: {
                "length": widget.controller.playlist.length,
              }),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Divider(
            height: 0.1,
            color: Colors.grey[300],
          ),
          for (final source in widget.controller.playlist)
            _buildPlaylist(source)
        ],
      ),
    );
  }

  _buildPlaylist(PreviewSource source) {
    final selected = widget.controller.currentSource == source;
    return ListTile(
      title: Text(source.name),
      trailing: selected
          ? widget.controller.currentState == PlayerState.playing
              ? const Icon(Icons.pause_circle_outlined)
              : const Icon(Icons.play_circle_outlined)
          : const Icon(Icons.play_circle_outlined),
      selected: selected,
      onTap: () async {
        if (selected) {
          await widget.controller.toggle();
        } else {
          await widget.controller.play(source);
        }
        setState(() {});
      },
    );
  }
}

class AudioPreviewSliver extends StatefulWidget {
  final AudioPlayer player;

  const AudioPreviewSliver({
    required this.player,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _AudioPreviewSliverState();
  }
}

class _AudioPreviewSliverState extends State<AudioPreviewSliver> {
  AudioPlayer get _player => widget.player;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: _player.onPositionChanged,
      builder: (context, snapshot) {
        final position = snapshot.data;
        return StreamBuilder<Duration>(
          stream: _player.onDurationChanged,
          builder: (context, snapshot) {
            final duration = snapshot.data;
            return buildSlider(
              position ?? Duration.zero,
              duration ?? Duration.zero,
            );
          },
        );
      },
    );
  }

  buildSlider(Duration position, Duration duration) {
    final durationText = duration.toString().split('.').first;
    final positionText = position.toString().split('.').first;
    return ListTile(
      dense: true,
      title: SliderTheme(
        data: const SliderThemeData(
          trackShape: CustomSliderTrackShape(),
        ),
        child: Slider(
          onChanged: (value) {
            _player.seek(Duration(
              milliseconds: (value * duration.inMilliseconds).round(),
            ));
          },
          value: (position.inMilliseconds > 0 &&
                  position.inMilliseconds < duration.inMilliseconds)
              ? position.inMilliseconds / duration.inMilliseconds
              : 0.0,
        ),
      ),
      trailing: Text(
        '$positionText / $durationText',
        style: const TextStyle(fontSize: 12.0),
      ),
    );
  }
}

class CustomSliderTrackShape extends RoundedRectSliderTrackShape {
  const CustomSliderTrackShape();
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
