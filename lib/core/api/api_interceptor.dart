import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
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
    debugPrint("error: ApiInterceptor.onError()");
    debugPrint("status message: ${err.response?.statusMessage}");
    debugPrint("response data: ${err.response?.data}");

    if (err.response?.data is! Map) {
      return;
    }
    if (err.response?.data["message"] == "Unable to verify token") {
      try {
        debugPrint("error in ApiInterceptors: Unable to verify token");
        final refreshResponse = await dio.get(EndPoints.refreshToken);

        final newAccessToken = refreshResponse.data[ApiKeys.accessToken];
        await AppStorageHelper.setSecureData(
            StorageKeys.accessToken.toString(), newAccessToken);

        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newAccessToken';

        final clonedRequest = await dio.fetch(opts);
        return handler.resolve(clonedRequest);
      } catch (e) {
        debugPrint("error in get refresh token part: ${e.toString()}");
        await forcesUserLogOut(handler, err);
      }
    }

    if (err.response?.data['message'] == "No refreshToken found in cookie") {
      debugPrint("No refreshToken found in cookie");
      debugPrint(
          "there is an except in the refresh token now, there is a problem");
      await forcesUserLogOut(handler, err);
    }
    return handler.next(err);
  }

  forcesUserLogOut(ErrorInterceptorHandler handler, DioException err) async {
    await AppStorageHelper.deleteSecureData(StorageKeys.accessToken.toString());

    await AppStorageHelper.setBool(StorageKeys.isLoggedIn.toString(), false);

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
