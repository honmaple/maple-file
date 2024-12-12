import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as filepath;
import 'package:audioplayers/audioplayers.dart';

import 'package:maple_file/app/grpc.dart';

import 'source.dart';

class AudioPreview extends StatefulWidget {
  final String name;
  final String source;
  final SourceType sourceType;

  const AudioPreview({
    super.key,
    required this.name,
    required this.source,
    required this.sourceType,
  });

  AudioPreview.file(
    File file, {
    super.key,
  })  : name = filepath.basename(file.path),
        source = file.path,
        sourceType = SourceType.file;

  AudioPreview.asset(
    String path, {
    super.key,
  })  : name = filepath.basename(path),
        source = path,
        sourceType = SourceType.asset;

  AudioPreview.network(
    String url, {
    String? name,
    super.key,
  })  : name = name ?? filepath.basename(url),
        source = url,
        sourceType = SourceType.network;

  AudioPreview.local(
    String path, {
    super.key,
  })  : name = filepath.basename(path),
        source = path,
        sourceType = SourceType.file;

  AudioPreview.remote(
    String path, {
    super.key,
  })  : name = filepath.basename(path),
        source = GRPC().previewURL(path),
        sourceType = SourceType.network;

  @override
  State<AudioPreview> createState() => _AudioPreviewState();
}

class _AudioPreviewState extends State<AudioPreview> {
  late final AudioPlayer _player;

  late PlayerState _playerState;

  Source get _source {
    switch (widget.sourceType) {
      case SourceType.file:
        return DeviceFileSource(widget.source);
      case SourceType.asset:
        return AssetSource(widget.source);
      case SourceType.network:
        return UrlSource(widget.source);
    }
  }

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();

    // _player.setReleaseMode(ReleaseMode.release);
    _playerState = PlayerState.stopped;
  }

  @override
  void dispose() {
    _player.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.music_note,
              size: 81, color: Theme.of(context).primaryColor),
          Text(filepath.basenameWithoutExtension(widget.name)),
          const SizedBox(height: 300),
          AudioPlayerSliver(
            player: _player,
            onComplete: () {
              setState(() {
                _playerState = PlayerState.stopped;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                iconSize: 32,
                icon: const Icon(Icons.repeat),
              ),
              IconButton(
                onPressed: () {},
                iconSize: 32,
                icon: const Icon(Icons.skip_previous),
              ),
              (_playerState == PlayerState.stopped ||
                      _playerState == PlayerState.paused)
                  ? IconButton(
                      onPressed: () async {
                        if (_playerState == PlayerState.stopped) {
                          await _player.play(_source);
                        } else {
                          await _player.resume();
                        }
                        setState(() {
                          _playerState = PlayerState.playing;
                        });
                      },
                      iconSize: 42,
                      icon: const Icon(Icons.play_circle_outline_rounded),
                    )
                  : IconButton(
                      onPressed: () async {
                        await _player.pause();
                        setState(() {
                          _playerState = PlayerState.paused;
                        });
                      },
                      iconSize: 42,
                      icon: const Icon(Icons.pause),
                    ),
              IconButton(
                onPressed: () {},
                iconSize: 32,
                icon: const Icon(Icons.skip_next),
              ),
              IconButton(
                onPressed: () {},
                iconSize: 32,
                icon: const Icon(Icons.format_list_bulleted),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class AudioPlayerSliver extends StatefulWidget {
  final AudioPlayer player;

  final Function()? onComplete;

  const AudioPlayerSliver({
    required this.player,
    this.onComplete,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _AudioPlayerSliverState();
  }
}

class _AudioPlayerSliverState extends State<AudioPlayerSliver> {
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
      widget.onComplete?.call();
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
