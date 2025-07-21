import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_text_form_field.dart';
import 'package:whatsapp/core/widgets/gallery_image_picker.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/features/chats/presentation/cubits/message_stream_cubit/message_stream_cubit.dart';

class SendMessageSection extends StatefulWidget {
  final VoidCallback sendMessage;
  final TextEditingController contentController;
  final void Function(File mediaFile) onImageSelected;
  final int chatId;

  const SendMessageSection({
    super.key,
    required this.chatId,
    required this.sendMessage,
    required this.contentController,
    required this.onImageSelected,
  });

  @override
  State<SendMessageSection> createState() => _SendMessageSectionState();
}

class _SendMessageSectionState extends State<SendMessageSection> {
  Timer? _typingTimer;
  bool _isTyping = false;
  File? _selectedImageFile;

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
    widget.sendMessage();
    widget.contentController.clear();
    _stopTyping();
    setState(() {
      _selectedImageFile = null;
    });
  }

  @override
  void dispose() {
    widget.contentController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  Future<dynamic> showGalleryImages(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: AppTextStyles.poppinsBold(context, 16),
                ),
              ),
              const HorizontalGap(120), // change it later
              Text(
                "Photos",
                style: AppTextStyles.poppinsBold(context, 16),
              ),
            ],
          ),
          Expanded(
            child: GalleryImagePicker(
              onImageSelected: (image) {
                image.originFile.then((file) {
                  if (file != null) {
                    setState(() {
                      _selectedImageFile = file;
                    });
                    widget.onImageSelected(file);
                  }
                });
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
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
            onPressed: () {
              showGalleryImages(context);
            },
          ),
          const HorizontalGap(16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: CustomTextFormFieldWidget(
                controller: widget.contentController,
                onChanged: _onTextChanged,
                hintText: "Type your message...",
                hintStyle: AppTextStyles.poppinsRegular(context, 14),
                textStyle: AppTextStyles.poppinsMedium(context, 16),
                fillColor: Colors.white,
                borderRadius: 40,
                borderWidth: 0,
                enabledBorderColor: Colors.transparent,
                borderColor: Colors.transparent,
                focusedBorderColor: Colors.transparent,
              ),
            ),
          ),
          const HorizontalGap(16),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: widget.contentController,
            builder: (context, value, child) {
              final hasText = value.text.trim().isNotEmpty;
              final hasImage = _selectedImageFile != null;
              final canSend = hasText || hasImage;

              return IconButton(
                icon: Icon(
                  canSend ? Icons.send : Icons.camera_alt_outlined,
                  color: canSend ? AppColors.primary : Colors.black,
                  size: 32,
                ),
                onPressed: canSend ? _onSendPressed : () {},
              );
            },
          ),
        ],
      ),
    );
  }
}
