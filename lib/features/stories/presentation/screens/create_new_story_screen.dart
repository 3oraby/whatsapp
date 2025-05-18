import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';
import 'package:whatsapp/core/widgets/custom_background_icon.dart';
import 'package:whatsapp/core/widgets/custom_text_form_field.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/features/stories/presentation/widgets/create_story_gallery_picker_tab.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/stories/presentation/cubits/create_new_story/create_new_story_cubit.dart';

class CreateNewStoryScreen extends StatelessWidget {
  const CreateNewStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CreateNewStoryBody(),
    );
  }
}

class CreateNewStoryBody extends StatefulWidget {
  const CreateNewStoryBody({super.key});

  @override
  State<CreateNewStoryBody> createState() => _CreateNewStoryBodyState();
}

class _CreateNewStoryBodyState extends State<CreateNewStoryBody>
    with TickerProviderStateMixin {
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  late TabController tabController;
  late CreateNewStoryCubit createNewStoryCubit;

  bool _wasNotEmpty = false;
  AssetEntity? selectedImage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });

    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 1,
    );

    textEditingController.addListener(() {
      final isNotEmpty = textEditingController.text.trim().isNotEmpty;
      if (isNotEmpty != _wasNotEmpty) {
        _wasNotEmpty = isNotEmpty;
        log("message");
        setState(() {});
      }
    });

    createNewStoryCubit = BlocProvider.of<CreateNewStoryCubit>(context);
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
    createNewStoryCubit.createStoryRequestEntity.content = text;
    createNewStoryCubit.createNewStory();
  }

  void onImageSelected(AssetEntity image) async {
    log("selected image: ${image.relativePath}");
    setState(() {
      selectedImage = image;
      textEditingController.clear();
      _wasNotEmpty = false;
    });

    createNewStoryCubit.createStoryRequestEntity.imageFile =
        await selectedImage!.file;

    _navigateToImagePreviewScreen();
  }

  _navigateToImagePreviewScreen() {
    Navigator.of(context)
        .pushNamed(
      Routes.createStoryImagePreviewRoute,
      arguments: createNewStoryCubit,
    )
        .then((_) {
      setState(() {
        selectedImage = null;
        textEditingController.clear();
        _wasNotEmpty = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[600],
      child: Column(
        children: [
          AppBar(
            backgroundColor: AppColors.createStoryBackgroundColor,
            surfaceTintColor: Colors.transparent,
            leading: CustomCancelIconButton(),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                CreateStoryGalleryPickerTab(
                  onImageSelected: onImageSelected,
                ),
                Scrollbar(
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
                      cursorHeight: 90,
                      cursorColor: Colors.white,
                      textStyle: AppTextStyles.poppinsMedium(context, 30)
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalGap(24),
          Container(
            color: const Color.fromARGB(255, 74, 90, 114),
            height: 120,
            child: CustomAppPadding(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedOpacity(
                    opacity:
                        textEditingController.text.trim().isEmpty ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 100),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: TabBar(
                        controller: tabController,
                        isScrollable: true,
                        indicatorColor: Colors.transparent,
                        dividerColor: Colors.transparent,
                        unselectedLabelColor: Colors.white70,
                        unselectedLabelStyle:
                            AppTextStyles.poppinsMedium(context, 20),
                        labelStyle:
                            AppTextStyles.poppinsMedium(context, 22).copyWith(
                          color: AppColors.primary,
                        ),
                        tabs: const [
                          Tab(text: "PHOTO"),
                          Tab(text: "TEXT"),
                        ],
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: textEditingController.text.trim().isNotEmpty
                        ? 1.0
                        : 0.0,
                    duration: const Duration(milliseconds: 100),
                    child: CustomSendButton(
                      onTap: createStory,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCancelIconButton extends StatelessWidget {
  const CustomCancelIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const Icon(
        Icons.cancel_rounded,
        color: Colors.white,
        size: 34,
      ),
    );
  }
}

class CustomSendButton extends StatelessWidget {
  const CustomSendButton({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return CustomBackgroundIcon(
      onTap: onTap,
      iconData: Icons.send,
      iconColor: Colors.white,
      backgroundColor: AppColors.primary,
    );
  }
}

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

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CustomCancelIconButton(),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          if (widget.createNewStoryCubit.createStoryRequestEntity.imageFile !=
              null)
            Center(
              child: Image.file(
                widget.createNewStoryCubit.createStoryRequestEntity.imageFile!,
                fit: BoxFit.contain,
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: CustomAppPadding(
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextFormFieldWidget(
                      controller: textController,
                      maxLines: null,
                      textStyle:
                          AppTextStyles.poppinsMedium(context, 18).copyWith(
                        color: Colors.white,
                      ),
                      fillColor: Colors.black54,
                      contentPadding: 16,
                      hintText: 'Add a caption...',
                      hintStyle:
                          AppTextStyles.poppinsMedium(context, 18).copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                      borderColor: Colors.grey,
                      borderRadius: 40,
                      borderWidth: 1,
                    ),
                  ),
                  const HorizontalGap(18),
                  CustomSendButton(
                    onTap: sendStory,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
