import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';
import 'package:whatsapp/core/widgets/custom_cancel_icon_button.dart';
import 'package:whatsapp/features/stories/presentation/widgets/create_story_gallery_picker_tab.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/stories/presentation/cubits/create_new_story/create_new_story_cubit.dart';
import 'package:whatsapp/features/stories/presentation/widgets/create_story_simple_text_tab.dart';
import 'package:whatsapp/features/stories/presentation/widgets/create_story_tab_bars.dart';
import 'package:whatsapp/features/stories/presentation/widgets/custom_send_story_button.dart';

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
  final ScrollController scrollController = ScrollController();
  late TabController tabController;
  late CreateNewStoryCubit createNewStoryCubit;

  bool _wasNotEmpty = false;
  AssetEntity? selectedImage;

  @override
  void initState() {
    super.initState();

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
    scrollController.dispose();
    super.dispose();
  }

  void createStory() {
    final text = textEditingController.text.trim();
    createNewStoryCubit.createStoryRequestEntity.content = text;
    createNewStoryCubit.createNewStory();
  }

  void onImageSelected(AssetEntity image) async {
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
      color: AppColors.createStoryBackgroundColor,
      child: Column(
        children: [
          AppBar(
            backgroundColor: AppColors.createStoryBackgroundColor,
            surfaceTintColor: Colors.transparent,
            leading: CustomCancelIconButton(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                CreateStoryGalleryPickerTab(
                  onImageSelected: onImageSelected,
                ),
                CreateStorySimpleTextTab(
                  scrollController: scrollController,
                  textEditingController: textEditingController,
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
                      child: CreateStoryTabBars(tabController: tabController),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: textEditingController.text.trim().isNotEmpty
                        ? 1.0
                        : 0.0,
                    duration: const Duration(milliseconds: 100),
                    child: CustomSendStoryButton(
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
