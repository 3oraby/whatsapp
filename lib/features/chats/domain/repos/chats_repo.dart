import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

abstract class ChatsRepo {
  Future<Either<Failure, ChatEntity>> createNewChat({
    String type = "chat",
    required UserEntity anotherUser,
  });

  Future<Either<Failure, List<ChatEntity>>> getUserChats();

  Future<Either<Failure, List<MessageEntity>>> getChatMessages({
    required int chatId,
  });

  Future<Either<Failure, String>> uploadChatImage({
    required File image,
  });
}
