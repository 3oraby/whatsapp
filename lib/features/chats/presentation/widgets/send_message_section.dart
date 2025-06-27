import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';

class SendMessageSection extends StatefulWidget {
  const SendMessageSection({
    super.key,
    required this.sendMessage,
  });

  final void Function(String) sendMessage;

  @override
  State<SendMessageSection> createState() => _SendMessageSectionState();
}

class _SendMessageSectionState extends State<SendMessageSection> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MessageBar(
        messageBarColor: AppColors.lightChatAppBarColor,
        onSend: widget.sendMessage,
        sendButtonColor: AppColors.primary,
        textFieldTextStyle: AppTextStyles.poppinsMedium(context, 16),
        messageBarHintStyle: AppTextStyles.poppinsRegular(context, 14),
        messageBarHintText: "Type your message..",
        actions: [
          InkWell(
            child: Icon(
              Icons.add,
              color: Colors.black,
              size: 24,
            ),
            onTap: () {},
          ),
          Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: InkWell(
              child: Icon(
                Icons.camera_alt,
                color: Colors.green,
                size: 24,
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
