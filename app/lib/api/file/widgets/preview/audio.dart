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

  int _index = 0;
  PreviewRepeat _repeat;
  List<PreviewSource> _playlist;

  AudioPreviewController(
    List<PreviewSource> playlist, {
    PreviewRepeat? repeat,
    int index = 0,
    bool autoPlay = false,
  })  : assert(playlist.isNotEmpty, "playlist is empty"),
        assert(index < playlist.length && index >= 0, "playlist index error"),
        _index = index,
        _repeat = repeat ?? PreviewRepeat.list,
        _playlist = playlist,
        _player = AudioPlayer() {
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

  PreviewRepeat get currentRepeat {
    return _repeat;
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

    _player.play(_source);

    notifyListeners();
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
  late final AudioPreviewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      _controller.toggleRepeat();
                    },
                    iconSize: 32,
                    icon: _buildRepeatIcon(),
                  ),
                  IconButton(
                    onPressed: () {
                      _controller.prev();
                    },
                    iconSize: 32,
                    icon: const Icon(Icons.skip_previous),
                  ),
                  IconButton(
                    onPressed: () async {
                      await _controller.toggle();
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
              ),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayIcon() {
    if (_controller.currentState == PlayerState.stopped ||
        _controller.currentState == PlayerState.paused) {
      return const Icon(Icons.play_circle_outlined);
    }
    return const Icon(Icons.pause_circle_outlined);
  }

  Widget _buildRepeatIcon() {
    switch (_controller.currentRepeat) {
      case PreviewRepeat.one:
        return const Icon(Icons.repeat_one);
      case PreviewRepeat.list:
        return const Icon(Icons.repeat);
      case PreviewRepeat.random:
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
  Duration? _duration;
  Duration? _position;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;

  String get _durationText => _duration?.toString().split('.').first ?? '';

  String get _positionText => _position?.toString().split('.').first ?? '';

  AudioPlayer get player => widget.player;

  @override
  void initState() {
    super.initState();
    // Use initial values from player
    player.getDuration().then(
          (value) => setState(() {
            _duration = value;
          }),
        );
    player.getCurrentPosition().then(
          (value) => setState(() {
            _position = value;
          }),
        );
    _initStreams();
  }

  @override
  void setState(VoidCallback fn) {
    // Subscriptions only can be closed asynchronously,
    // therefore events can occur after widget has been disposed.
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: SliderTheme(
        data: const SliderThemeData(
          trackShape: CustomSliderTrackShape(),
        ),
        child: Slider(
          onChanged: (value) {
            final duration = _duration;
            if (duration == null) {
              return;
            }
            final position = value * duration.inMilliseconds;
            player.seek(Duration(milliseconds: position.round()));
          },
          value: (_position != null &&
                  _duration != null &&
                  _position!.inMilliseconds > 0 &&
                  _position!.inMilliseconds < _duration!.inMilliseconds)
              ? _position!.inMilliseconds / _duration!.inMilliseconds
              : 0.0,
        ),
      ),
      trailing: Text(
        _position != null
            ? '$_positionText / $_durationText'
            : _duration != null
                ? _durationText
                : '00:00',
        style: const TextStyle(fontSize: 12.0),
      ),
    );
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen(
      (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _position = Duration.zero;
      });
    });
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
