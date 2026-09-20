import 'package:grpc/grpc.dart';

import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pbgrpc.dart';

enum SyncSourceType {
  unknown(''),
  album('album'),
  localDirectory('local_directory');

  const SyncSourceType(this.value);

  final String value;

  String get label => switch (this) {
        SyncSourceType.unknown => '未知同步类型'.tr(),
        SyncSourceType.album => '相册备份'.tr(),
        SyncSourceType.localDirectory => '本地目录同步'.tr(),
      };

  bool get isSupported => switch (this) {
        SyncSourceType.unknown => false,
        SyncSourceType.album => !Util.isWeb && (Util.isAndroid || Util.isIOS),
        SyncSourceType.localDirectory =>
          !Util.isWeb && (Util.isAndroid || Util.isDesktop),
      };

  static bool get hasSupportedType => values.any((type) => type.isSupported);

  static SyncSourceType fromValue(String value) {
    for (final type in SyncSourceType.values) {
      if (type.value == value) return type;
    }
    return SyncSourceType.unknown;
  }
}

enum SyncTargetType {
  repoDirectory('repo_directory');

  const SyncTargetType(this.value);

  final String value;

  static SyncTargetType? fromValue(String value) {
    for (final type in SyncTargetType.values) {
      if (type.value == value) return type;
    }
    return null;
  }
}

/// Common persistence API shared by all sync and backup implementations.
class SyncingService {
  static SyncingService get instance => _instance;
  static final SyncingService _instance = SyncingService._internal();

  factory SyncingService() => _instance;

  SyncingService._internal();

  SyncServiceClient? _client;
  DateTime _clientTime = DateTime.now();

  SyncServiceClient get _syncClient {
    if (_client == null || Grpc.instance.connectTime.isAfter(_clientTime)) {
      _client = SyncServiceClient(
        Grpc.instance.client,
        options: CallOptions(metadata: Grpc.instance.metadata),
      );
      _clientTime = Grpc.instance.connectTime;
    }
    return _client!;
  }

  Future<List<SyncProfile>> listProfiles() => doFuture(() async {
        final response =
            await _syncClient.listProfiles(SyncProfile_ListRequest());
        return response.results;
      });

  Future<SyncProfile> createProfile(SyncProfile profile) => doFuture(() async {
        final response = await _syncClient.createProfile(
          SyncProfile_CreateRequest(payload: profile),
        );
        return response.result;
      });

  Future<SyncProfile> updateProfile(SyncProfile profile) => doFuture(() async {
        final response = await _syncClient.updateProfile(
          SyncProfile_UpdateRequest(payload: profile),
        );
        return response.result;
      });

  Future<void> deleteProfile(int id) => doFuture(() async {
        await _syncClient.deleteProfile(SyncProfile_DeleteRequest(id: id));
      });

  Future<List<SyncRecord>> listRecords(SyncRecord_ListRequest request) =>
      doFuture(() async {
        final response = await _syncClient.listRecords(request);
        return response.results;
      });

  Future<void> upsertRecords(Iterable<SyncRecord> records) =>
      doFuture(() async {
        await _syncClient.upsertRecords(
          SyncRecord_UpsertRequest(results: records),
        );
      });

  Future<List<SyncHistory>> listHistories(SyncHistory_ListRequest request) =>
      doFuture(() async {
        final response = await _syncClient.listHistories(request);
        return response.results;
      });

  Future<SyncHistory> createHistory(SyncHistory history) => doFuture(() async {
        final response = await _syncClient.createHistory(
          SyncHistory_CreateRequest(payload: history),
        );
        return response.result;
      });

  Future<SyncHistory> startHistory(SyncHistory history) => doFuture(() async {
        final response = await _syncClient.startHistory(
          SyncHistory_StartRequest(payload: history),
        );
        return response.result;
      });

  Future<SyncHistory> finishHistory(SyncHistory history) => doFuture(() async {
        final response = await _syncClient.finishHistory(
          SyncHistory_FinishRequest(payload: history),
        );
        return response.result;
      });

  Future<List<SyncHistoryIssue>> listHistoryIssues(
    SyncHistoryIssue_ListRequest request,
  ) =>
      doFuture(() async {
        final response = await _syncClient.listHistoryIssues(request);
        return response.results;
      });
}
