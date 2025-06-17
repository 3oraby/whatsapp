import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';

abstract class ChatsRepo {
  Future<Either<Failure, List<ChatEntity>>> getUserChats();
}
