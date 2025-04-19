import 'package:whatsapp/core/models/error_model.dart';

class ServerException implements Exception {
  final ErrorModel errModel;

  const ServerException({required this.errModel});
}

class ConnectionException implements Exception {
  final String message;

  const ConnectionException({
    this.message =
        "No internet connection. Please check your connection and try again.",
  });
}
