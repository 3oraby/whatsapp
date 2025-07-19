import 'dart:developer';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:whatsapp/core/api/api_consumer.dart';
import 'package:whatsapp/core/api/api_interceptor.dart';
import 'package:whatsapp/core/api/api_urls.dart';
// import 'package:whatsapp/core/api/end_points.dart';
import 'package:whatsapp/core/errors/handle_dio_exceptions.dart';
import 'package:whatsapp/core/services/convert_data_to_form_data.dart';
import 'package:whatsapp/core/services/get_it_service.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    log("dio consumer");
    dio.options.baseUrl = ApiUrls.baseUrl;

    dio.interceptors.add(CookieManager(getIt<CookieJar>()));
    dio.interceptors.add(ApiInterceptor(dio: dio));
    dio.interceptors.add(LogInterceptor(
      request: true,
      error: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
    ));
  }

  @override
  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: isFromData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  @override
  Future get(String path,
      {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  @override
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: isFromData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
    }
  }

  @override
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFromData = false,
  }) async {
    try {
      FormData? formData;
      if (isFromData) {
        formData = await convertDataToFormData(data);
      }

      final response = await dio.post(
        path,
        data: isFromData ? formData : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      log("handle dio exceptions");
      handleDioExceptions(e);
    }
  }
}
