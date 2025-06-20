import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/api/api_consumer.dart';
import 'package:whatsapp/core/api/end_points.dart';
import 'package:whatsapp/core/errors/exceptions.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/features/chats/data/models/chat_model.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/domain/repos/chats_repo.dart';

class ChatsRepoImpl extends ChatsRepo {
  final ApiConsumer apiConsumer;

  ChatsRepoImpl({required this.apiConsumer});

  @override
  Future<Either<Failure, List<ChatEntity>>> getUserChats() async {
    try {
      final result = await apiConsumer.get(EndPoints.getUserChats);

      final List<ChatEntity> chats = (result as List)
          .map((json) => ChatModel.fromJson(json).toEntity())
          .toList();

      return Right(chats);
    } on UnAuthorizedException {
      log("UnAuthorized in getUserChats");
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException {
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    } catch (e) {
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }
}
