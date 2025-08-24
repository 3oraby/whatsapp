import 'package:flutter/material.dart';
import 'package:whatsapp/core/services/time_ago_service.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_file_image.dart';
import 'package:whatsapp/core/widgets/custom_network_image.dart';
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
          maxWidth: MediaQuery.sizeOf(context).width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (repliedMsg != null && msg.isDeleted != true)
              RepliedMessageBox(
                msg: repliedMsg!,
              ),
            if (msg.isDeleted)
              Row(
                children: [
                  Icon(
                    Icons.block,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const HorizontalGap(6),
                  Text(
                    "You deleted this message.",
                    style: AppTextStyles.poppinsMedium(context, 16).copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const HorizontalGap(6),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (msg.mediaUrl != null)
                    CustomNetworkImage(
                      imageUrl: msg.mediaUrl!,
                      width: 400,
                      height: 400,
                      fit: BoxFit.cover,
                      borderRadius: AppConstants.messageBorderRadius,
                    )
                  else if (msg.mediaFile != null)
                    CustomFileImage(
                      file: msg.mediaFile!,
                      width: 400,
                      height: 400,
                      fit: BoxFit.cover,
                      borderRadius: AppConstants.messageBorderRadius,
                    ),
                  const VerticalGap(4),
                  if (msg.content != null && msg.content!.isNotEmpty) ...[
                    const VerticalGap(2),
                    Text(
                      msg.content!,
                      style: AppTextStyles.poppinsMedium(context, 20),
                    ),
                  ]
                ],
              ),
            const VerticalGap(3),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (msg.isEdited && !msg.isDeleted) ...[
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
                if (isFromMe && !msg.isDeleted)
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
