import 'package:whatsapp/core/models/error_model.dart';

class Failure implements Exception {
  final ErrorModel errModel;

  const Failure({required this.errModel});
}

class ServerException extends Failure {
  ServerException({required super.errModel});
}
