import 'package:whatsapp/core/api/api_keys.dart';

class ErrorModel {
  final int code;
  final String message;

  ErrorModel({required this.code, required this.message});
  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    return ErrorModel(
      code: jsonData[ApiKeys.code],
      message: jsonData[ApiKeys.message],
    );
  }
}
