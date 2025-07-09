import 'package:flutter/material.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/presentation/widgets/bubble_message_item.dart';
import 'package:whatsapp/features/chats/presentation/widgets/normal_message_item.dart';

class CustomBubbleMessageItem extends StatelessWidget {
  const CustomBubbleMessageItem({
    super.key,
    required this.isFromMe,
    required this.msg,
    required this.showClipper,
    this.repliedMsg,
  });

  final bool isFromMe;
  final MessageEntity msg;
  final bool showClipper;
  final MessageEntity? repliedMsg;

  @override
  Widget build(BuildContext context) {

    return showClipper
        ? BubbleMessageItem(
            isFromMe: isFromMe,
            msg: msg,
            repliedMsg: repliedMsg,
          )
        : Padding(
            padding: EdgeInsets.only(
              right: isFromMe ? 8 : 0,
              left: isFromMe ? 0 : 8,
            ),
            child: NormalMessageItem(
              isFromMe: isFromMe,
              msg: msg,
              repliedMsg: repliedMsg,
            ),
          );
  }
}
