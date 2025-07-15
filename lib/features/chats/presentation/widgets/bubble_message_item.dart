import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/widgets/custom_loading_indicator.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/presentation/widgets/custom_message_content.dart';
import 'package:whatsapp/features/chats/presentation/widgets/show_message_reacts_count.dart';

class BubbleMessageItem extends StatelessWidget {
  const BubbleMessageItem({
    super.key,
    required this.isFromMe,
    this.msg,
    this.repliedMsg,
    this.isTyping = false,
  });

  final bool isFromMe;
  final MessageEntity? msg;
  final MessageEntity? repliedMsg;
  final bool isTyping;

  @override
  Widget build(BuildContext context) {
    final bgColor = isFromMe ? AppColors.myMessageLight : Colors.grey.shade200;

    final bool isRepliedMessage = repliedMsg != null;
    return Column(
      crossAxisAlignment:
          isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        ChatBubble(
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
                ? isFromMe
                    ? 4
                    : 12
                : isFromMe
                    ? 25
                    : 33,
            right: isRepliedMessage
                ? isFromMe
                    ? 12
                    : 4
                : isFromMe
                    ? 16
                    : 9,
          ),
          margin: EdgeInsets.all(0),
          backGroundColor: bgColor,
          child: isTyping
              ? SizedBox(
                  height: 30,
                  width: 30,
                  child: CustomLoadingIndicator(),
                )
              : CustomMessageContent(
                  isFromMe: isFromMe,
                  msg: msg!,
                  repliedMsg: repliedMsg,
                ),
        ),
        if (
            // msg.reaction != null &&
            // msg.reactionCount != null &&
            msg != null && msg!.reactsCount > 0)
          ShowMessageReactsCount(msg: msg!),
      ],
    );
  }
}
