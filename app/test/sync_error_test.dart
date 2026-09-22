import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:logging/logging.dart';

import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/app/app.dart';
import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

void main() {
  setUpAll(() {
    App.logger = Logger('sync-error-test');
  });

  test('doFuture keeps the display message and original exception', () async {
    const original = GrpcError.unavailable('offline');

    await expectLater(
      doFuture<void>(
        () => Future<void>.error(original),
        showError: false,
      ),
      throwsA(
        isA<FutureException>()
            .having((error) => error.message, 'message', 'offline')
            .having((error) => error.cause, 'cause', same(original)),
      ),
    );
  });

  test('sync error codes have unique values and fixed metadata', () {
    final values = SyncErrorCode.values.map((code) => code.value).toList();
    const runCodes = {
      SyncErrorCode.unsupportedPlatform,
      SyncErrorCode.sourcePermissionDenied,
      SyncErrorCode.sourceAuthorizationInvalid,
      SyncErrorCode.sourceAuthorizationMismatch,
      SyncErrorCode.sourceRootMissing,
      SyncErrorCode.sourceRootUnreadable,
      SyncErrorCode.targetConfigInvalid,
      SyncErrorCode.targetRepositoryUnavailable,
      SyncErrorCode.targetRepositoryDisabled,
      SyncErrorCode.targetRepositoryLocalUnsupported,
      SyncErrorCode.targetDirectoryInvalid,
      SyncErrorCode.targetNotDirectory,
      SyncErrorCode.targetAuthenticationFailed,
      SyncErrorCode.targetStorageFull,
      SyncErrorCode.recordReadFailed,
      SyncErrorCode.recordWriteFailed,
      SyncErrorCode.syncServiceUnavailable,
      SyncErrorCode.targetUnavailable,
      SyncErrorCode.targetTimeout,
      SyncErrorCode.targetAccessFailed,
    };
    const sourceCodes = {
      SyncErrorCode.sourceUnavailable,
      SyncErrorCode.sourceScanFailed,
    };
    const retryableCodes = {
      SyncErrorCode.syncServiceUnavailable,
      SyncErrorCode.targetUnavailable,
      SyncErrorCode.targetTimeout,
      SyncErrorCode.targetAccessFailed,
    };

    expect(values.toSet(), hasLength(values.length));
    expect(
      SyncErrorCode.values.where((code) => code.scope == SyncErrorScope.run),
      unorderedEquals(runCodes),
    );
    expect(
      SyncErrorCode.values.where((code) => code.scope == SyncErrorScope.source),
      unorderedEquals(sourceCodes),
    );
    expect(
      SyncErrorCode.values.where((code) => code.scope == SyncErrorScope.item),
      unorderedEquals(SyncErrorCode.values.toSet().difference({
        ...runCodes,
        ...sourceCodes,
      })),
    );
    expect(
      SyncErrorCode.values.where((code) => code.retryable),
      unorderedEquals(retryableCodes),
    );
    expect(SyncErrorCode.targetModified.conflict, isTrue);
  });

  test('classifier maps transport errors and preserves unknown failures', () {
    const wrappedCause = GrpcError.unavailable('raw offline');
    const wrapped = FutureException(
      message: '服务暂时不可用',
      cause: wrappedCause,
    );
    final wrappedUnavailable = SyncErrorClassifier.classify(
      wrapped,
      operation: SyncHistoryIssue_Operation.OPERATION_UPLOAD,
    );
    final authentication = SyncErrorClassifier.classify(
      const GrpcError.unauthenticated('expired'),
      fallbackCode: SyncErrorCode.uploadFailed,
      operation: SyncHistoryIssue_Operation.OPERATION_UPLOAD,
    );
    final unavailable = SyncErrorClassifier.classify(
      const GrpcError.unavailable('offline'),
      fallbackCode: SyncErrorCode.uploadFailed,
      operation: SyncHistoryIssue_Operation.OPERATION_UPLOAD,
    );
    final timeout = SyncErrorClassifier.classify(
      const GrpcError.deadlineExceeded('timeout'),
      fallbackCode: SyncErrorCode.uploadFailed,
      operation: SyncHistoryIssue_Operation.OPERATION_UPLOAD,
    );
    final socket = SyncErrorClassifier.classify(
      const SocketException('offline'),
      fallbackCode: SyncErrorCode.uploadFailed,
      operation: SyncHistoryIssue_Operation.OPERATION_UPLOAD,
    );
    final missingFile = SyncErrorClassifier.classify(
      const FileSystemException(
        'missing',
        '/tmp/missing',
        OSError('No such file', 2),
      ),
      fallbackCode: SyncErrorCode.internalItemError,
      operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
    );
    final unknown = SyncErrorClassifier.classify(
      StateError('unexpected'),
      operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
    );

    expect(wrappedUnavailable.code, SyncErrorCode.targetUnavailable);
    expect(wrappedUnavailable.message, '服务暂时不可用');
    expect(wrappedUnavailable.cause, same(wrappedCause));
    expect(authentication.code, SyncErrorCode.targetAuthenticationFailed);
    expect(unavailable.code, SyncErrorCode.targetUnavailable);
    expect(timeout.code, SyncErrorCode.targetTimeout);
    expect(socket.code, SyncErrorCode.targetUnavailable);
    expect(missingFile.code, SyncErrorCode.sourceMissing);
    expect(unknown.code, SyncErrorCode.internalItemError);
    expect(unknown.cause, isA<StateError>());
  });

  test('retryable operation succeeds on the third attempt', () async {
    var attempts = 0;

    final result = await SyncErrorClassifier.execute(
      action: () async {
        attempts++;
        if (attempts < 3) throw const GrpcError.unavailable('offline');
        return 'ok';
      },
      fallbackCode: SyncErrorCode.uploadFailed,
      operation: SyncHistoryIssue_Operation.OPERATION_UPLOAD,
      retryDelay: Duration.zero,
    );

    expect(result, 'ok');
    expect(attempts, 3);
  });

  test('retryable operation stops after three failures', () async {
    var attempts = 0;

    await expectLater(
      SyncErrorClassifier.execute<void>(
        action: () async {
          attempts++;
          throw const GrpcError.unavailable('offline');
        },
        fallbackCode: SyncErrorCode.uploadFailed,
        operation: SyncHistoryIssue_Operation.OPERATION_UPLOAD,
        retryDelay: Duration.zero,
      ),
      throwsA(
        isA<SyncException>().having(
          (error) => error.code,
          'code',
          SyncErrorCode.targetUnavailable,
        ),
      ),
    );
    expect(attempts, 3);
  });

  test('non-retryable operation stops after the first failure', () async {
    var attempts = 0;

    await expectLater(
      SyncErrorClassifier.execute<void>(
        action: () async {
          attempts++;
          throw const GrpcError.unauthenticated('expired');
        },
        fallbackCode: SyncErrorCode.uploadFailed,
        operation: SyncHistoryIssue_Operation.OPERATION_UPLOAD,
        retryDelay: Duration.zero,
      ),
      throwsA(isA<SyncException>()),
    );
    expect(attempts, 1);
  });

  test('run failure adds one anonymous issue without losing counters', () {
    final progress = SyncRunProgress()
      ..scanned = 5
      ..synced = 2
      ..skipped = 1;
    const failure = SyncException(
      code: SyncErrorCode.recordWriteFailed,
      operation: SyncHistoryIssue_Operation.OPERATION_UPLOAD,
      message: '记录写入失败',
    );

    progress.addRunFailure(failure);

    expect(progress.scanned, 5);
    expect(progress.synced, 2);
    expect(progress.skipped, 1);
    expect(progress.failed, 1);
    expect(progress.issues.single.errorCode, 'record_write_failed');
    expect(progress.issues.single.sourcePath, isEmpty);
    expect(progress.issues.single.sourceKey, isEmpty);
  });
}
