import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_network_image.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';

class ReplyToMessageBanner extends StatelessWidget {
  final MessageEntity replyMessage;
  final VoidCallback onCancel;

  const ReplyToMessageBanner({
    super.key,
    required this.replyMessage,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final Color lineColor =
        replyMessage.isFromMe ? AppColors.primary : Colors.deepOrange;

    return Container(
      height: 70,
      color: AppColors.lightChatAppBarColor,
      padding: EdgeInsets.only(right: AppConstants.horizontalPadding),
      child: Row(
        children: [
          Container(width: 7, color: lineColor),
          const HorizontalGap(14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        replyMessage.isFromMe
                            ? "You"
                            : replyMessage.sender!.name,
                        maxLines: 1,
                        style: AppTextStyles.poppinsBold(context, 16).copyWith(
                          color: lineColor,
                        ),
                      ),
                      const VerticalGap(4),
                      if (replyMessage.content != null)
                        Text(
                          replyMessage.content!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      else
                        Row(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 20,
                            ),
                            const HorizontalGap(6),
                            Text(
                              "Photo",
                              style: AppTextStyles.poppinsBold(context, 14)
                                  .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  if (replyMessage.mediaUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomNetworkImage(
                        imageUrl: replyMessage.mediaUrl!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }
}
