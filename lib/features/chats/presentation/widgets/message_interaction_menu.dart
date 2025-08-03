import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/cubit/save_media_cubit/save_media_cubit.dart';
import 'package:whatsapp/core/helpers/show_custom_snack_bar.dart';
import 'package:whatsapp/core/widgets/custom_option_widget.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';

class MessageInteractionMenu extends StatefulWidget {
  final MessageEntity message;
  final VoidCallback onReply;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MessageInteractionMenu({
    super.key,
    required this.message,
    required this.onReply,
    this.onEdit,
    this.onDelete,
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
          const Divider(
            height: 24,
          ),
          CustomOptionWidget(
            icon: Icons.copy,
            label: "Copy",
            onTap: () => _handleCopy(context),
          ),
          if (widget.message.mediaUrl != null) ...[
            const Divider(
              height: 24,
            ),
            CustomOptionWidget(
              icon: Icons.save_alt,
              label: "Save",
              onTap: () {
                BlocProvider.of<SaveMediaCubit>(context).saveMedia(
                  widget.message.mediaUrl!,
                );
              },
            ),
          ],
          if (widget.message.isFromMe) ...[
            const Divider(
              height: 24,
            ),
            CustomOptionWidget(
              icon: Icons.edit,
              label: "Edit",
              onTap: () {},
            ),
            const Divider(
              height: 24,
            ),
            CustomOptionWidget(
              icon: Icons.delete,
              themeColor: Colors.red,
              label: "Delete",
              onTap: () {},
            ),
          ]
        ],
      ),
    );
  }
}
