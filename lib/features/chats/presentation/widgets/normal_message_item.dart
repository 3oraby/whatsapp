import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/presentation/widgets/custom_message_content.dart';

class NormalMessageItem extends StatelessWidget {
  const NormalMessageItem({
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

    return Align(
      alignment: isFromMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(
            AppConstants.messageBorderRadius,
          ),
        ),
        padding:  EdgeInsets.only(
          top: isRepliedMessage ? 4 : 6,
          bottom: 4,
          left: isRepliedMessage ? 4 : 26,
          right: isRepliedMessage ? 4 : 8,
        ),
        child: CustomMessageContent(
          isFromMe: isFromMe,
          msg: msg,
          repliedMsg: repliedMsg,
        ),
      ),
    );
  }
}
