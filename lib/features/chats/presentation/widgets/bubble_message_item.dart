import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/presentation/widgets/custom_message_content.dart';

class BubbleMessageItem extends StatelessWidget {
  const BubbleMessageItem({
    super.key,
    required this.isFromMe,
    required this.bgColor,
    required this.msg,
  });

  final bool isFromMe;
  final Color bgColor;
  final MessageEntity msg;

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      clipper: isFromMe
          ? ChatBubbleClipper3(type: BubbleType.sendBubble)
          : ChatBubbleClipper3(type: BubbleType.receiverBubble),
      alignment: isFromMe ? Alignment.topRight : Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      margin: EdgeInsets.all(0),
      backGroundColor: bgColor,
      child: CustomMessageContent(
        isFromMe: isFromMe,
        msg: msg,
      ),
    );
  }
}
