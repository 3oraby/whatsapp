import 'package:flutter/material.dart';
import 'package:whatsapp/features/chats/domain/enums/message_status.dart';

class BuildMessageStatusIcon extends StatelessWidget {
  const BuildMessageStatusIcon({
    super.key,
    required this.messageStatus,
  });
  final MessageStatus messageStatus;

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color color;

    switch (messageStatus) {
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
