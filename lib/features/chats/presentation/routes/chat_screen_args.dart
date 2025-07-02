import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/presentation/cubits/message_stream_cubit/message_stream_cubit.dart';

class ChatScreenArgs {
  final ChatEntity chat;
  final MessageStreamCubit messageStreamCubit;

  ChatScreenArgs({
    required this.chat,
    required this.messageStreamCubit,
  });
}
