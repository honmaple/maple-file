import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as filepath;
import 'package:audioplayers/audioplayers.dart';

import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/common/widgets/audio.dart';

import 'source.dart';

class AudioPreview extends StatefulWidget {
  final String source;
  final SourceType sourceType;

  const AudioPreview({
    super.key,
    required this.source,
    required this.sourceType,
  });

  AudioPreview.file(
    File file, {
    super.key,
  })  : source = file.path,
        sourceType = SourceType.file;

  const AudioPreview.asset(
    String path, {
    super.key,
  })  : source = path,
        sourceType = SourceType.asset;

  const AudioPreview.network(
    String url, {
    super.key,
  })  : source = url,
        sourceType = SourceType.network;

  const AudioPreview.local(
    String path, {
    super.key,
  })  : source = path,
        sourceType = SourceType.file;

  AudioPreview.remote(
    String path, {
    super.key,
  })  : source = "http://${GRPC().addr}/api/file/preview/blob?path=$path",
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
    return Card(
      child: Column(
        children: [
          ListTile(
            dense: true,
            title: Text(
              filepath.basename(widget.source),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: const Text(
              "描述信息",
              // Util.datetimeToString(file.lastModifiedSync()),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey),
            ),
            trailing: CircleAvatar(
              child: (_playerState == PlayerState.stopped ||
                      _playerState == PlayerState.paused)
                  ? IconButton(
                      icon: const Icon(Icons.play_arrow),
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
                    )
                  : IconButton(
                      icon: const Icon(Icons.pause),
                      onPressed: () async {
                        await _player.pause();
                        setState(() {
                          _playerState = PlayerState.paused;
                        });
                      },
                    ),
            ),
          ),
          if (_player.state != PlayerState.stopped)
            AudioPlayerWidget(
              player: _player,
              onComplete: () {
                setState(() {
                  _playerState = PlayerState.stopped;
                });
              },
            ),
        ],
      ),
    );
  }
}
