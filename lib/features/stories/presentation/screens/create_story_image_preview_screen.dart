import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:whatsapp/core/helpers/show_discard_confirmation_dialog.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';
import 'package:whatsapp/core/widgets/custom_cancel_icon_button.dart';
import 'package:whatsapp/core/widgets/custom_text_form_field.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/features/stories/presentation/cubits/create_new_story/create_new_story_cubit.dart';
import 'package:whatsapp/features/stories/presentation/widgets/custom_send_story_button.dart';

class CreateStoryImagePreviewScreen extends StatefulWidget {
  const CreateStoryImagePreviewScreen({
    super.key,
    required this.createNewStoryCubit,
  });

  final CreateNewStoryCubit createNewStoryCubit;
  @override
  State<CreateStoryImagePreviewScreen> createState() =>
      _CreateStoryImagePreviewScreenState();
}

class _CreateStoryImagePreviewScreenState
    extends State<CreateStoryImagePreviewScreen> {
  final TextEditingController textController = TextEditingController();
  final ScrollController textFieldScrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
    textFieldScrollController.dispose();
  }

  void sendStory() {
    final text = textController.text.trim();
    log("Sending story with text: $text");
    widget.createNewStoryCubit.createStoryRequestEntity.content = text;
    widget.createNewStoryCubit.createNewStory();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          showDiscardConfirmationDialog(
            context: context,
            onConfirm: () {
              Navigator.of(context).pop();
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: CustomCancelIconButton(
            onTap: () {
              showDiscardConfirmationDialog(
                context: context,
                onConfirm: () {
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            if (widget.createNewStoryCubit.createStoryRequestEntity.imageFile !=
                null)
              Center(
                child: Image.file(
                  widget
                      .createNewStoryCubit.createStoryRequestEntity.imageFile!,
                  fit: BoxFit.contain,
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 30,
              child: CustomAppPadding(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 120,
                        ),
                        child: SingleChildScrollView(
                          controller: textFieldScrollController,
                          scrollDirection: Axis.vertical,
                          reverse: true,
                          child: CustomTextFormFieldWidget(
                            controller: textController,
                            maxLines: null,
                            textStyle: AppTextStyles.poppinsMedium(context, 18)
                                .copyWith(
                              color: Colors.white,
                            ),
                            fillColor: Colors.black54,
                            contentPadding: 16,
                            hintText: 'Add a caption...',
                            hintStyle: AppTextStyles.poppinsMedium(context, 18)
                                .copyWith(
                              color: AppColors.textSecondaryDark,
                            ),
                            borderColor: Colors.grey,
                            borderRadius: 40,
                            borderWidth: 1,
                          ),
                        ),
                      ),
                    ),
                    const HorizontalGap(18),
                    CustomSendStoryButton(
                      onTap: sendStory,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
