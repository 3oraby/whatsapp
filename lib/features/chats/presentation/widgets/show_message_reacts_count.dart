import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/enums/message_react.dart';

class ShowMessageReactsCount extends StatelessWidget {
  const ShowMessageReactsCount({
    super.key,
    required this.msg,
  });

  final MessageEntity msg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          MessageReactExtension.getEmojiFromReactWithCount(
            react: MessageReact.love.value,
            count: msg.reactsCount,
          ),
          style: AppTextStyles.poppinsMedium(context, 14).copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
