import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/presentation/widgets/bubble_message_item.dart';
import 'package:whatsapp/features/chats/presentation/widgets/normal_message_item.dart';

class CustomBubbleMessageItem extends StatelessWidget {
  const CustomBubbleMessageItem({
    super.key,
    required this.isFromMe,
    required this.msg,
    required this.showClipper,
  });

  final bool isFromMe;
  final MessageEntity msg;
  final bool showClipper;

  @override
  Widget build(BuildContext context) {
    final bgColor = isFromMe ? AppColors.myMessageLight : Colors.grey.shade200;

    return showClipper
        ? BubbleMessageItem(
            isFromMe: isFromMe,
            bgColor: bgColor,
            msg: msg,
          )
        : Padding(
            padding: EdgeInsets.only(
              right: isFromMe ? 8 : 0,
              left: isFromMe ? 0 : 8,
            ),
            child: NormalMessageItem(
              isFromMe: isFromMe,
              bgColor: bgColor,
              msg: msg,
            ),
          );
  }
}
