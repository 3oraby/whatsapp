
import 'package:whatsapp/core/models/error_model.dart';

class ServerException implements Exception {
  final ErrorModel errModel;

  ServerException({required this.errModel});
}
