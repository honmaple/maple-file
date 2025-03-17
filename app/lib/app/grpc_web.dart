import 'package:grpc/service_api.dart' as grpcapi;
import 'package:grpc/grpc_web.dart';

class GrpcService {
  Future<void> start() async {
    _client = GrpcWebClientChannel.xhr(Uri.parse('http://127.0.0.1:8000'));
  }

  Future<void> stop() async {}

  Future<void> restart() async {
    await stop();
    await start();
  }

  String get addr {
    return "127.0.0.1:8000";
  }

  late grpcapi.ClientChannel _client;

  grpcapi.ClientChannel get client {
    return _client;
  }
}
