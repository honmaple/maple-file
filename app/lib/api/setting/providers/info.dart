import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maple_file/generated/proto/api/setting/info.pb.dart';

import 'service.dart';

class InfoNotifier extends AsyncNotifier<Info> {
  final _service = SystemService();

  @override
  FutureOr<Info> build() async {
    return await _service.info();
  }
}

final infoProvider = AsyncNotifierProvider<InfoNotifier, Info>(() {
  return InfoNotifier();
});
