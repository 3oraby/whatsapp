import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/features/chats/presentation/cubits/message_stream_cubit/message_stream_cubit.dart';

class SendMessageSection extends StatefulWidget {
  final void Function(String) sendMessage;
  final int chatId;

  const SendMessageSection({
    super.key,
    required this.sendMessage,
    required this.chatId,
  });

  @override
  State<SendMessageSection> createState() => _SendMessageSectionState();
}

class _SendMessageSectionState extends State<SendMessageSection> {
  final TextEditingController _controller = TextEditingController();
  Timer? _typingTimer;
  bool _isTyping = false;

  void _onTextChanged(String text) {
    if (text.trim().isEmpty) {
      _stopTyping();
      return;
    }

    if (!_isTyping) {
      _isTyping = true;
      context.read<MessageStreamCubit>().emitTyping(chatId: widget.chatId);
    }

    _typingTimer?.cancel();
  _typingTimer = Timer(const Duration(seconds: 2), () {
      _stopTyping();
    });
  }

  void _stopTyping() {
    if (_isTyping) {
      _isTyping = false;
      context.read<MessageStreamCubit>().emitStopTyping(chatId: widget.chatId);
    }
    _typingTimer?.cancel();
  }

  void _onSendPressed() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.sendMessage(text);
    _controller.clear();
    _stopTyping();
  }

  @override
  void dispose() {
    _controller.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: AppColors.lightChatAppBarColor,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.green),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: _onTextChanged,
              style: AppTextStyles.poppinsMedium(context, 16),
              decoration: InputDecoration(
                hintText: "Type your message...",
                hintStyle: AppTextStyles.poppinsRegular(context, 14),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.primary),
            onPressed: _onSendPressed,
          ),
        ],
      ),
    );
  }
}
