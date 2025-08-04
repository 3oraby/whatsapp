import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/cubit/save_media_cubit/save_media_cubit.dart';
import 'package:whatsapp/core/helpers/show_custom_snack_bar.dart';
import 'package:whatsapp/core/widgets/custom_option_widget.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/presentation/cubits/message_stream_cubit/message_stream_cubit.dart';

class MessageInteractionMenu extends StatefulWidget {
  final MessageEntity message;
  final VoidCallback onReply;
  final MessageStreamCubit messageStreamCubit;

  const MessageInteractionMenu({
    super.key,
    required this.message,
    required this.onReply,
    required this.messageStreamCubit,
  });

  @override
  State<MessageInteractionMenu> createState() => _MessageInteractionMenuState();
}

class _MessageInteractionMenuState extends State<MessageInteractionMenu> {
  Future<void> _handleCopy(BuildContext context) async {
    if (widget.message.content != null && widget.message.content!.isNotEmpty) {
      await Clipboard.setData(ClipboardData(
        text: widget.message.content!,
      ));

      showSnackBarResult("Copied to clipboard");
    }
  }

  void showSnackBarResult(String message) {
    if (mounted) {
      showCustomSnackBar(context, message);
    }
  }

  void _showEditDialog() {
    final controller = TextEditingController(text: widget.message.content);
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
              widget.messageStreamCubit.emitEditMessage(
                messageId: widget.message.id,
                newContent: controller.text,
              );
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _deleteMessage() {
    Navigator.pop(context);
    widget.messageStreamCubit
        .emitDeleteMessage(messageId: widget.message.id);
  }

  void _saveMedia() {
    BlocProvider.of<SaveMediaCubit>(context).saveMedia(
      widget.message.mediaUrl!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.6,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CustomOptionWidget(
            icon: Icons.reply,
            label: "Reply",
            onTap: widget.onReply,
          ),
          if (widget.message.mediaUrl == null) ...[
            const Divider(
              height: 24,
            ),
            CustomOptionWidget(
              icon: Icons.copy,
              label: "Copy",
              onTap: () => _handleCopy(context),
            ),
            const Divider(
              height: 24,
            ),
            CustomOptionWidget(
              icon: Icons.edit,
              label: "Edit",
              onTap: () => _showEditDialog(),
            ),
          ],
          if (widget.message.mediaUrl != null) ...[
            const Divider(
              height: 24,
            ),
            CustomOptionWidget(
              icon: Icons.save_alt,
              label: "Save",
              onTap: () => _saveMedia(),
            ),
          ],
          if (widget.message.isFromMe) ...[
            const Divider(
              height: 24,
            ),
            CustomOptionWidget(
              icon: Icons.delete,
              themeColor: Colors.red,
              label: "Delete",
              onTap: () => _deleteMessage(),
            ),
          ]
        ],
      ),
    );
  }
}
