import 'dart:io';
import 'package:dio/dio.dart';

Future<FormData> convertDataToFormData(Map<String, dynamic> data) async {
  final Map<String, dynamic> newData = {};

  for (var entry in data.entries) {
    if (entry.value is File) {
      newData[entry.key] = await MultipartFile.fromFile(
        entry.value.path,
        filename: entry.value.path.split('/').last,
      );
    } else {
      newData[entry.key] = entry.value;
    }
  }

  return FormData.fromMap(newData);
}
