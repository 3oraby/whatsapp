import 'package:flutter/material.dart';
import 'package:whatsapp/core/services/time_ago_service.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/enums/message_status.dart';

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
        maxWidth: MediaQuery.sizeOf(context).width * 0.7,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            msg.content ?? "content",
            style: AppTextStyles.poppinsMedium(context, 20),
          ),
          const VerticalGap(3),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                TimeAgoService.formatTimeOnly(msg.createdAt),
                style: AppTextStyles.poppinsMedium(context, 14).copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const HorizontalGap(4),
              if (isFromMe) _buildStatusIcon(msg.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status) {
    IconData iconData;
    Color color;

    switch (status) {
      case MessageStatus.pending:
        iconData = Icons.schedule;
        color = Colors.grey;
        break;
      case MessageStatus.sent:
        iconData = Icons.check;
        color = Colors.grey;
        break;
      case MessageStatus.delivered:
        iconData = Icons.done_all;
        color = Colors.grey;
        break;
      case MessageStatus.read:
        iconData = Icons.done_all;
        color = Colors.blue;
        break;
    }

    return Icon(
      iconData,
      size: 20,
      color: color,
    );
  }
}
