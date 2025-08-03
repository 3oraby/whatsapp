import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/helpers/get_current_user_entity.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/enums/message_react.dart';
import 'package:whatsapp/features/chats/presentation/cubits/message_stream_cubit/message_stream_cubit.dart';

void showMessageOptionsMenu(BuildContext context, MessageEntity message) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('Reply'),
              onTap: () {
                Navigator.pop(context);
                _showEditDialog(context, message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy'),
              onTap: () {
                Navigator.pop(context); 
                _showEditDialog(context, message);
              },
            ),
            if (message.isFromMe)
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(context, message);
                },
              ),
            if (message.isFromMe)
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  BlocProvider.of<MessageStreamCubit>(context)
                      .emitDeleteMessage(messageId: message.id);
                },
              ),
            ListTile(
              leading: const Icon(Icons.emoji_emotions),
              title: const Text('React'),
              onTap: () {
                Navigator.pop(context);
                _showReactions(context, message);
              },
            ),
          ],
        ),
      );
    },
  );
}

void _showEditDialog(BuildContext context, MessageEntity message) {
  final controller = TextEditingController(text: message.content);
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Edit message"),
      content: TextField(controller: controller),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<MessageStreamCubit>(context).emitEditMessage(
              messageId: message.id,
              newContent: controller.text,
            );
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    ),
  );
}

void _showReactions(BuildContext context, MessageEntity message) {
  showModalBottomSheet(
    context: context,
    builder: (_) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _reactIcon(context, "❤️", MessageReact.love, message),
        // _reactIcon(context, "👍", MessageReact.like, message),
        // _reactIcon(context, "😂", MessageReact.haha, message),
      ],
    ),
  );
}

Widget _reactIcon(
  BuildContext context,
  String emoji,
  MessageReact type,
  MessageEntity message,
) {
  final currentUserId = getCurrentUserEntity()!.id;
  final hasReact = message.hasReactFromUser(currentUserId);

  return IconButton(
    onPressed: () {
      Navigator.pop(context);
      BlocProvider.of<MessageStreamCubit>(context).emitMessageReaction(
        messageId: message.id,
        reactType: type,
        isCreate: !hasReact,
      );
    },
    icon: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: hasReact ? Colors.grey.shade300 : Colors.transparent,
      ),
      padding: const EdgeInsets.all(8),
      child: Text(
        emoji,
        style: TextStyle(
          fontSize: 28,
          fontWeight: hasReact ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}
