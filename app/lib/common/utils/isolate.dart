import 'dart:core';
import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart' as foundation;

class _IsolateParam<M, R> {
  final M message;
  final SendPort sendPort;
  final Stream<R> Function(M message) callback;

  _IsolateParam(this.sendPort, this.callback, this.message);
}

class IsolateUtil {
  static Future<R> compute<M, R>(
      foundation.ComputeCallback<M, R> callback, M message,
      {String? debugLabel}) {
    return foundation.compute(callback, message, debugLabel: debugLabel);
  }

  /// 在隔离区中执行返回Stream的函数
  ///
  /// 类似于Flutter的compute函数，但支持返回Stream的函数
  ///
  /// [callback] 要在隔离区中执行的函数，必须返回Stream<R>
  /// [message] 传递给callback的参数
  /// [debugName] 隔离区的调试名称
  ///
  /// 返回一个Stream<R>，包含callback函数产生的所有值
  static Future<Stream<R>> streamCompute<M, R>(
    Stream<R> Function(M message) callback,
    M message, {
    String? debugName,
  }) async {
    final receivePort = ReceivePort();
    final streamController = StreamController<R>();
    final completer = Completer<void>();

    // 监听隔离区发送的消息
    receivePort.listen((data) {
      if (data is List) {
        // 错误处理
        if (data.length == 2) {
          final error = data[0];
          final stackTrace = data[1];
          if (stackTrace is StackTrace) {
            streamController.addError(error, stackTrace);
          } else {
            final remoteError = RemoteError(
              error.toString(),
              stackTrace.toString(),
            );
            streamController.addError(remoteError, remoteError.stackTrace);
          }
        } else if (data.length == 1 && data[0] == null) {
          // 完成信号
          streamController.close();
          completer.complete();
        }
      } else {
        // 正常数据
        streamController.add(data as R);
      }
    });

    try {
      // 启动隔离区
      await Isolate.spawn(
        (param) async {
          try {
            // 执行callback函数并处理返回的Stream
            await for (final result in param.callback(param.message)) {
              param.sendPort.send(result);
            }
            // 发送完成信号
            param.sendPort.send([null]);
          } catch (e, s) {
            // 发送错误
            param.sendPort.send([e, s]);
          }
        },
        _IsolateParam<M, R>(receivePort.sendPort, callback, message),
        onError: receivePort.sendPort,
        onExit: receivePort.sendPort,
        errorsAreFatal: true,
        debugName: debugName,
      );
    } catch (e, s) {
      receivePort.close();
      streamController.addError(e, s);
      completer.complete();
    }

    // 等待完成
    await completer.future;
    receivePort.close();

    return streamController.stream;
  }
}
