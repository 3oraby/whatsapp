import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';
import 'package:whatsapp/core/widgets/custom_background_icon.dart';
import 'package:whatsapp/core/widgets/custom_text_form_field.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/stories/data/models/create_story_request_model.dart';
import 'package:whatsapp/features/stories/domain/entities/create_story_request_entity.dart';
import 'package:whatsapp/features/stories/presentation/cubits/create_new_story/create_new_story_cubit.dart';

class CreateNewStoryScreen extends StatelessWidget {
  const CreateNewStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.createStoryBackgroundColor,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            // show pop up menu
          },
          icon: Icon(
            Icons.cancel_rounded,
            color: Colors.white,
            size: 34,
          ),
        ),
      ),
      body: CreateNewStoryBody(),
    );
  }
}

class CreateNewStoryBody extends StatefulWidget {
  const CreateNewStoryBody({
    super.key,
  });

  @override
  State<CreateNewStoryBody> createState() => _CreateNewStoryBodyState();
}

class _CreateNewStoryBodyState extends State<CreateNewStoryBody> {
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void createStory() {
    final text = textEditingController.text.trim();
    log("Sending: $text");
    CreateStoryRequestEntity createStoryRequestEntity =
        CreateStoryRequestEntity(
      content: text,
    );
    BlocProvider.of<CreateNewStoryCubit>(context).createNewStory(
      data:
          CreateStoryRequestModel.fromEntity(createStoryRequestEntity).toJson(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[600],
      child: Column(
        children: [
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              trackVisibility: true,
              interactive: true,
              child: Center(
                child: CustomTextFormFieldWidget(
                  contentPadding: AppConstants.horizontalPadding,
                  controller: textEditingController,
                  scrollController: scrollController,
                  focusNode: focusNode,
                  fillColor: Colors.transparent,
                  borderWidth: 0,
                  borderColor: Colors.transparent,
                  focusedBorderColor: Colors.transparent,
                  enabledBorderColor: Colors.transparent,
                  maxLines: null,
                  hintText: "Type a status",
                  hintStyle: AppTextStyles.poppinsMedium(context, 32)
                      .copyWith(color: Colors.grey[300]),
                  textAlign: TextAlign.center,
                  cursorHeight: 55,
                  cursorColor: Colors.white,
                  textStyle: AppTextStyles.poppinsMedium(context, 30)
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
          const VerticalGap(24),
          Container(
            color: Colors.amber,
            height: 140,
            child: AnimatedOpacity(
              opacity:
                  textEditingController.text.trim().isNotEmpty ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 50),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomBackgroundIcon(
                        onTap: createStory,
                        iconData: Icons.send,
                        iconColor: Colors.white,
                        backgroundColor: AppColors.primary,
                      ),
                    ],
                  ),
                  const VerticalGap(40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
