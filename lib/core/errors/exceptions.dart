import 'package:whatsapp/core/models/error_model.dart';

class Failure implements Exception {
  final ErrorModel? errModel;

  const Failure({this.errModel});
}

class ServerException extends Failure {
  ServerException({required super.errModel});
}

class UnAuthorizedException extends Failure {}
