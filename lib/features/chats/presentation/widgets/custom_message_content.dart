import 'package:flutter/material.dart';
import 'package:whatsapp/core/services/time_ago_service.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/presentation/widgets/build_message_status_icon.dart';
import 'package:whatsapp/features/chats/presentation/widgets/replied_message_box.dart';

class CustomMessageContent extends StatelessWidget {
  const CustomMessageContent({
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
    return IntrinsicWidth(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.6,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (repliedMsg != null)
              RepliedMessageBox(
                msg: repliedMsg!,
              ),
            Text(
              msg.content ?? "content",
              style: AppTextStyles.poppinsMedium(context, 20),
            ),
            const VerticalGap(3),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (msg.isEdited) ...[
                  Text(
                    "Edited",
                    style: AppTextStyles.poppinsMedium(context, 14).copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const HorizontalGap(6),
                ],
                Text(
                  TimeAgoService.formatTimeOnly(msg.createdAt),
                  style: AppTextStyles.poppinsMedium(context, 14).copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const HorizontalGap(4),
                if (isFromMe)
                  BuildMessageStatusIcon(
                    messageStatus: msg.status,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
