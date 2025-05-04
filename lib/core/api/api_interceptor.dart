import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:whatsapp/core/api/api_keys.dart';
import 'package:whatsapp/core/api/end_points.dart';
import 'package:whatsapp/core/constants/storage_keys.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';

class ApiInterceptor extends Interceptor {
  final Dio dio;

  ApiInterceptor({required this.dio});
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['Accept-language'] = "en";
    options.extra['withCredentials'] = true;

    final token = await AppStorageHelper.getSecureData(
      StorageKeys.accessToken.toString(),
    );

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    log("error: ApiInterceptor.onError()");
    log("status message: ${err.response?.statusMessage}");
    log("response data: ${err.response?.data}");

    if (err.response?.data["message"] == "Unable to verify token") {
      try {
        log("error in ApiInterceptors: Unable to verify token");
        final refreshResponse = await dio.get(EndPoints.refreshToken);

        final newAccessToken = refreshResponse.data[ApiKeys.accessToken];
        await AppStorageHelper.setSecureData(
            StorageKeys.accessToken.toString(), newAccessToken);

        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newAccessToken';

        final clonedRequest = await dio.fetch(opts);
        return handler.resolve(clonedRequest);
      } catch (e) {
        log("error in get refresh token part: ${e.toString()}");
        await AppStorageHelper.deleteSecureData(
            StorageKeys.accessToken.toString());

        await AppStorageHelper.setBool(
            StorageKeys.isLoggedIn.toString(), false);

        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: UnAuthorizedException(),
            type: DioExceptionType.unknown,
            response: err.response,
          ),
        );
      }
    }

    return handler.next(err);
  }
}
