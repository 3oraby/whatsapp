import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/api/api_consumer.dart';
import 'package:whatsapp/core/api/end_points.dart';
import 'package:whatsapp/core/errors/exceptions.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/features/chats/data/models/chat_model.dart';
import 'package:whatsapp/features/chats/data/models/message_model.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/repos/chats_repo.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

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
      log(e.toString());
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getChatMessages({
    required int chatId,
  }) async {
    try {
      final result = await apiConsumer.get(
        EndPoints.getChatMessages(chatId: chatId),
      );

      final List<MessageEntity> messages = (result['messages'] as List)
          .map((json) => MessageModel.fromJson(json).toEntity())
          .toList();

      return Right(messages);
    } on UnAuthorizedException {
      log("UnAuthorized in getUserChats");
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException {
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    } catch (e) {
      log("error in get chat messages: $e");
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> createNewChat({
    String type = "chat",
    required UserEntity anotherUser,
  }) async {
    try {
      final result = await apiConsumer.post(
        EndPoints.createChat,
        data: {
          "type": type,
          "userId": anotherUser.id.toString(),
        },
      );

      ChatEntity chat;
      if (result["message"] == "chat created successfully") {
        final chatId = result["chatId"];
        chat = ChatEntity.empty(
          chatId: chatId,
          anotherUser: anotherUser,
        );
      } else {
        chat = ChatModel.fromJson(result['data']).toEntity();
      }

      return Right(chat);
    } on UnAuthorizedException {
      log("UnAuthorized in getUserChats");
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException {
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    } catch (e) {
      log("error in get chat messages: $e");
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }

  @override
  Future<Either<Failure, String>> uploadChatImage({
    required File image,
  }) async {
    try {
      final result = await apiConsumer.post(
        EndPoints.uploadChatImage,
        isFromData: true,
        data: {
          "image": image,
        },
      );

      return Right(result['url']);
    } on UnAuthorizedException {
      log("UnAuthorized in uploadChatImage");
      return Left(UnAuthorizedException());
    } on ConnectionException catch (e) {
      return Left(CustomException(message: e.message));
    } on ServerException {
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    } catch (e) {
      log("error in get chat messages: $e");
      return Left(CustomException(
          message: "Something went wrong. Please try again later."));
    }
  }
}
