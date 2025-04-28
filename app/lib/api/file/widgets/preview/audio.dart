import 'dart:async';
import 'package:flutter/material.dart';

import 'package:path/path.dart' as filepath;
import 'package:audioplayers/audioplayers.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/dialog.dart';

import 'source.dart';

class AudioPreviewController extends PreviewSourceListController {
  final AudioPlayer _player;
  PreviewSourceImpl? _source;

  AudioPreviewController({
    PreviewSourceImpl? source,
    bool autoPlay = false,
  })  : _source = source,
        _player = AudioPlayer() {
    if (source != null) {
      setSource(source, autoPlay: autoPlay);
    }
  }

  AudioPlayer get player => _player;
  PreviewSourceImpl? get source => _source;

  Future<void> play() {
    return _player.resume();
  }

  Future<void> pause() {
    return _player.pause();
  }

  Future<void> resume() {
    return _player.resume();
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
      case PlayerState.completed:
        if (_source != null) {
          await setSource(_source!, autoPlay: true);
        }
        break;
      case PlayerState.disposed:
    }
    notifyListeners();
  }

  @override
  Future<void> setSource(PreviewSourceImpl s, {bool autoPlay = false}) async {
    _source = s;

    switch (s.type) {
      case SourceType.file:
        await _player.setSource(DeviceFileSource(s.path));
      case SourceType.asset:
        await _player.setSource(AssetSource(s.path));
      case SourceType.network:
        await _player.setSource(UrlSource(s.path));
    }
    if (autoPlay) {
      await _player.resume();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _player.release();
    _player.dispose();

    super.dispose();
  }
}

class AudioListPreview extends StatefulWidget {
  final int index;
  final bool autoPlay;
  final List<PreviewSourceImpl> sources;
  final Function(int)? onChanged;
  final AudioPreviewController? controller;

  const AudioListPreview({
    super.key,
    required this.sources,
    this.index = 0,
    this.autoPlay = false,
    this.controller,
    this.onChanged,
  });

  @override
  State<AudioListPreview> createState() => _AudioListPreviewState();
}

class _AudioListPreviewState extends State<AudioListPreview> {
  AudioPlayer get _player => _controller.player;

  late final AudioPreviewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? AudioPreviewController();
    _controller.setSources(
      widget.sources,
      index: widget.index,
      autoPlay: widget.autoPlay,
    );

    _controller.player.onPlayerComplete.listen((event) {
      _controller.next();
    });
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          if (_controller.source != null)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.music_note,
                    size: 81, color: Theme.of(context).primaryColor),
                Text(filepath
                    .basenameWithoutExtension(_controller.source!.name)),
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
            switch (_controller.loopMode) {
              case PreviewLoopMode.off:
                _controller.setLoopMode(PreviewLoopMode.one);
                break;
              case PreviewLoopMode.one:
                _controller.setLoopMode(PreviewLoopMode.list);
                break;
              case PreviewLoopMode.list:
                _controller.setLoopMode(PreviewLoopMode.random);
                break;
              case PreviewLoopMode.random:
                _controller.setLoopMode(PreviewLoopMode.off);
                break;
            }
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
              child: AudioPreviewPlaylist(
                sources: widget.sources,
                controller: _controller,
              ),
            );
          },
          iconSize: 32,
          icon: const Icon(Icons.format_list_bulleted),
        ),
      ],
    );
  }

  Widget _buildPlayIcon() {
    if (_player.state == PlayerState.stopped ||
        _player.state == PlayerState.paused) {
      return const Icon(Icons.play_circle_outlined);
    }
    return const Icon(Icons.pause_circle_outlined);
  }

  Widget _buildLoopModeIcon() {
    switch (_controller.loopMode) {
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
  final List<PreviewSourceImpl> sources;
  final AudioPreviewController controller;

  const AudioPreviewPlaylist({
    super.key,
    required this.sources,
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
                "length": widget.sources.length,
              }),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Divider(
            height: 0.1,
            color: Colors.grey[300],
          ),
          for (final (index, source) in widget.sources.indexed)
            _buildPlaylist(index, source)
        ],
      ),
    );
  }

  _buildPlaylist(int index, PreviewSourceImpl source) {
    final selected = (widget.controller.source == source);
    return ListTile(
      title: Text(source.name),
      trailing: selected
          ? widget.controller.player.state == PlayerState.playing
              ? const Icon(Icons.pause_circle_outlined)
              : const Icon(Icons.play_circle_outlined)
          : const Icon(Icons.play_circle_outlined),
      selected: selected,
      onTap: () async {
        if (selected) {
          await widget.controller.toggle();
        } else {
          await widget.controller.setSource(source, autoPlay: true);
        }
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
