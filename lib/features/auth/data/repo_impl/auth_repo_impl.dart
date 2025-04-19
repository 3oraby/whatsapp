import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/api/api_consumer.dart';
import 'package:whatsapp/core/api/api_keys.dart';
import 'package:whatsapp/core/api/end_points.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/core/errors/exceptions.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';
import 'package:whatsapp/features/auth/domain/entities/user_entity.dart';
import 'package:whatsapp/features/auth/domain/repo_interface/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final ApiConsumer apiConsumer;
  AuthRepoImpl({required this.apiConsumer});

  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
      {required String email, required String password}) {
    throw UnimplementedError();
  }

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
}
