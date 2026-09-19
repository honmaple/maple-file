import 'dart:math';

import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/common/providers/pagination.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';
import 'package:maple_file/generated/proto/google/protobuf/timestamp.pb.dart';

class SyncHistoryStore {
  static Future<List<SyncHistory>> load(
    int profileId, {
    int beforeId = 0,
  }) {
    return SyncingService.instance.listHistories(
      SyncHistory_ListRequest(
        profileId: profileId,
        beforeId: fixnum.Int64(beforeId),
      ),
    );
  }

  static Future<String> start(
    int profileId,
    DateTime startedAt, {
    SyncHistory_Trigger trigger = SyncHistory_Trigger.TRIGGER_MANUAL,
  }) async {
    final runId =
        '${startedAt.microsecondsSinceEpoch}-${Random.secure().nextInt(1 << 32)}';
    await SyncingService.instance.startHistory(
      SyncHistory(
        profileId: profileId,
        runId: runId,
        startedAt: Timestamp.fromDateTime(startedAt),
        trigger: trigger,
      ),
    );
    return runId;
  }

  static Future<SyncHistory> finish(SyncHistory history) {
    return SyncingService.instance.finishHistory(history);
  }
}

class SyncHistoriesNotifier extends FamilyAsyncNotifier<List<SyncHistory>, int>
    with PaginationNotifierMixin<SyncHistory> {
  @override
  Future<List<SyncHistory>> build(int arg) => SyncHistoryStore.load(arg);

  @override
  Future<List<SyncHistory>> fetch(int page) async {
    final histories = await future;
    if (histories.isEmpty) return [];
    return SyncHistoryStore.load(
      arg,
      beforeId: histories.last.id.toInt(),
    );
  }
}

final syncHistoriesProvider =
    AsyncNotifierProvider.family<SyncHistoriesNotifier, List<SyncHistory>, int>(
  SyncHistoriesNotifier.new,
);
