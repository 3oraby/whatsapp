import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/chats/presentation/cubits/message_stream_cubit/message_stream_cubit.dart';
import 'package:whatsapp/features/chats/presentation/widgets/custom_chat_item.dart';

class ShowUserChatsList extends StatelessWidget {
  const ShowUserChatsList({
    super.key,
    required this.chats,
  });

  final List<ChatEntity> chats;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(0),
      itemCount: chats.length,
      separatorBuilder: (context, index) => const VerticalGap(6),
      itemBuilder: (context, index) {
        return BlocBuilder<MessageStreamCubit, MessageStreamState>(
          builder: (context, state) => CustomChatItem(
            chat: chats[index],
            isTyping:
                state is UserTypingState && state.chatId == chats[index].id,
          ),
        );
      },
    );
  }
}
