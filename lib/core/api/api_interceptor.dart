import 'package:dio/dio.dart';
import 'package:whatsapp/core/api/api_keys.dart';
import 'package:whatsapp/core/api/end_points.dart';
import 'package:whatsapp/core/constants/storage_keys.dart';
import 'package:whatsapp/core/errors/exceptions.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';

class ApiInterceptor extends Interceptor {
  final Dio dio;

  ApiInterceptor({required this.dio});
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['Accept-language'] = "en";
    final token =
        await AppStorageHelper.getSecureData(StorageKeys.accessToken.key);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    super.onError(err, handler);

    if (err.response?.statusMessage == "Unable to verify token") {
      try {
        final refreshResponse = await dio.post(EndPoints.refreshToken);

        final newAccessToken = refreshResponse.data[ApiKeys.accessToken];
        await AppStorageHelper.setSecureData(
            StorageKeys.accessToken.key, newAccessToken);

        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newAccessToken';

        final clonedRequest = await dio.fetch(opts);
        return handler.resolve(clonedRequest);
      } catch (e) {
        await AppStorageHelper.deleteSecureData(StorageKeys.accessToken.key);
        throw UnAuthorizedException();
      }
    }

    return handler.next(err);
  }
}
