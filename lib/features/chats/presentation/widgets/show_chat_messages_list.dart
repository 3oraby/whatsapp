import 'package:flutter/material.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/presentation/widgets/custom_bubble_message_item.dart';
import 'package:whatsapp/features/user/domain/user_entity.dart';

class ShowChatMessagesList extends StatelessWidget {
  const ShowChatMessagesList({
    super.key,
    required ScrollController scrollController,
    required this.messages,
    required this.currentUser,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<MessageEntity> messages;
  final UserEntity currentUser;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      itemCount: messages.length,
      separatorBuilder: (context, index) => const VerticalGap(6),
      itemBuilder: (context, index) {
        final msg = messages[index];
        final isFromMe = msg.senderId == currentUser.id;
        final bool isLastFromSameSender = index == messages.length - 1 ||
            messages[index + 1].senderId != msg.senderId;

        return CustomBubbleMessageItem(
          isFromMe: isFromMe,
          msg: msg,
          showClipper: isLastFromSameSender,
        );
      },
    );
  }
}
