import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/presentation/cubits/get_user_chats_cubit/get_user_chats_cubit.dart';

class ChatScreenArgs {
  final GetUserChatsCubit getUserChatsCubit;
  final ChatEntity chat;

  ChatScreenArgs({
    required this.getUserChatsCubit,
    required this.chat,
  });
}
