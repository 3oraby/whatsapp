import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                _showReactions(context, message.id);
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

void _showReactions(BuildContext context, int messageId) {
  showModalBottomSheet(
    context: context,
    builder: (_) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _reactIcon(context, "❤️", MessageReact.love, messageId),
        _reactIcon(context, "👍", MessageReact.like, messageId),
        _reactIcon(context, "😂", MessageReact.haha, messageId),
      ],
    ),
  );
}

Widget _reactIcon(
    BuildContext context, String emoji, MessageReact type, int messageId) {
  return IconButton(
    onPressed: () {
      Navigator.pop(context);
      BlocProvider.of<MessageStreamCubit>(context).emitMessageReaction(
        messageId: messageId,
        reactType: type,
      );
    },
    icon: Text(emoji, style: const TextStyle(fontSize: 28)),
  );
}
