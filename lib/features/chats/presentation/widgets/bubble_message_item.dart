import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/presentation/widgets/custom_message_content.dart';

class BubbleMessageItem extends StatelessWidget {
  const BubbleMessageItem({
    super.key,
    required this.isFromMe,
    required this.bgColor,
    required this.msg,
    this.repliedMsg,
  });

  final bool isFromMe;
  final Color bgColor;
  final MessageEntity msg;
  final MessageEntity? repliedMsg;

  @override
  Widget build(BuildContext context) {
    final bool isRepliedMessage = repliedMsg != null;
    return ChatBubble(
      clipper: isFromMe
          ? ChatBubbleClipper3(
              type: BubbleType.sendBubble,
              radius: AppConstants.messageBorderRadius,
            )
          : ChatBubbleClipper3(
              type: BubbleType.receiverBubble,
              radius: AppConstants.messageBorderRadius,
            ),
      alignment: isFromMe ? Alignment.topRight : Alignment.topLeft,
      padding: EdgeInsets.only(
        top: isRepliedMessage ? 4 : 6,
        bottom: 4,
        left: isRepliedMessage
            ? 4
            : msg.isFromMe
                ? 26
                : 33,
        right: isRepliedMessage
            ? 12
            : msg.isFromMe
                ? 16
                : 10,
      ),
      margin: EdgeInsets.all(0),
      backGroundColor: bgColor,
      child: CustomMessageContent(
        isFromMe: isFromMe,
        msg: msg,
        repliedMsg: repliedMsg,
      ),
    );
  }
}
