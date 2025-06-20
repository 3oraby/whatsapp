import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';

abstract class ChatsRepo {
  Future<Either<Failure, List<ChatEntity>>> getUserChats();

  Future<Either<Failure, List<MessageEntity>>> getChatMessages(
      {required int chatId});
}
