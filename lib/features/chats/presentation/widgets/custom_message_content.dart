import 'package:flutter/material.dart';
import 'package:whatsapp/core/services/time_ago_service.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';

class CustomMessageContent extends StatelessWidget {
  const CustomMessageContent({
    super.key,
    required this.isFromMe,
    required this.msg,
  });

  final bool isFromMe;
  final MessageEntity msg;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            msg.content ?? "content",
            style: AppTextStyles.poppinsMedium(context, 16),
          ),
          const VerticalGap(4),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                TimeAgoService.formatTimeOnly(msg.createdAt),
                style: AppTextStyles.poppinsMedium(context, 11).copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const HorizontalGap(4),
              if (isFromMe)
                Icon(
                  msg.status == 'read'
                      ? Icons.done_all
                      : msg.status == 'deliverd'
                          ? Icons.check
                          : Icons.access_time,
                  size: 14,
                  color: msg.status == 'read'
                      ? Colors.blue
                      : Theme.of(context).colorScheme.secondary,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
