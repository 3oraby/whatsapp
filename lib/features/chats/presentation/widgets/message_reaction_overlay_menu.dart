import 'package:flutter/material.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/enums/message_react.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class MessageReactionOverlayMenu extends StatelessWidget {
  const MessageReactionOverlayMenu({
    super.key,
    required this.currentUser,
    required this.msg,
    required this.onReactTap,
  });

  final UserEntity currentUser;
  final MessageEntity msg;
  final void Function(MessageReact reactType, bool isCreate) onReactTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(60),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['❤️', '😂', '👍'].map((react) {
          final currentUserId = currentUser.id;
          final hasReact = msg.hasReactFromUser(currentUserId);

          final MessageReact reactType;
          if (hasReact) {
            reactType =
                msg.getMessageReactType(currentUserId) ?? MessageReact.love;
          } else {
            reactType = MessageReactExtension.fromString(react);
          }

          final isReactType = hasReact &&
              MessageReactExtension.getEmojiFromReact(
                    react: reactType.value,
                  ) ==
                  react;
          return GestureDetector(
            onTap: () {
              onReactTap(reactType, !hasReact);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: isReactType
                    ? const EdgeInsets.all(6)
                    : const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isReactType ? Colors.grey.shade400 : Colors.white,
                  borderRadius: BorderRadius.circular(360),
                ),
                child: Text(react, style: const TextStyle(fontSize: 24)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
