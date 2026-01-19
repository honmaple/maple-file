import 'package:grpc/service_api.dart' as grpcapi;
import 'package:grpc/grpc.dart';

class GrpcResult {
  GrpcResult({
    required this.host,
    this.port = 443,
    this.token = "",
    required this.client,
    DateTime? clientTime,
  }) : clientTime = clientTime ?? DateTime.now();

  final Object host;
  final int port;
  final String token;
  final grpcapi.ClientChannel client;
  final DateTime clientTime;

  String get addr => "$host:$port";

  factory GrpcResult.empty() {
    return GrpcResult(
      host: "127.0.0.1:8000",
      client: ClientChannel(
        "127.0.0.1",
        port: 8000,
        options: ChannelOptions(
          credentials: ChannelCredentials.insecure(),
        ),
      ),
    );
  }
}