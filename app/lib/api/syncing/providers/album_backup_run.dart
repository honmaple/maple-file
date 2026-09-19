import 'dart:convert';
import 'dart:math';
import 'package:fixnum/fixnum.dart' as fixnum;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc/grpc.dart';

import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pbgrpc.dart';
import 'package:maple_file/generated/proto/google/protobuf/timestamp.pb.dart';

class AlbumBackupFailure {
  const AlbumBackupFailure(
      {required this.album,
      required this.item,
      required this.reason,
      this.sourceKey = '',
      this.itemKey = '',
      this.sourcePath = '',
      this.targetPath = '',
      this.operation = SyncHistoryIssue_Operation.OPERATION_UPLOAD,
      this.errorCode = ''});

  final String album;
  final String item;
  final String reason;
  final String sourceKey;
  final String itemKey;
  final String sourcePath;
  final String targetPath;
  final SyncHistoryIssue_Operation operation;
  final String errorCode;

  factory AlbumBackupFailure.fromHistory(SyncHistoryIssue issue) {
    Map<String, dynamic> context = const {};
    try {
      final value = jsonDecode(issue.context);
      if (value is Map<String, dynamic>) context = value;
    } catch (_) {}
    return AlbumBackupFailure(
      album: context['album_label'] as String? ?? '',
      item: issue.sourceKey.isEmpty ? '' : issue.sourceLabel,
      reason: issue.errorMessage,
      sourceKey: issue.sourcePath,
      itemKey: issue.sourceKey,
      sourcePath: context['local_path'] as String? ?? '',
      targetPath: issue.targetPath,
      operation: issue.errorOperation,
      errorCode: issue.errorCode,
    );
  }

  SyncHistoryIssue toHistory() {
    final context = <String, String>{
      if (album.isNotEmpty) 'album_label': album,
      if (sourcePath.isNotEmpty) 'local_path': sourcePath,
    };
    return SyncHistoryIssue(
      sourceLabel: item.isEmpty ? album : item,
      sourcePath: sourceKey,
      sourceKey: itemKey,
      targetPath: targetPath,
      errorOperation: operation,
      errorCode: errorCode,
      kind: SyncHistoryIssue_Kind.KIND_ERROR,
      errorMessage: reason,
      context: context.isEmpty ? '' : jsonEncode(context),
    );
  }
}

class AlbumBackupRun {
  const AlbumBackupRun(
      {required this.startedAt,
      required this.finishedAt,
      required this.uploaded,
      required this.skipped,
      this.scanned = 0,
      required this.failures,
      this.error,
      this.status = SyncHistory_Status.STATUS_UNSPECIFIED,
      this.historyId = 0});

  final DateTime startedAt;
  final DateTime finishedAt;
  final int uploaded;
  final int skipped;
  final int scanned;
  final List<AlbumBackupFailure> failures;
  final String? error;
  final SyncHistory_Status status;
  final int historyId;

  int get failed => failures.length + (error == null ? 0 : 1);
  bool get hasFailed => failed > 0;
  bool get isRunning => status == SyncHistory_Status.STATUS_RUNNING;
  bool get isInterrupted => status == SyncHistory_Status.STATUS_INTERRUPTED;

  factory AlbumBackupRun.fromHistory(SyncHistory history) => AlbumBackupRun(
        startedAt: history.startedAt.toDateTime(),
        finishedAt: history.hasFinishedAt()
            ? history.finishedAt.toDateTime()
            : history.startedAt.toDateTime(),
        uploaded: history.synced,
        skipped: history.skipped,
        scanned: history.scanned,
        failures: [
          for (final issue in history.issues)
            AlbumBackupFailure.fromHistory(issue)
        ],
        error: history.errorSummary.isEmpty ? null : history.errorSummary,
        status: history.status,
        historyId: history.id.toInt(),
      );

  SyncHistory toHistory(int profileId, String runId) => SyncHistory(
        profileId: profileId,
        runId: runId,
        startedAt: Timestamp.fromDateTime(startedAt),
        finishedAt: Timestamp.fromDateTime(finishedAt),
        status: error != null
            ? SyncHistory_Status.STATUS_FAILED
            : failures.isNotEmpty
                ? SyncHistory_Status.STATUS_PARTIAL
                : SyncHistory_Status.STATUS_SUCCEEDED,
        trigger: SyncHistory_Trigger.TRIGGER_MANUAL,
        scanned: scanned,
        synced: uploaded,
        skipped: skipped,
        failed: failed,
        errorSummary: error ?? '',
        issues: [for (final failure in failures) failure.toHistory()],
      );
}

class AlbumBackupRunStore {
  static SyncServiceClient get _client => SyncServiceClient(
        Grpc.instance.client,
        options: CallOptions(metadata: Grpc.instance.metadata),
      );

  static Future<List<AlbumBackupRun>> load(int profileId,
      {int beforeId = 0}) async {
    final response = await doFuture(() => _client.listHistories(
          SyncHistory_ListRequest(
              profileId: profileId, beforeId: fixnum.Int64(beforeId)),
        ));
    return [
      for (final history in response.results)
        AlbumBackupRun.fromHistory(history)
    ];
  }

  static Future<String> start(int profileId, DateTime startedAt) async {
    final runId =
        '${startedAt.microsecondsSinceEpoch}-${Random.secure().nextInt(1 << 32)}';
    await doFuture(() => _client.startHistory(SyncHistory_StartRequest(
          payload: SyncHistory(
            profileId: profileId,
            runId: runId,
            startedAt: Timestamp.fromDateTime(startedAt),
            trigger: SyncHistory_Trigger.TRIGGER_MANUAL,
          ),
        )));
    return runId;
  }

  static Future<void> finish(
      int profileId, String runId, AlbumBackupRun run) async {
    await doFuture(() => _client.finishHistory(SyncHistory_FinishRequest(
          payload: run.toHistory(profileId, runId),
        )));
  }
}

final albumBackupRunsProvider =
    FutureProvider.family<List<AlbumBackupRun>, int>((ref, profileId) {
  return AlbumBackupRunStore.load(profileId);
});
