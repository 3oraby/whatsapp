import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/api/api_consumer.dart';
import 'package:whatsapp/core/api/end_points.dart';
import 'package:whatsapp/core/errors/exceptions.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/features/user/data/models/user_current_status_model.dart';
import 'package:whatsapp/features/user/domain/entities/user_current_status_entity.dart';
import 'package:whatsapp/features/user/domain/repos/user_repo.dart';

class UserRepoImpl extends UserRepo {
  final ApiConsumer apiConsumer;

  UserRepoImpl({required this.apiConsumer});

  @override
  Future<Either<Failure, UserCurrentStatusEntity>> getUserCurrentStatus(
      {required int userId}) async {
    try {
      final result = await apiConsumer.get(
        EndPoints.getUserCurrentStatus(userId: userId),
      );

      final UserCurrentStatusEntity userCurrentStatusEntity =
          UserCurrentStatusModel.fromJson(result['data']).toEntity();
      return Right(userCurrentStatusEntity);
    } on UnAuthorizedException {
      log("throw unAuthorizedException in users repo");
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException {
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }
}
