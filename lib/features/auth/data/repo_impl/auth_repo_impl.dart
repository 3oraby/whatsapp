import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/api/api_consumer.dart';
import 'package:whatsapp/core/api/api_keys.dart';
import 'package:whatsapp/core/api/end_points.dart';
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
          ApiKeys.accessToken, result[ApiKeys.accessToken]);

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
}
