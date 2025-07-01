import 'package:flutter/material.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/presentation/widgets/swipe_to_reply_message_item.dart';

class ShowChatMessagesList extends StatelessWidget {
  const ShowChatMessagesList({
    super.key,
    required ScrollController scrollController,
    required this.messages,
    this.onReplyRequested,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<MessageEntity> messages;

  final void Function(MessageEntity message)? onReplyRequested;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      itemCount: messages.length,
      separatorBuilder: (context, index) => const VerticalGap(8),
      itemBuilder: (context, index) {
        final msg = messages[index];
        final isFromMe = msg.isFromMe;
        final bool isLastFromSameSender = index == messages.length - 1 ||
            messages[index + 1].senderId != msg.senderId;

        final bool isRepliedMessage = msg.parentId != null;
        MessageEntity? repliedMsg;
        if (isRepliedMessage) {
          repliedMsg = messages.firstWhere(
            (message) {
              return message.id == msg.parentId;
            },
          );
        }

        return SwipeToReplyMessageItem(
          msg: msg,
          isFromMe: isFromMe,
          showClipper: isLastFromSameSender,
          onReply: (msg) => onReplyRequested?.call(msg),
          repliedMsg: repliedMsg,
        );
      },
    );
  }
}
