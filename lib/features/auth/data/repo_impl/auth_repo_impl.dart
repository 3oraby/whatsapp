import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:whatsapp/core/api/api_consumer.dart';
import 'package:whatsapp/core/api/api_keys.dart';
import 'package:whatsapp/core/api/end_points.dart';
import 'package:whatsapp/core/constants/storage_keys.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/core/errors/exceptions.dart';
import 'package:whatsapp/core/helpers/get_current_user_entity.dart';
import 'package:whatsapp/core/helpers/save_current_user_data_locally.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';
import 'package:whatsapp/features/auth/domain/repo_interface/auth_repo.dart';
import 'package:whatsapp/features/user/data/models/user_model.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class AuthRepoImpl extends AuthRepo {
  final ApiConsumer apiConsumer;
  AuthRepoImpl({required this.apiConsumer});

  @override
  Future<Either<Failure, void>> logOut() async {
    try {
      await AppStorageHelper.deleteSecureData(
          StorageKeys.accessToken.toString());

      await AppStorageHelper.setBool(StorageKeys.isLoggedIn.toString(), false);

      return Right(null);
    } catch (e) {
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
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

      debugPrint(result.toString());

      final accessToken = result[ApiKeys.accessToken];
      await AppStorageHelper.setSecureData(
          StorageKeys.accessToken.toString(), accessToken);

      debugPrint("access token is saved in secure data");
      await AppStorageHelper.setBool(StorageKeys.isLoggedIn.toString(), true);

      await getCurrentUser();
      return const Right(null);
    } on UnAuthorizedException {
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException catch (e) {
      if (e.errModel.message == "wrong credential") {
        return Left(CustomException(
            message: "Incorrect email or password. Please try again."));
      } else if (e.errModel.message == "user is not active") {
        return Left(CustomException(
            message: "user is not active. Please go and verify your email"));
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
      final result = await apiConsumer.post(
        EndPoints.verifyOTP,
        data: {
          ApiKeys.email: email,
          ApiKeys.otp: otp,
        },
      );
      final accessToken = result[ApiKeys.accessToken];
      await AppStorageHelper.setSecureData(
          StorageKeys.accessToken.toString(), accessToken);

      await AppStorageHelper.setBool(StorageKeys.isLoggedIn.toString(), true);

      await getCurrentUser();

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

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final result = await apiConsumer.get(
        EndPoints.getUser,
      );

      final UserEntity userEntity = UserModel.fromJson(result["data"]);

      await saveCurrentUserDataLocally(user: userEntity);

      return Right(userEntity);
    } on UnAuthorizedException {
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException catch (e) {
      if (e.errModel.message == "User not found!") {
        return Left(CustomException(
          message: "We couldn’t find an account with that information.",
        ));
      }
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }

  @override
  Future<Either<Failure, String>> uploadUserProfileImg({
    required File image,
  }) async {
    try {
      final result = await apiConsumer.post(
        EndPoints.uploadProfileImage,
        isFromData: true,
        data: {
          "image": image,
        },
      );

      final String mediaUrl = result["data"]["profile_image"];
      final UserEntity? currentUser = getCurrentUserEntity();

      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(profileImage: mediaUrl);
        await saveCurrentUserDataLocally(
          user: updatedUser,
        );
      }
      return Right(mediaUrl);
    } on UnAuthorizedException {
      log("UnAuthorized in uploadChatImage");
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException {
      log("message");
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    } catch (e) {
      log("error in uploadUserProfileImg: $e");
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUserProfileImg() async {
    try {
      await apiConsumer.delete(
        EndPoints.deleteProfileImage,
      );

      final UserEntity? currentUser = getCurrentUserEntity();

      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(profileImage: null);
        await saveCurrentUserDataLocally(
          user: updatedUser,
        );
      }
      return Right(null);
    } on UnAuthorizedException {
      log("UnAuthorized in uploadChatImage");
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException {
      log("message");
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    } catch (e) {
      log("error in deleteUserProfileImg: $e");
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }
}
