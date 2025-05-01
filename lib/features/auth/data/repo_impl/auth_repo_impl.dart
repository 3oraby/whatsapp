import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/api/api_consumer.dart';
import 'package:whatsapp/core/api/api_keys.dart';
import 'package:whatsapp/core/api/end_points.dart';
import 'package:whatsapp/core/constants/storage_keys.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/core/errors/exceptions.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';
import 'package:whatsapp/features/auth/domain/repo_interface/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final ApiConsumer apiConsumer;
  AuthRepoImpl({required this.apiConsumer});

  @override
  Future<Either<Failure, void>> logOut() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await apiConsumer.post(
        EndPoints.login,
        data: {
          ApiKeys.email: email,
          ApiKeys.password: password,
        },
      );

      await AppStorageHelper.setSecureData(
          StorageKeys.accessToken.toString(), result[ApiKeys.accessToken]);

      log("access token is saved in secure data");
      await AppStorageHelper.setBool(StorageKeys.isLoggedIn.toString(), true);

      return const Right(null);
    } on UnAuthorizedException {
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException catch (e) {
      if (e.errModel.message == "wrong credential") {
        return Left(CustomException(
            message: "Incorrect email or password. Please try again."));
      }
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }

  @override
  Future<Either<Failure, void>> signUp(
      {required Map<String, dynamic> data}) async {
    try {
      await apiConsumer.post(
        EndPoints.signup,
        data: data,
      );

      await AppStorageHelper.setString(
          StorageKeys.userEmail.toString(), data[ApiKeys.email]);

      return const Right(null);
    } on UnAuthorizedException {
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException catch (e) {
      if (e.errModel.message == "user already found!") {
        return Left(CustomException(
            message: "An account with this email already exists."));
      } else if (e.errModel.message == "user with this number already found!") {
        return Left(CustomException(
            message:
                "This phone number is already linked to an existing account."));
      }
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      await apiConsumer.post(
        EndPoints.verifyOTP,
        data: {
          ApiKeys.email: email,
          ApiKeys.otp: otp,
        },
      );

      await AppStorageHelper.setBool(StorageKeys.isLoggedIn.toString(), true);

      return const Right(null);
    } on UnAuthorizedException {
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException catch (e) {
      if (e.errModel.message == "wrong otp!!") {
        return Left(CustomException(
            message: "The code you entered is incorrect. Please try again."));
      } else if (e.errModel.message == "user not found") {
        return Left(CustomException(
          message: "We couldn’t find an account with that information.",
        ));
      }
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }

  @override
  Future<Either<Failure, void>> resendOtp({
    required String email,
  }) async {
    try {
      await apiConsumer.post(
        EndPoints.resendOTP,
        data: {
          ApiKeys.email: email,
        },
      );

      return const Right(null);
    } on UnAuthorizedException {
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException catch (e) {
      if (e.errModel.message == "user not found") {
        return Left(CustomException(
          message: "We couldn’t find an account with that information.",
        ));
      } else if (e.errModel.message == "user already active") {
        return Left(CustomException(
          message:
              "Your account is already active. No further action is needed.",
        ));
      }
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }
}
