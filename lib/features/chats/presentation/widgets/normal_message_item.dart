import 'package:flutter/material.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/presentation/widgets/custom_message_content.dart';

class NormalMessageItem extends StatelessWidget {
  const NormalMessageItem({
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
    return Align(
      alignment: isFromMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: 24,
          right: 8,
        ),
        child: CustomMessageContent(
          isFromMe: isFromMe,
          msg: msg,
        ),
      ),
    );
  }
}
