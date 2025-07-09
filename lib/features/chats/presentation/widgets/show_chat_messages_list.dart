import 'package:flutter/material.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/presentation/widgets/bubble_message_item.dart';
import 'package:whatsapp/features/chats/presentation/widgets/show_message_options_menu.dart';
import 'package:whatsapp/features/chats/presentation/widgets/swipe_to_reply_message_item.dart';

class ShowChatMessagesList extends StatelessWidget {
  const ShowChatMessagesList({
    super.key,
    required ScrollController scrollController,
    required this.messages,
    this.onReplyRequested,
    this.isTyping = false,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<MessageEntity> messages;
  final void Function(MessageEntity message)? onReplyRequested;
  final bool isTyping;

  @override
  Widget build(BuildContext context) {
    final totalItemCount = messages.length + (isTyping ? 1 : 0);

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      itemCount: totalItemCount,
      separatorBuilder: (context, index) => const VerticalGap(8),
      itemBuilder: (context, index) {
        if (isTyping && index == totalItemCount - 1) {
          return const BubbleMessageItem(
            isFromMe: false,
            isTyping: true,
          );
        }

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

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onLongPress: () {
            showMessageOptionsMenu(context, msg);
          },
          child: SwipeToReplyMessageItem(
            msg: msg,
            isFromMe: isFromMe,
            showClipper: isLastFromSameSender,
            onReply: (msg) => onReplyRequested?.call(msg),
            repliedMsg: repliedMsg,
          ),
        );
      },
    );
  }
}
