import 'dart:developer';

import 'package:whatsapp/core/api/api_keys.dart';

class ErrorModel {
  final int code;
  final String message;

  ErrorModel({
    required this.code,
    required this.message,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    log(jsonData.toString());
    return ErrorModel(
      code: int.parse((jsonData[ApiKeys.code] ?? "404").toString()),
      message: jsonData[ApiKeys.message] ?? "unknown error",
    );
  }
}
