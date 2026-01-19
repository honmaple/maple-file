import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as filepath;

import 'package:maple_file/app/grpc.dart';

enum SourceType {
  file,
  asset,
  network,
}

enum PreviewLoopMode {
  off,
  one,
  list,
  random,
}

abstract class PreviewSourceImpl {
  String get name;
  String get path;
  SourceType get type;
}

class PreviewSource implements PreviewSourceImpl {
  final String _name;
  final String _path;
  final SourceType _type;

  PreviewSource({
    required String name,
    required String path,
    required SourceType type,
  })  : _name = name,
        _path = path,
        _type = type;

  PreviewSource.file(File file)
      : _name = filepath.basename(file.path),
        _path = file.path,
        _type = SourceType.file;

  PreviewSource.asset(String path)
      : _name = filepath.basename(path),
        _path = path,
        _type = SourceType.asset;

  PreviewSource.network(
    String url, {
    String? name,
  })  : _name = name ?? filepath.url.basename(url),
        _path = url,
        _type = SourceType.network;

  PreviewSource.local(String path)
      : _name = filepath.basename(path),
        _path = path,
        _type = SourceType.file;

  PreviewSource.remote(String path)
      : _name = filepath.posix.basename(path),
        _path = Grpc.instance.previewURL(path),
        _type = SourceType.network;

  @override
  String get name => _name;

  @override
  String get path => _path;

  @override
  SourceType get type => _type;

  PreviewSourceImpl prev() => this;
  PreviewSourceImpl next() => this;
}

class PreviewSourceList implements PreviewSourceImpl {
  late int index;
  late PreviewLoopMode loopMode;
  late List<PreviewSourceImpl> sources;

  PreviewSourceList(
    this.sources, {
    this.index = 0,
    this.loopMode = PreviewLoopMode.list,
  }) : assert(sources.isNotEmpty, "source list is empty");

  @override
  String get name => sources[index].name;

  @override
  String get path => sources[index].path;

  @override
  SourceType get type => sources[index].type;
}

class PreviewSourceListController extends ChangeNotifier {
  late int _index;
  late PreviewLoopMode _loopMode;
  late List<PreviewSourceImpl>? _sources;

  PreviewSourceListController({
    List<PreviewSourceImpl>? sources,
    int index = 0,
    PreviewLoopMode loopMode = PreviewLoopMode.list,
  })  : _index = index,
        _sources = sources,
        _loopMode = loopMode;

  int get _randomIndex {
    final length = _sources!.length;
    if (length <= 1) {
      return 0;
    }
    int randomIndex = Random().nextInt(length);
    if (randomIndex == _index) {
      randomIndex += 1;
    }
    if (randomIndex >= length) {
      randomIndex = 0;
    }
    return randomIndex;
  }

  PreviewSourceImpl? _prevSource() {
    if (_sources == null || _sources!.isEmpty) {
      return null;
    }

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
      _index = _sources!.length - 1;
    }
    return _sources![_index];
  }

  PreviewSourceImpl? _nextSource() {
    if (_sources == null || _sources!.isEmpty) {
      return null;
    }

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

    if (_index >= _sources!.length) {
      _index = 0;
    }
    return _sources![_index];
  }

  Future<void> prev() async {
    final s = _prevSource();
    if (s != null) {
      await setSource(s, autoPlay: true);
    }
  }

  Future<void> next() async {
    final s = _nextSource();
    if (s != null) {
      await setSource(s, autoPlay: true);
    }
  }

  setLoopMode(PreviewLoopMode mode) {
    _loopMode = mode;

    notifyListeners();
  }

  Future<void> setSources(
    List<PreviewSourceImpl> sources, {
    int index = 0,
    bool autoPlay = false,
    PreviewLoopMode loopMode = PreviewLoopMode.list,
  }) {
    _index = index;
    _sources = sources;
    _loopMode = loopMode;

    return setSource(sources[index], autoPlay: autoPlay);
  }

  Future<void> setSource(PreviewSourceImpl s, {bool autoPlay = false}) async {}

  List<PreviewSourceImpl>? get sources => _sources;
  PreviewLoopMode get loopMode => _loopMode;
}
