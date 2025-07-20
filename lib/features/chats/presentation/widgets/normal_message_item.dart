import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/presentation/widgets/custom_message_content.dart';
import 'package:whatsapp/features/chats/presentation/widgets/show_message_reacts_count.dart';

class NormalMessageItem extends StatelessWidget {
  const NormalMessageItem({
    super.key,
    required this.isFromMe,
    required this.msg,
    this.repliedMsg,
  });

  final bool isFromMe;
  final MessageEntity msg;
  final MessageEntity? repliedMsg;

  @override
  Widget build(BuildContext context) {
    final bool isRepliedMessage = repliedMsg != null;
    final bgColor = isFromMe ? AppColors.myMessageLight : Colors.grey.shade200;

    return Column(
      crossAxisAlignment:
          isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Align(
          alignment: isFromMe ? Alignment.topRight : Alignment.topLeft,
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(
                AppConstants.messageBorderRadius,
              ),
            ),
            padding: msg.mediaUrl == null
                ? EdgeInsets.only(
                    top: isRepliedMessage ? 4 : 6,
                    bottom: 4,
                    left: isRepliedMessage ? 4 : 26,
                    right: isRepliedMessage ? 4 : 8,
                  )
                : EdgeInsets.only(
                    top: isRepliedMessage ? 4 : 6,
                    bottom: 4,
                    left: isRepliedMessage ? 2 : 4,
                    right: isRepliedMessage ? 2 : 4,
                  ),
            child: CustomMessageContent(
              isFromMe: isFromMe,
              msg: msg,
              repliedMsg: repliedMsg,
            ),
          ),
        ),
        if (
            // msg.reaction != null &&
            // msg.reactionCount != null &&
            msg.reactsCount > 0)
          ShowMessageReactsCount(msg: msg),
      ],
    );
  }
}
