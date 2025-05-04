import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/api/api_consumer.dart';
import 'package:whatsapp/core/api/end_points.dart';
import 'package:whatsapp/core/errors/exceptions.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/features/contacts/domain/entities/user_with_contact_status_entity.dart';
import 'package:whatsapp/features/contacts/domain/repos/contacts_repo.dart';
import 'package:whatsapp/features/user/data/models/user_model.dart';

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

      log("searchInUsers result: $result");

      final users = (result["users"] as List).map((userJson) {
        final userEntity = UserModel.fromJson(userJson).toEntity();
        final isContact = (userJson["is_contact"] ?? -1) >= 0;
        return UserWithContactStatusEntity(
          user: userEntity,
          isContact: isContact,
        );
      }).toList();

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

  @override
  Future<Either<Failure, void>> createNewContact({required int userId}) async {
    try {
      await apiConsumer.post(
        "${EndPoints.createContact}/$userId",
      );

      return const Right(null);
    } on UnAuthorizedException {
      log("throw unAuthorizedException in contacts repo");
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException {
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }
}
