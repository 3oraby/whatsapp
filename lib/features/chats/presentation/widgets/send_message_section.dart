import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/core/services/image_picker_service.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_text_form_field.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/features/chats/presentation/cubits/message_stream_cubit/message_stream_cubit.dart';
import 'package:whatsapp/features/chats/presentation/widgets/selected_image_banner.dart';

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

  Future<void> _onAddImagePressed() async {
    try {
      ImagePickerService imagePickerService = ImagePickerService();

      final image = await imagePickerService.pickImageFromGallery();

      if (image != null) {
        _selectedImageFile = File(image.path);
        if (_selectedImageFile != null) {
          widget.onImageSelected(_selectedImageFile!);
        }
      }
    } catch (e) {
      debugPrint(
          "There is an exception with adding an image in AddUserProfileScreen: $e");
      throw CustomException(message: "Failed to upload image".tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_selectedImageFile != null)
          SelectedImageBanner(
            imageFile: _selectedImageFile!,
            onCancel: () {
              setState(() {
                _selectedImageFile = null;
              });
            },
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: AppColors.lightChatAppBarColor,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.black),
                onPressed: () {
                  _onAddImagePressed();
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
        ),
      ],
    );
  }
}
