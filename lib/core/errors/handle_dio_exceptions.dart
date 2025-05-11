import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:whatsapp/core/errors/exceptions.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/core/models/error_model.dart';

void handleDioExceptions(DioException e) {
  log("handle dio exceptions, exception is: ${e.toString()}");
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw ServerException(errModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.sendTimeout:
      throw ServerException(errModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.receiveTimeout:
      throw ServerException(errModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.badCertificate:
      throw ServerException(errModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.cancel:
      throw ServerException(errModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.connectionError:
      throw ConnectionException();
    case DioExceptionType.unknown:
      // solve the issue here
      log("error in handle dio exception : unKnown");
      throw UnAuthorizedException();
    // throw ServerException(errModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400: // Bad request
          throw ServerException(
              errModel: ErrorModel.fromJson(e.response!.data));
        case 401: // unauthorized
          throw ServerException(
              errModel: ErrorModel.fromJson(e.response!.data));
        case 403: // forbidden
          throw ServerException(
              errModel: ErrorModel.fromJson(e.response!.data));
        case 404: // not found
          throw ServerException(
              errModel: ErrorModel.fromJson(e.response!.data));
        case 409: // coefficient
          throw ServerException(
              errModel: ErrorModel.fromJson(e.response!.data));
        case 422: // Unprocessable Entity
          throw ServerException(
              errModel: ErrorModel.fromJson(e.response!.data));
        case 504: // Server exception
          throw ServerException(
              errModel: ErrorModel.fromJson(e.response!.data));
      }
  }
}
