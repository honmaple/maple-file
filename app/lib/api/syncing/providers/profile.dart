import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

class SyncProfilesNotifier extends AsyncNotifier<List<SyncProfile>> {
  @override
  FutureOr<List<SyncProfile>> build() => SyncingService.instance.listProfiles();
}

final syncProfilesProvider =
    AsyncNotifierProvider<SyncProfilesNotifier, List<SyncProfile>>(
  SyncProfilesNotifier.new,
);
