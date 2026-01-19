import 'package:grpc/grpc_web.dart';

import 'stub.dart';

export 'stub.dart';

class GrpcService {
  Future<GrpcResult> start() async {
    return GrpcResult(
      host: "127.0.0.1",
      port: 8000,
      client: GrpcWebClientChannel.xhr(Uri.parse('http://127.0.0.1:8000')),
    );
  }

  Future<void> stop() async {}

  Future<GrpcResult> restart() async {
    await stop();
    return await start();
  }
}