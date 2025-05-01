import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/api/api_consumer.dart';
import 'package:whatsapp/core/api/end_points.dart';
import 'package:whatsapp/core/errors/exceptions.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/features/contacts/domain/entities/user_with_contact_status_entity.dart';
import 'package:whatsapp/features/contacts/domain/repos/contacts_repo.dart';
import 'package:whatsapp/features/user/data/models/user_model.dart';
import 'package:whatsapp/features/user/domain/user_entity.dart';

class ContactsRepoImpl extends ContactsRepo {
  final ApiConsumer apiConsumer;
  ContactsRepoImpl({required this.apiConsumer});

  @override
  Future<Either<Failure, List<UserWithContactStatusEntity>>> searchInUsers(
      {String? query}) async {
    try {
      final result = await apiConsumer.get(
        EndPoints.searchInUsers,
        queryParameters: {
          "t": query,
        },
      );

      log(result.toString());
      List<UserWithContactStatusEntity> users = [];
      for (int i = 0; i < result["users"].length; i++) {
        log(result["users"][i].toString());
        UserEntity user = UserModel.fromJson(result["users"][i]).toEntity();
        UserWithContactStatusEntity userWithContactStatusEntity =
            UserWithContactStatusEntity(
          user: user,
          isContact: result["users"][i]["is_contact"],
        );
        users.add(userWithContactStatusEntity);
      }
      return Right(users);
    } on UnAuthorizedException {
      log("throw unAuthorizedException in contacts repo");
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
