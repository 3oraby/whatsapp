import 'package:flutter/material.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
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
      separatorBuilder: (context, index) => const VerticalGap(16),
      itemBuilder: (context, index) {
        return CustomChatItem(chat: chats[index]);
      },
    );
  }
}
